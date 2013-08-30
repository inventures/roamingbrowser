//
//  StatsController.m
//  Roaming Browser
//
//  Created by Marcus Greenwood on 27/04/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import "StatsController.h"
#import "AppDelegate.h"

@implementation StatsController

@synthesize costLabel;
@synthesize dataLabel;
@synthesize savingsLabel;
@synthesize table;
@synthesize costCell;
@synthesize dataCell;
@synthesize savingsCell;
@synthesize browser;

-(void)viewDidLoad
{
	//get the app delegate
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	costLabel.text = [NSString stringWithFormat:@"%@%.2f", appDelegate.currencySymbol, browser.totalCostCounter];
	savingsLabel.text = [NSString stringWithFormat:@"%@%.2f", appDelegate.currencySymbol, browser.totalSavingsCounter];
	
	//display megabytes if over 1000000 bytes, otherwise just show kbytes
	if(browser.totalByteCounter > 1000000) dataLabel.text = [NSString stringWithFormat:@"%.1fM", 1.0 * browser.totalByteCounter / 1000000];
	else dataLabel.text = [NSString stringWithFormat:@"%ik", browser.totalByteCounter / 1000];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0) return 3;
	else return 0;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0) return @"Data and cost information";
	else return nil;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 0)
	{
		if(indexPath.row == 0) return dataCell;
		else if(indexPath.row == 1) return costCell;
		else if(indexPath.row == 2) return savingsCell;
	}
	
	return nil;
}


-(IBAction)close
{
	//hide this view
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)resetCounters
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear counters" message:@"are you sure you wish to clear the data counters?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 1)
	{
		[browser resetDataCounters];
		
		//close this dialog
		[self close];
	}
}

@end
