//
//  Roaming_BrowserAppDelegate.m
//  Roaming Browser
//
//  Created by Marcus Greenwood on 12/02/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import "AppDelegate.h"
#import "BrowserViewController.h"
#import "LocalSubstitutionCache.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController;

@synthesize mobilizerOn;
@synthesize imagesOn;
@synthesize cssOn;
@synthesize jsOn;
@synthesize currencySymbol;
@synthesize costPerMeg;
@synthesize urlHistory;
@synthesize searchHistory;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Set the URL cache and leave it set permanently
	cache = [[[LocalSubstitutionCache alloc] init] retain];
	[NSURLCache setSharedURLCache:cache];
	
	//setup the defaults
	mobilizerOn = NO;
	imagesOn = YES;
	cssOn = YES;
	jsOn = YES;
	currencySymbol = @"£";
	costPerMeg = 3.00;
	
	//get settings from the stored config
	[self loadSettings];
	
	// Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
	
	
	return YES;
}

//loads the application settings
-(void)loadSettings {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
	if([prefs objectForKey:@"hasSettings"] != nil)
	{
		mobilizerOn = [prefs boolForKey:@"mobilizerOn"];
		imagesOn = [prefs boolForKey:@"imagesOn"];
		cssOn = [prefs boolForKey:@"cssOn"];
		jsOn = [prefs boolForKey:@"jsOn"];
		currencySymbol = [prefs objectForKey:@"currencySymbol"];
		costPerMeg = [prefs floatForKey:@"costPerMeg"];
	}
	
	NSArray *oldUrlHistory = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"urlHistory"]];
	if (oldUrlHistory != nil) self.urlHistory = [[[NSMutableArray alloc] initWithArray:oldUrlHistory] retain];
	else self.urlHistory = [[[NSMutableArray alloc] init] retain];
	
	NSArray *oldSearchHistory = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"searchHistory"]];
	if (oldSearchHistory != nil) self.searchHistory = [[[NSMutableArray alloc] initWithArray:oldSearchHistory] retain];
	else self.searchHistory = [[[NSMutableArray alloc] init] retain];	
}

//saves the application settings
-(void)saveSettings {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	[prefs setBool:TRUE forKey:@"hasSettings"];
	
	[prefs setBool:mobilizerOn forKey:@"mobilizerOn"];
	[prefs setBool:imagesOn forKey:@"imagesOn"];
	[prefs setBool:cssOn forKey:@"cssOn"];
	[prefs setBool:jsOn forKey:@"jsOn"];
	[prefs setObject:currencySymbol forKey:@"currencySymbol"];
	[prefs setFloat:costPerMeg forKey:@"costPerMeg"];
	
	[prefs synchronize];
}

//saves url and search history
-(void)saveHistory
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

	[prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:urlHistory] forKey:@"urlHistory"];
	[prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:searchHistory] forKey:@"searchHistory"];
	
	[prefs synchronize];
}

//forces the application to quit properly when the user closes it
-(void) applicationWillTerminate:(UIApplication *)application
{
	exit(0);
}

//unloads the application
- (void)dealloc {
	[currencySymbol release];
	[urlHistory release];
	[searchHistory release];
    [viewController release];
    [window release];
	[cache release];
    [super dealloc];
}


@end
