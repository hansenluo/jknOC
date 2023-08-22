//
//  DataRequest.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/29.
//

#import <Foundation/Foundation.h>
#import "TMHttpParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataRequest : NSObject

+(void)requestWithParam:(TMHttpParams *)params successed:(void(^)(NSDictionary *dict, NSError *error, int result, NSString *msg))block;
+(void)cancelRequest;

@end

NS_ASSUME_NONNULL_END
