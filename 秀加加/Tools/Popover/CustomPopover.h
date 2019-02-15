#import <Foundation/Foundation.h>
#import "WEPopoverController.h"

@interface CustomPopover : WEPopoverController

UIColor *UIColorMakeRGB8(CGFloat red, CGFloat green, CGFloat blue);
UIColor *UIColorMakeRGB8Alpha(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);
UIColor *UIColorMakeHex(NSInteger hex);
UIColor *UIColorMakeHex32(NSInteger hex);
UIColor *UIColorMakeHexAlpha(NSInteger hex, CGFloat alpha);

@end
