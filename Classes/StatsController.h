//
//  StatsController.h
//  Roaming Browser
//
//  Created by Marcus Greenwood on 27/04/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowserViewController.h"

@interface StatsController : UIViewController<UITableViewDataSource> {
	UILabel* dataLabel;
	UILabel* costLabel;
	UILabel* savingsLabel;
	
	UITableView* table;
	UITableViewCell* dataCell;
	UITableViewCell* costCell;
	UITableViewCell* savingsCell;	
	
	BrowserViewController* browser;
}

@property (nonatomic, retain) IBOutlet UILabel* dataLabel;
@property (nonatomic, retain) IBOutlet UILabel* costLabel;
@property (nonatomic, retain) IBOutlet UILabel* savingsLabel;

@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet UITableViewCell* dataCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* costCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* savingsCell;

@property (nonatomic, retain) BrowserViewController* browser;


-(IBAction)close;
-(IBAction)resetCounters;

@end
