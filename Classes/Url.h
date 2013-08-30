//
//  Url.h
//  Roaming Browser
//
//  Created by Marcus Greenwood on 01/03/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Url : NSObject<NSCoding> {
	NSString* url;
	NSString* title;
}

@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* title;

@end
