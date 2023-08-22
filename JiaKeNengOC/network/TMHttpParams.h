//
//  TMHttpParams.h
//  JiaKeNengOC
//
//  Created by jkn-mac on 2023/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RequestType)
{
    POST,
    GET,
    PATCH
};

typedef NS_ENUM(NSInteger, RequestParamsType)
{
    TypeDict,
    TypeJson,
    TypeBody,
    TypeJsonArr,
};

@interface TMHttpParams : NSObject

@property(nonatomic, strong) NSMutableDictionary * params;
@property(nonatomic, strong) NSMutableArray * paramArr;
@property(nonatomic, strong) NSMutableDictionary * headers;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, assign) RequestType requestType;
@property(nonatomic, strong) NSString *headToken;
@property(nonatomic, strong) UIView *showView;
@property(assign) CGRect loginFrame;
@property(assign) BOOL showIndicatorView;
@property(nonatomic, assign) RequestParamsType dataType;
@property(assign) BOOL needEdition;//是否需要上传
@property(assign) BOOL unwantedToken;//不需要放token 默认no 需要


-(id)init;

-(void)addParams:(id)param forKey:(NSString*)key;

-(void)addHeaders:(id)header forKey:(NSString *)key;

-(void)setUrl:(NSString *)url;

-(NSString*)toString;

@end

NS_ASSUME_NONNULL_END
