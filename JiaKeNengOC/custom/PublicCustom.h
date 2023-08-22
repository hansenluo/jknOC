//
//  PublicCustom.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublicCustom : NSObject

+ (PublicCustom *)Instance;

//字典转字符串
+ (NSString *)dictionaryToJsonString:(NSMutableDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
