#import "CustomPopover.h"

@implementation CustomPopover {
    
}

- (id)init {
    if ((self = [super init])) {
        
        WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] init];
        
        props.arrowMargin = 10.0;
        
        props.leftBgCapSize = 20;
        props.topBgCapSize = 20;
        
        self.popoverLayoutMargins = UIEdgeInsetsMake(20, 20, 20, 20);
        props.maskCornerRadius = 4.0;
        
        props.bgImage = [UIImage imageNamed:@"ordertypebg"];
        
        self.primaryAnimationDuration = 0.3;
        self.secundaryAnimationDuration = 0.2;
        
//        self.backgroundColor = [UIColor clearColor];
//        props.backgroundColor = [UIColor clearColor];
        
//        props.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        
        //@(AHColorTypeVanille)   :@[C(0x63512c), C(0x947842), C(0xc5a059), C(0xfac75a), C(0xc6b6a1), C(0xfcdd9c), C(0xfde9bd), C(0xfef7e6)],
        
        props.shadowColor = [UIColor blackColor];
        props.shadowOpacity = 0.8;
        props.shadowRadius = 4.0;
        props.backgroundMargins = UIEdgeInsetsMake(0, 5, 0, 5);
        //props.upArrowImage = [UIImage imageNamed:@"exit"];
        props.contentMargins = UIEdgeInsetsMake(1, 1, 1, 1);
        
        self.containerViewProperties = props;
    }
    return self;
}

UIColor *UIColorMakeRGB8(CGFloat red, CGFloat green, CGFloat blue)
{
    return UIColorMakeRGB8Alpha(red, green, blue, 1.0);
}

UIColor *UIColorMakeRGB8Alpha(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return [UIColor colorWithRed:red / 255. green:green / 255. blue:blue / 255. alpha:alpha];
}

UIColor *UIColorMakeHex(NSInteger hex)
{
    return UIColorMakeHexAlpha(hex, 1.0);
}

UIColor *UIColorMakeHex32(NSInteger hex)
{
    CGFloat red = (CGFloat)((hex & 0xFF000000) >> 24);
    CGFloat green = (CGFloat)((hex & 0xFF0000) >> 16);
    CGFloat blue = (CGFloat)((hex & 0xFF00) >> 8);
    CGFloat alpha = (CGFloat)(hex & 0xFF);
    
    return UIColorMakeRGB8Alpha(red, green, blue, alpha);
}

UIColor *UIColorMakeHexAlpha(NSInteger hex, CGFloat alpha)
{
    CGFloat red = (CGFloat)((hex & 0xFF0000) >> 16);
    CGFloat green = (CGFloat)((hex & 0xFF00) >> 8);
    CGFloat blue = (CGFloat)(hex & 0xFF);
    
    return UIColorMakeRGB8Alpha(red, green, blue, alpha);
}



@end
