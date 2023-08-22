//
//  DataRequest.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/29.
//

#import "DataRequest.h"
#import "zlib.h"
#import "GZIP.h"

#define TIMEOUT 30
#define ERRORMSG @"数据获取失败"

static AFHTTPSessionManager *manager;

@implementation DataRequest

+(void)requestWithParam:(TMHttpParams *)param successed:(void (^)(NSDictionary *dict, NSError *error, int result, NSString *msg))block {
    NSString * url = param.url;
    
    [DataRequest request:url withParam:param withFile:nil withOption:nil withTimeout:TIMEOUT successed:block];
}

+(void)request:(NSString *)url withParam:(TMHttpParams *)param withFile:(NSDictionary*)files withOption:(NSDictionary*)option withTimeout:(NSInteger)timeout successed:(void (^)(NSDictionary *dict, NSError *error, int result, NSString *msg))block{
    
    NSString *requestType = @"POST";
    switch (param.requestType) {
        case POST:
            requestType = @"POST";
            break;
        case GET:
            requestType = @"GET";
            break;
        case PATCH:
            requestType = @"PATCH";
            break;
        default:
            break;
    }
    
    RequestType httptype = param.requestType;
    RequestParamsType type = param.dataType;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = timeout;
        manager.operationQueue.maxConcurrentOperationCount = 1;
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
    });
    
    for(NSString *key in param.headers.allKeys){
        [manager.requestSerializer setValue:param.headers[key] forHTTPHeaderField:key];
    }
    
    if (!isNilString([[UserInfo Instance] getAccess_token])) {
        [manager.requestSerializer setValue:[[UserInfo Instance] getAccess_token] forHTTPHeaderField:@"Cookie"];
    }else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Cookie"];
    }
    
    NSLog(@"----Cookie----%@\n  ----请求接口----%@",[[UserInfo Instance] getAccess_token],url);
    manager.requestSerializer.timeoutInterval = timeout;
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:param.params];
    NSDictionary *params = dataDic;
    
    if (httptype == POST) {
        [manager POST:[NSString stringWithFormat:@"%@",url] parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (NSString *key in files) {
                NSData *data = files[key];
                [formData appendPartWithFileData:data name:key fileName:option[[NSString stringWithFormat:@"%@", key]] mimeType:option[[NSString stringWithFormat:@"%@", key]]];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dictResult = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if (IsNull(dictResult)) {
                block(dictResult, nil, 999, ERRORMSG);
                return;
            }
            
            if ([params[@"customKey"] isEqualToString:@"GZIP"]) {
                
                NSData *data = [[NSData alloc] initWithBase64EncodedString:dictResult[@"data"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                NSDictionary *dict = [DataRequest dictionaryForJsonData:[data gunzippedData]];
                
                int result = -1;
                if ([dictResult objectForKey:@"status"]) {
                    result = [[dictResult objectForKey:@"status"] intValue];
                }

                block(dict, nil, result, isNilString([dict objectForKey:@"msg"])?ERRORMSG:[dict objectForKey:@"msg"]);
            }else {
                int result = -1;
                if ([dictResult objectForKey:@"status"]) {
                    result = [[dictResult objectForKey:@"status"] intValue];
                }
                
                if ([params[@"customKey"] isEqualToString:@"login"]) {
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                    NSString *tokenStr = [response allHeaderFields][@"Set-Cookie"];
                    NSLog(@"当前登录token = %@",tokenStr);
                    if (!isNilString(tokenStr)) {
                        [[UserInfo Instance] setAccess_token:tokenStr];
                    }
                }
                    
                block(dictResult, nil, result, isNilString([dictResult objectForKey:@"msg"])?ERRORMSG:[dictResult objectForKey:@"msg"]);
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            block(nil, error, -999, ERRORMSG);
        }];
      
    }else if (httptype == GET) {
        [manager GET:[NSString stringWithFormat:@"%@",url] parameters:params.count == 0?nil:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dictResult = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if (IsNull(dictResult)) {
                block(dictResult, nil, 999, ERRORMSG);
                return;
            }
            
            if ([params[@"customKey"] isEqualToString:@"GZIP"]) {
                
                NSData *data = [[NSData alloc] initWithBase64EncodedString:dictResult[@"data"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                NSDictionary *dict = [DataRequest dictionaryForJsonData:[data gunzippedData]];
                
                int result = -1;
                if ([dictResult objectForKey:@"status"]) {
                    result = [[dictResult objectForKey:@"status"] intValue];
                }

                block(dict, nil, result, isNilString([dict objectForKey:@"msg"])?ERRORMSG:[dict objectForKey:@"msg"]);
            }else {
                int result = -1;
                if ([dictResult objectForKey:@"status"]) {
                    result = [[dictResult objectForKey:@"status"] intValue];
                }
                
                if ([params[@"customKey"] isEqualToString:@"login"]) {
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                    NSString *tokenStr = [response allHeaderFields][@"Set-Cookie"];
                    NSLog(@"当前登录token = %@",tokenStr);
                    if (!isNilString(tokenStr)) {
                        [[UserInfo Instance] setAccess_token:tokenStr];
                    }
                }
                
                block(dictResult, nil, result, isNilString([dictResult objectForKey:@"msg"])?ERRORMSG:[dictResult objectForKey:@"msg"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            block(nil, error, -999, ERRORMSG);
        }];
    }
}

+ (void)cancelRequest {
    if ([manager.tasks count] > 0) {
        //NSLog(@"manager.tasks = %@",manager.tasks);
        [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
        //NSLog(@"tasks = %@",manager.tasks);
    }
}

+ (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData {
    if (![jsonData isKindOfClass:[NSData class]] || jsonData.length < 1) {
        return nil;
    }

    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];

    if (![jsonObj isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [NSDictionary dictionaryWithDictionary:(NSDictionary *)jsonObj];
}
@end
