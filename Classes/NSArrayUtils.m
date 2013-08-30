//
//  NSArrayUtils.m
//  Roaming Browser
//
//  Created by Marcus Greenwood on 01/03/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import "NSArrayUtils.h"


@implementation NSArray(Utils)

-(BOOL)containsString:(NSString*)string
{
	for(NSString* s in self)
	{
		if([s isEqualToString:string]) return YES;
	}
			
	return NO;
}

@end
