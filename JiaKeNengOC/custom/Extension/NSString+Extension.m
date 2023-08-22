//
//  NSString+Extension.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/7/11.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

// Base64编码方法2
- (NSString *)base64EncodingString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];;
}

// Base64解码方法2
- (NSString *)base64DecodingString {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
