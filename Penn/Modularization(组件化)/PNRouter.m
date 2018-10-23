//
//  PNRouter.m
//  Penn
//
//  Created by pinn on 2018/10/11.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNRouter.h"


static NSString *const PN_ROUTER_WILDCARD_CHARACTER = @"~";


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
@end
