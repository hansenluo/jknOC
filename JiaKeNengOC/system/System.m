//
//  System.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/15.
//

#import "System.h"

@implementation System

static System * instance = nil;
+(System *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
        }
    }
    return instance;
}

+ (BOOL)isiPhoneX {
    if (@available(iOS 11.0, *)) {
        if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0) {//iphoneX横屏
             return  YES;
        } else {
            return  NO;
        }
    } else {
        return NO;
    }
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
