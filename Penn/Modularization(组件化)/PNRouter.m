//
//  PNRouter.m
//  Penn
//
//  Created by pinn on 2018/10/11.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNRouter.h"


static NSString *const PN_ROUTER_WILDCARD_CHARACTER = @"~";
static NSString *specialCharacters = @"/?&.";

NSString *const PNRouterParameterURL = @"PNRouterParameterURL";
NSString *const PNRouterParameterCompletion = @"PNRouterParameterCompletion";
NSString *const PNRouterParameterUserInfo = @"PNRouterParameterUserInfo";

static PNRouter * instance = nil;

@interface PNRouter ()

@property (nonatomic, strong) NSMutableDictionary *routes;

@end

@implementation PNRouter

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(PNRoterHandler)handler{
    [[self shareInstance] addURLPattern:URLPattern andHandler:handler];
}
//string-->block的映射
- (void)addURLPattern:(NSString *)URLPattern andHandler:(PNRoterHandler)handler{
    NSMutableDictionary *subRoutes = [self addURLPattern:URLPattern];
    if (handler && subRoutes) {
        subRoutes[@"_"] = [handler copy];
    }
}

- (NSMutableDictionary *)addURLPattern:(NSString *)URLPattern{
    NSArray *pathComponents = [self pathComponentsFromURL:URLPattern];
    NSMutableDictionary *subRoutes = self.routes;
    for (NSString *pathComponent in pathComponents) {
        if (![subRoutes objectForKey:pathComponents]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc]init];
        }
        subRoutes = subRoutes[pathComponent];
    }
    return subRoutes;
}

- (NSArray *)pathComponentsFromURL:(NSString *)URL{
    
    NSMutableArray *pathComponents = [NSMutableArray array];
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        [pathComponents addObject:pathSegments.firstObject];
        
        URL = pathComponents.lastObject;
        if (!URL.length) {
            [pathComponents addObject:PN_ROUTER_WILDCARD_CHARACTER];
        }
    }
    
    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        
        [pathComponents addObject:pathComponent];
    }
    
    return [pathComponents copy];
}

- (NSMutableDictionary *)routes{
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc]init];
    }
    return _routes;
}


#pragma mark - Open URL

+ (void)openURL:(NSString *)URL{
    [self openURL:URL completion:nil];
}

+ (void)openURL:(NSString *)URL completion:(void (^)(id result))complete{
    [self openURL:URL userInfo:nil completion:complete];
}

+ (void)openURL:(NSString *)URL userInfo:(NSDictionary *)userIfo completion:(void (^)(id result))complete{
    
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:set];
    //URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//编码@"`#%^{}[]|\"<> ",14个字符包含空格
    NSMutableDictionary *parameters = [[self shareInstance] extractParametersFromURL:URL matchExtractly:NO];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSString.class]) {
            parameters[key] = [obj stringByRemovingPercentEncoding];
        }
    }];
    if (parameters) {
        PNRoterHandler handler = parameters[@"block"];
        if (complete) {
            parameters[PNRouterParameterCompletion] = complete;
        }
        if (userIfo) {
            parameters[PNRouterParameterUserInfo] = userIfo;
        }
        if (handler) {
            [parameters removeObjectForKey:@"block"];
            handler(parameters);
        }
    }
    
}
//提取参数
- (NSMutableDictionary *)extractParametersFromURL:(NSString *)URL matchExtractly:(BOOL)exactly{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[PNRouterParameterURL] = URL;
    NSMutableDictionary *subRoutes = self.routes;
    NSArray *pathComponents = [self pathComponentsFromURL:URL];
    
    BOOL found = NO;
    
    for (NSString *pathComponent in pathComponents) {
        // 对 key 进行排序，这样可以把 ~ 放到最后
        NSArray *subRoutesKeys = [subRoutes.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        for (NSString *key in subRoutesKeys) {
            if ([key isEqualToString:pathComponent] || [key isEqualToString:PN_ROUTER_WILDCARD_CHARACTER]) {
                found = YES;
                subRoutes = subRoutes[key];
                break;
            }else if ([key hasPrefix:@":"]){
                found = YES;
                subRoutes = subRoutes[key];
                NSString *newKey = [key substringFromIndex:1];
                NSString *newPathComponent = pathComponent;
                // 再做一下特殊处理，比如 :id.html -> :id
                if ([self.class checkIfContainsSpecialCharacter:key]) {
                    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
                    NSRange range = [key rangeOfCharacterFromSet:set];
                    if (range.location != NSNotFound) {
                        newKey = [newKey substringToIndex:range.location - 1];
                        NSString *suffixToStrip = [key substringFromIndex:range.location];
                        newPathComponent = [newPathComponent stringByReplacingOccurrencesOfString:suffixToStrip withString:@""];
                    }
                }
                parameters[newKey] = newPathComponent;
                break;
            }else if(exactly){
                found = NO;
            }
        }
        // 如果没有找到该 pathComponent 对应的 handler，则以上一层的 handler 作为 fallback
        if (!found && !subRoutes[@"_"]) {
            return nil;
        }
    }
    
    // Extract Params From Query.
    NSArray<NSURLQueryItem *> *queryItems = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:URL] resolvingAgainstBaseURL:NO].queryItems;
    for (NSURLQueryItem *item in queryItems) {
        parameters[item.name] = item.value;
    }
    if (subRoutes[@"_"]) {
        parameters[@"block"] = [subRoutes[@"_"] copy];
    }
    return parameters;
}

+ (BOOL)checkIfContainsSpecialCharacter:(NSString *)checkedString{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
    return [checkedString rangeOfCharacterFromSet:set].location != NSNotFound;
}
@end
