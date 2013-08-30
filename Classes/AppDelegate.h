//
//  Roaming_BrowserAppDelegate.h
//  Roaming Browser
//
//  Created by Marcus Greenwood on 12/02/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowserViewController.h"
#import "LocalSubstitutionCache.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BrowserViewController *viewController;
	LocalSubstitutionCache* cache;
	
	BOOL mobilizerOn;
	BOOL imagesOn;
	BOOL cssOn;
	BOOL jsOn;
	NSString* currencySymbol;
	float costPerMeg;
	
	NSMutableArray* urlHistory;
	NSMutableArray* searchHistory;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BrowserViewController *viewController;
@property (assign) BOOL mobilizerOn;
@property (assign) BOOL imagesOn;
@property (assign) BOOL cssOn;
@property (assign) BOOL jsOn;
@property (copy) NSString* currencySymbol;
@property (assign) float costPerMeg;
@property (nonatomic, retain) NSMutableArray* urlHistory;
@property (nonatomic, retain) NSMutableArray* searchHistory;

-(void)loadSettings;
-(void)saveSettings;
-(void)saveHistory;

@end

