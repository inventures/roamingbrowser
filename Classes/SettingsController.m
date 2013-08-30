//
//  SettingsController.m
//  Roaming Browser
//
//  Created by Marcus Greenwood on 17/02/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import "SettingsController.h"
#import "AppDelegate.h"

@implementation SettingsController

@synthesize navBar;
@synthesize table;
@synthesize mobilizerCell;
@synthesize imagesCell;
@synthesize cssCell;
@synthesize jsCell;
@synthesize currencySymbolCell;
@synthesize costPerMegCell;
@synthesize mobilizerSwitch;
@synthesize imagesSwitch;
@synthesize cssSwitch;
@synthesize jsSwitch;
@synthesize currencySymbolField;
@synthesize costPerMegField;

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	//save settings
	[self saveSettings];
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(void) viewDidLoad
{
	[super viewDidLoad];
	
	//get the app delegate
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//controller title
	self.title = @"Settings";
	
	//set the settings values
	mobilizerSwitch.on = appDelegate.mobilizerOn;
	imagesSwitch.on = appDelegate.imagesOn;
	cssSwitch.on = appDelegate.cssOn;
	jsSwitch.on = appDelegate.jsOn;
	currencySymbolField.text = appDelegate.currencySymbol;
	costPerMegField.text = [NSString stringWithFormat:@"%.2f", appDelegate.costPerMeg];
	
	//initialise the table with the settings and values
	[table setDataSource:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0) return 2;
	else if(section == 1) return 4;
	else return 0;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0) return @"Roaming settings";
	else if(section == 1) return @"Browser settings";
	else return nil;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 0)
	{
		if(indexPath.row == 0) return currencySymbolCell;
		else if(indexPath.row == 1) return costPerMegCell;
	}
	else if(indexPath.section == 1)
	{
		if(indexPath.row == 0) return imagesCell;
		else if(indexPath.row == 1) return cssCell;
		else if(indexPath.row == 2) return jsCell;
		else if(indexPath.row == 3) return mobilizerCell;
	}
	
	return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)saveSettings
{
	//get the app delegate
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//save the settings back to the appDelegate
	appDelegate.mobilizerOn = mobilizerSwitch.on;
	appDelegate.imagesOn = imagesSwitch.on;
	appDelegate.cssOn = cssSwitch.on;
	appDelegate.jsOn = jsSwitch.on;
	appDelegate.currencySymbol = currencySymbolField.text;
	appDelegate.costPerMeg = [costPerMegField.text floatValue];
	
	//save settings for the application
	[appDelegate saveSettings];
	
	//hide this view
	[self dismissModalViewControllerAnimated:YES];
}

@end
