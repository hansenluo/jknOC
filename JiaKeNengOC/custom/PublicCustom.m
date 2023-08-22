//
//  PublicCustom.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/29.
//

#import "PublicCustom.h"

@implementation PublicCustom

+ (PublicCustom *)Instance {
    static dispatch_once_t onceToken;
    static PublicCustom *instance;
    dispatch_once(&onceToken, ^{
        instance = [[PublicCustom alloc] init];
    });
    return instance;
}

+ (NSString *)dictionaryToJsonString:(NSMutableDictionary *)dic {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableString *responseString = [NSMutableString stringWithString:jsonString];
    
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"]) {
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    }
        return responseString;
}

@end
