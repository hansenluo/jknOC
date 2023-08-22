//
//  UserInfo.m
//  CallJiu8
//
//  Created by lele on 2018/4/9.
//  Copyright © 2018年 lele. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

static UserInfo * instance = nil;
+(UserInfo *) Instance
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

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

+(BOOL)getLogin
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if(defaults != nil)
    {
        NSString * userinfo = [defaults objectForKey:@"userInfo"];
        if (userinfo != nil) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

-(void)setAccess_token:(NSString *)access_token {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:access_token forKey:@"access_token"];
    [defaults synchronize];
}

-(NSString*)getAccess_token {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"access_token"];
}

-(void)setUserName:(NSString *)userName {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"userName"];
    [defaults synchronize];
}

-(NSString *)getUserName {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"userName"];
}

-(void)setPassword:(NSString *)password {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:password forKey:@"password"];
    [defaults synchronize];
}

-(NSString *)getPassword {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"password"];
}

@end
