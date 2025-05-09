/**
 * @file NowPlaying.m
 *
 * @copyright 2018-2019 Bill Zissimopoulos
 */
/*
 * This file is part of EnergyBar.
 *
 * You can redistribute it and/or modify it under the terms of the GNU
 * General Public License version 3 as published by the Free Software
 * Foundation.
 */

#import "NowPlaying.h"

typedef void (^MRMediaRemoteGetNowPlayingInfoBlock)(NSDictionary *info);
typedef void (^MRMediaRemoteGetNowPlayingClientBlock)(id clientObj);
typedef void (^MRMediaRemoteGetNowPlayingApplicationIsPlayingBlock)(BOOL playing);

void MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_queue_t queue);
void MRMediaRemoteGetNowPlayingClient(dispatch_queue_t queue,
    MRMediaRemoteGetNowPlayingClientBlock block);
void MRMediaRemoteGetNowPlayingInfo(dispatch_queue_t queue,
    MRMediaRemoteGetNowPlayingInfoBlock block);
void MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_queue_t queue,
    MRMediaRemoteGetNowPlayingApplicationIsPlayingBlock block);
NSString *MRNowPlayingClientGetBundleIdentifier(id clientObj);
NSString *MRNowPlayingClientGetParentAppBundleIdentifier(id clientObj);

extern NSString *kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification;

extern NSString *kMRMediaRemoteNowPlayingApplicationClientStateDidChange;

extern NSString *kMRNowPlayingPlaybackQueueChangedNotification;
extern NSString *kMRPlaybackQueueContentItemsChangedNotification;
extern NSString *kMRPlaybackQueueContentItemArtworkChangedNotification;
extern NSString *kMRMediaRemoteNowPlayingApplicationDidChangeNotification;


extern NSString *kMRMediaRemoteNowPlayingInfoAlbum;
extern NSString *kMRMediaRemoteNowPlayingInfoArtist;
extern NSString *kMRMediaRemoteNowPlayingInfoTitle;

extern NSString *kMRMediaRemoteNowPlayingInfoArtworkData;

extern NSString *kMRMediaRemoteNowPlayingInfoDuration;
extern NSString *kMRMediaRemoteNowPlayingInfoElapsedTime;
extern NSString *kMRMediaRemoteNowPlayingInfoPlaybackRate;

extern NSString *kMRMediaRemoteNowPlayingInfoTimestamp;

@implementation NowPlaying
+ (void)load
{
    MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_get_main_queue());
    
}

+ (NowPlaying *)sharedInstance
{
    static NowPlaying *instance = 0;
    if (0 == instance)
        instance = [[NowPlaying alloc] init];
    return instance;
}

- (id)init
{
    self = [super init];
    if (nil == self)
        return nil;

    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(appDidChange:)
        name:kMRMediaRemoteNowPlayingApplicationDidChangeNotification
        object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(infoDidChange:)
        name:kMRMediaRemoteNowPlayingApplicationClientStateDidChange
        object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(infoDidChange:)
        name:kMRNowPlayingPlaybackQueueChangedNotification
        object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(infoDidChange:)
        name:kMRPlaybackQueueContentItemsChangedNotification
        object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(playingDidChange:)
        name:kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification
        object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(infoDidChange:)
        name:kMRPlaybackQueueContentItemArtworkChangedNotification
        object:nil];

    [self updateApp];
    [self updateInfo];
    [self updateState];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]
        removeObserver:self];

    self.appBundleIdentifier = nil;
    self.appName = nil;
    self.appIcon = nil;
    self.album = nil;
    self.artist = nil;
    self.title = nil;
}

- (void)updateApp
{
    MRMediaRemoteGetNowPlayingClient(dispatch_get_main_queue(),
        ^(id clientObj)
        {
            NSString *appBundleIdentifier = nil;
            NSString *appName = nil;
            NSImage *appIcon = nil;

            if (nil != clientObj)
            {
                appBundleIdentifier = MRNowPlayingClientGetBundleIdentifier(clientObj);
                if (nil == appBundleIdentifier)
                    appBundleIdentifier = MRNowPlayingClientGetParentAppBundleIdentifier(clientObj);

                if (nil != appBundleIdentifier)
                {
                    NSURL *url = [[NSWorkspace sharedWorkspace]
                        URLForApplicationWithBundleIdentifier: appBundleIdentifier];
                    if (nil != url)
                    {
                        appName = [[NSFileManager defaultManager] displayNameAtPath:[url path]];
                        appIcon = [[NSWorkspace sharedWorkspace] iconForFile:[url path]];
                    }
                }
            }

            if (self.appBundleIdentifier != appBundleIdentifier ||
                self.appName != appName ||
                self.appIcon != appIcon)
            {
                self.appBundleIdentifier = appBundleIdentifier;
                self.appName = appName;
                self.appIcon = appIcon;

                [[NSNotificationCenter defaultCenter]
                    postNotificationName:NowPlayingInfoNotification
                    object:self];
            }
        });
}

- (void)updateInfo
{
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(),
        ^(NSDictionary *info)
        {
            NSString *album = [info objectForKey:kMRMediaRemoteNowPlayingInfoAlbum];
            NSString *artist = [info objectForKey:kMRMediaRemoteNowPlayingInfoArtist];
            NSString *title = [info objectForKey:kMRMediaRemoteNowPlayingInfoTitle];
        
            NSNumber *totalDuration = [info objectForKey:kMRMediaRemoteNowPlayingInfoDuration];
            NSNumber *elapsedTime = [info objectForKey:kMRMediaRemoteNowPlayingInfoElapsedTime];
        
            NSNumber *playbackRate = [info objectForKey:kMRMediaRemoteNowPlayingInfoPlaybackRate];
        
            NSData *albumArtData = [info objectForKey:kMRMediaRemoteNowPlayingInfoArtworkData];
        
            NSDate *refreshedAt = [info objectForKey:kMRMediaRemoteNowPlayingInfoTimestamp];
            
            self.album = album;
            self.artist = artist;
            self.title = title;
        
            self.elapsedTime = elapsedTime;
            self.totalDuration = totalDuration;
            self.playbackRate = playbackRate;
        
            self.refreshedAt = refreshedAt;
            
            self.albumArt = [[NSImage alloc] initWithData:albumArtData];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:NowPlayingInfoNotification
             object:self];
            });
}

- (void)updateState
{
    MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(),
        ^(BOOL playing)
        {
            if (self.playing != playing)
            {
                self.playing = playing;

                [[NSNotificationCenter defaultCenter]
                    postNotificationName:NowPlayingStateNotification
                    object:self];
            }
        });
}

- (void)appDidChange:(NSNotification *)notification
{
    [self updateApp];
}

- (void)infoDidChange:(NSNotification *)notification
{
    [self updateInfo];
}

- (void)playingDidChange:(NSNotification *)notification
{
    [self updateState];
}
@end

NSString *NowPlayingInfoNotification = @"NowPlayingInfo";
NSString *NowPlayingStateNotification = @"NowPlayingState";
