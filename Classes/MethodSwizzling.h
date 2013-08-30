//
//  MethodSwizzling.h
//  Roaming Browser
//
//  Created by Marcus Greenwood on 16/02/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (Swizzle)

+ (BOOL)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector;

@end
