//
//  WireguardApp-Bridging-Header.h
//  WireguardApp
//
//  Created by iOS TL on 12/05/23.
//

#include "LibraryClasses/Wireguard/WireGuardKitC/WireGuardKitC.h"
#include "LibraryClasses/Wireguard/WireGuardKitGo/wireguard.h"
//#include "WireguardKit/WireGuardKitC/WireGuardKitC.h"
//#include "wireguard-go-version.h"

#include "unzip.h"
#include "zip.h"
#include "ringlogger.h"
//#include "highlighter.h"

#import "TargetConditionals.h"
#if TARGET_OS_OSX
#include <libproc.h>
#endif
