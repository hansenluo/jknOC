//
//  UserInfo.h
//  CallJiu8
//
//  Created by lele on 2018/4/9.
//  Copyright © 2018年 lele. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

+(UserInfo *) Instance;
+(id)allocWithZone:(NSZone *)zone;

+(BOOL)getLogin;

-(void)setAccess_token:(NSString *)access_token;
-(NSString *)getAccess_token;

-(void)setUserName:(NSString *)userName;
-(NSString *)getUserName;

-(void)setPassword:(NSString *)password;
-(NSString *)getPassword;

@end
