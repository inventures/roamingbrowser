//
//  Url.m
//  Roaming Browser
//
//  Created by Marcus Greenwood on 01/03/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import "Url.h"

@implementation Url

@synthesize url;
@synthesize title;

//comparison override
- (NSComparisonResult)compare:(Url *)u
{
	return [url compare:u.url];
}

//equality override
- (BOOL)isEqual:(Url*)other {
    if (other == self)
		return YES;
    if ([self.url isEqualToString:other.url]) 
		return YES;
	
	return NO;
}

//serialize
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:url forKey:@"url"];
    [coder encodeObject:title forKey:@"title"];
}

//de-serialize
- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[Url alloc] init];
    if (self != nil)
    {
        url = [[coder decodeObjectForKey:@"url"] retain];
        title = [[coder decodeObjectForKey:@"title"] retain];
    }   
    return self;
}

@end
