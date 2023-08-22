//
//  UIColor+Extension.h
//  HelperFramework
//
//  Created by appleUser on 14-12-3.
//  Copyright (c) 2014年 com.canww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

-(UIImage *)makeImage:(CGSize)size;
+ (UIColor *)colorWithHexString: (NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(float)alpha;
@end
