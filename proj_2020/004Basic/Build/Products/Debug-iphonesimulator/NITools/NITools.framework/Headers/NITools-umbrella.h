#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIView+NIFrame.h"
#import "NIPrivacyView.h"
#import "NIVersionManagerView.h"

FOUNDATION_EXPORT double NIToolsVersionNumber;
FOUNDATION_EXPORT const unsigned char NIToolsVersionString[];
