//
//  MewNotch-Bridging-Header.h
//  MewNotch
//
//  Created by Monu Kumar on 07/03/2025.
//

#pragma once

#import <Foundation/Foundation.h>

#import "Brightness/Brightness.h"
#import "AudioControl/AudioInput.h"
#import "AudioControl/AudioOutput.h"
#import "Power/PowerStatus.h"


extern CFTypeRef IOPSCopyPowerSourcesInfo(void);
