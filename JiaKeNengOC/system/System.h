//
//  System.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface System : NSObject

+ (System *) Instance;
+ (BOOL)isiPhoneX;
+ (UIColor *) colorWithHexString: (NSString *)color;

@end

NS_ASSUME_NONNULL_END
