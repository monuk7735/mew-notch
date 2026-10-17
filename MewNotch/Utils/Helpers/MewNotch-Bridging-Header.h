//
//  MewNotch-Bridging-Header.h
//  MewNotch
//
//  Created by Monu Kumar on 07/03/2025.
//

#ifndef MewNotch_Bridging_Header_h
#define MewNotch_Bridging_Header_h

#import <Foundation/Foundation.h>

#import "Brightness/Brightness.h"
#import "AudioControl/AudioInput.h"
#import "AudioControl/AudioOutput.h"
#import "Power/PowerStatus.h"


extern CFTypeRef IOPSCopyPowerSourcesInfo(void);

#endif /* MewNotch_Bridging_Header_h */
