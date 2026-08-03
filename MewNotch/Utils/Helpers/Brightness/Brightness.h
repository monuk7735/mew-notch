//
//  Brightness.m
//  MewNotch
//
//  Created by Monu Kumar on 8/3/25.
//

#ifndef BRIGHTNESS_H_INCLUDED
#define BRIGHTNESS_H_INCLUDED

#import <Cocoa/Cocoa.h>

@interface Brightness : NSObject
+ (Brightness*) sharedInstance;
@property (getter=brightness, setter=setBrightness:) float brightness;
@property (nonatomic, readonly) float targetBrightness;
@property (nonatomic, readonly) BOOL isAnimating;

- (void)setBrightness:(float)value smooth:(BOOL)smooth;
@end

extern NSString *BrightnessNotification;

extern int DisplayServicesGetBrightness(CGDirectDisplayID display, float *brightness);
extern int DisplayServicesSetBrightness(CGDirectDisplayID display, float brightness);

#endif
