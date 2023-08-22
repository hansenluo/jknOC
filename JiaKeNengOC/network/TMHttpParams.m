//
//  TMHttpParams.m
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/29.
//

#import "TMHttpParams.h"

@implementation TMHttpParams

-(id)init
{
    self = [super init];
    self.params = [[NSMutableDictionary alloc] init];
    self.headers = [[NSMutableDictionary alloc] init];
    self.paramArr = [NSMutableArray array];
    return self;
}

-(void)addParams:(id)param forKey:(NSString *)key {
    if (param != nil) {
        [self.params setObject:param forKey:key];
    }
}

-(void)addHeaders:(id)header forKey:(NSString *)key {
    if (header != nil) {
        [self.headers setObject:header forKey:key];
    }
}

-(void)setUrl:(NSString *)url
{
    _url = url;
}

-(NSString*)toString
{
    return [PublicCustom dictionaryToJsonString:self.params];
}

@end
