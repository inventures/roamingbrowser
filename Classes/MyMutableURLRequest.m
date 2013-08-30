//
//  MyMutableURLRequest.m
//  Roaming Browser
//
//  Created by Marcus Greenwood on 16/02/2011.
//  Copyright 2011 Inventures. All rights reserved.
//
#import "MyMutableURLRequest.h"
#import "MethodSwizzling.h"

@implementation NSMutableURLRequest (MyMutableURLRequest)

- (void)newSetValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
{
    if ([field isEqualToString:@"User-Agent"]) {
        value = @"Mozilla/5.0 (SymbianOS/9.2; U; Series60/3.1 NokiaE71-1/110.07.127; Profile/MIDP-2.0 Configuration/CLDC-1.1 ) AppleWebKit/413 (KHTML, like Gecko) Safari/413";
    }
    [self newSetValue:value forHTTPHeaderField:field];
}

+ (void)setupUserAgentOverwrite
{
    [self swizzleMethod:@selector(setValue:forHTTPHeaderField:)
			 withMethod:@selector(newSetValue:forHTTPHeaderField:)];
}

@end