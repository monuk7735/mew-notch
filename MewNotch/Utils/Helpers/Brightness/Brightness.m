//
//  Brightness.m
//  MewNotch
//
//  Created by Monu Kumar on 8/3/25.
//

#include "Brightness.h"
#import <Foundation/Foundation.h>

#import <IOKit/IOKitLib.h>
#import <CoreVideo/CoreVideo.h>

NSString *BrightnessNotification = @"Brightness";

int DisplayServicesRegisterForBrightnessChangeNotifications(
    CGDirectDisplayID display,
    CGDirectDisplayID displayObserver,
    CFNotificationCallback callback
);

int DisplayServicesUnregisterForBrightnessChangeNotifications(
    CGDirectDisplayID display,
    CGDirectDisplayID displayObserver
);

@interface Brightness ()
- (void)displayBrightnessDidChange:(NSDictionary *) userInfo;
- (void)onDisplayLinkTick;
- (float)hardwareBrightness;
- (BOOL)shouldAnimate;
- (void)startDisplayLinkIfNeeded;
- (void)stopDisplayLink;
@end

static void DisplayBrightnessListener(
    CFNotificationCenterRef center,
    void *observer,
    CFNotificationName name,
    const void *object,
    CFDictionaryRef userInfo
) {
    [Brightness.sharedInstance
     performSelectorOnMainThread:@selector(displayBrightnessDidChange:)
        withObject:(__bridge id _Nullable)(userInfo)
        waitUntilDone:NO];
    
    return;
}

static CVReturn DisplayLinkBrightnessCallback(
    CVDisplayLinkRef displayLink,
    const CVTimeStamp *inNow,
    const CVTimeStamp *inOutputTime,
    CVOptionFlags flagsIn,
    CVOptionFlags *flagsOut,
    void *displayLinkContext
) {
    Brightness *brightnessObj = (__bridge Brightness *)displayLinkContext;
    [brightnessObj performSelectorOnMainThread:@selector(onDisplayLinkTick)
                                    withObject:nil
                                 waitUntilDone:NO];
    return kCVReturnSuccess;
}

@implementation Brightness
{
    float _targetBrightness;
    float _startBrightness;
    NSTimeInterval _animationStartTime;
    CVDisplayLinkRef _displayLink;
    BOOL _isAnimating;
}

@synthesize targetBrightness = _targetBrightness;
@synthesize isAnimating = _isAnimating;

+ (Brightness *)sharedInstance
{
    static Brightness *instance = 0;
    if (0 == instance)
        instance = [[Brightness alloc] init];
    return instance;
}

- (id)init
{
    self = [super init];
    if (nil == self)
        return nil;

    _targetBrightness = NAN;
    _isAnimating = NO;
    _displayLink = NULL;
    [self registerListener:YES];

    return self;
}

- (void)dealloc
{
    [self stopDisplayLink];
    if (_displayLink != NULL) {
        CVDisplayLinkRelease(_displayLink);
        _displayLink = NULL;
    }
    [self registerListener:NO];
}

- (float)hardwareBrightness
{
    float brightness = NAN;
    DisplayServicesGetBrightness(
        CGMainDisplayID(),
        &brightness
    );
    return brightness;
}

- (float)brightness
{
    if (_isAnimating && !isnan(_targetBrightness)) {
        return _targetBrightness;
    }
    
    float brightness = [self hardwareBrightness];
    if (!isnan(brightness)) {
        _targetBrightness = brightness;
    }
    
    return brightness;
}

- (BOOL)shouldAnimate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id obj = [defaults objectForKey:@"HUD_Brightness_AnimateChanges"];
    if (obj == nil) {
        return YES;
    }
    if ([obj isKindOfClass:[NSData class]]) {
        NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
        if ([str.lowercaseString containsString:@"true"]) {
            return YES;
        } else if ([str.lowercaseString containsString:@"false"]) {
            return NO;
        }
    }
    if ([obj respondsToSelector:@selector(boolValue)]) {
        return [obj boolValue];
    }
    return YES;
}

- (void)setBrightness:(float)value
{
    [self setBrightness:value smooth:[self shouldAnimate]];
}

- (void)startDisplayLinkIfNeeded
{
    if (_displayLink == NULL) {
        CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);
        CVDisplayLinkSetOutputCallback(_displayLink, DisplayLinkBrightnessCallback, (__bridge void *)self);
        CVDisplayLinkStart(_displayLink);
    } else if (!CVDisplayLinkIsRunning(_displayLink)) {
        CVDisplayLinkStart(_displayLink);
    }
}

- (void)stopDisplayLink
{
    if (_displayLink != NULL && CVDisplayLinkIsRunning(_displayLink)) {
        CVDisplayLinkStop(_displayLink);
    }
}

- (void)setBrightness:(float)value smooth:(BOOL)smooth
{
    value = fmaxf(0.0f, fminf(1.0f, value));
    
    if (!smooth) {
        [self stopDisplayLink];
        _isAnimating = NO;
        _targetBrightness = value;
        DisplayServicesSetBrightness(
            CGMainDisplayID(),
            value
        );
        return;
    }
    
    float currentBrightnessVal = _startBrightness;
    if (_isAnimating && !isnan(_targetBrightness) && !isnan(_startBrightness)) {
        // Calculate exact current interpolated brightness without blocking on hardware IOKit read
        NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - _animationStartTime;
        NSTimeInterval const kBrightnessAnimationDuration = 0.20;
        float t = (float)(elapsed / kBrightnessAnimationDuration);
        t = fmaxf(0.0f, fminf(1.0f, t));
        float progress = 1.0f - (1.0f - t) * (1.0f - t) * (1.0f - t);
        currentBrightnessVal = _startBrightness + (_targetBrightness - _startBrightness) * progress;
    } else {
        currentBrightnessVal = [self hardwareBrightness];
        if (isnan(currentBrightnessVal)) {
            currentBrightnessVal = 0.5f;
        }
    }
    
    if (fabsf(currentBrightnessVal - value) < 0.001f && !_isAnimating) {
        _targetBrightness = value;
        DisplayServicesSetBrightness(CGMainDisplayID(), value);
        return;
    }
    
    _startBrightness = currentBrightnessVal;
    _targetBrightness = value;
    _animationStartTime = [NSDate timeIntervalSinceReferenceDate];
    _isAnimating = YES;
    
    [[NSNotificationCenter defaultCenter]
        postNotificationName:BrightnessNotification
        object:self
        userInfo:@{@"value": @(value)}
    ];
    
    if ([NSThread isMainThread]) {
        [self startDisplayLinkIfNeeded];
    } else {
        [self performSelectorOnMainThread:@selector(startDisplayLinkIfNeeded) withObject:nil waitUntilDone:NO];
    }
}

- (void)onDisplayLinkTick
{
    if (!_isAnimating) {
        [self stopDisplayLink];
        return;
    }
    
    NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - _animationStartTime;
    NSTimeInterval const kBrightnessAnimationDuration = 0.20;
    
    if (elapsed >= kBrightnessAnimationDuration) {
        _isAnimating = NO;
        [self stopDisplayLink];
        DisplayServicesSetBrightness(CGMainDisplayID(), _targetBrightness);
        return;
    }
    
    float t = (float)(elapsed / kBrightnessAnimationDuration);
    t = fmaxf(0.0f, fminf(1.0f, t));
    
    // Smooth cubic ease-out curve matching Apple native deceleration
    float progress = 1.0f - (1.0f - t) * (1.0f - t) * (1.0f - t);
    
    float currentVal = _startBrightness + (_targetBrightness - _startBrightness) * progress;
    DisplayServicesSetBrightness(CGMainDisplayID(), currentVal);
}

- (void)registerListener:(BOOL)add
{
    if (add) {
        DisplayServicesRegisterForBrightnessChangeNotifications(
            CGMainDisplayID(),
            CGMainDisplayID(),
            DisplayBrightnessListener
        );
    } else {
        DisplayServicesUnregisterForBrightnessChangeNotifications(
            CGMainDisplayID(),
            CGMainDisplayID()
        );
    }
}

- (void)displayBrightnessDidChange:(NSDictionary *) userInfo
{
    if (_isAnimating) {
        return;
    }
    [[NSNotificationCenter defaultCenter]
        postNotificationName:BrightnessNotification
        object:self
        userInfo: userInfo
    ];
}
@end
