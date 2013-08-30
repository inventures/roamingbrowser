//
//  SettingsController.h
//  Roaming Browser
//
//  Created by Marcus Greenwood on 17/02/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsController : UIViewController<UITableViewDataSource> {
	UINavigationBar* navBar;
	UITableView* table;
	UITableViewCell* mobilizerCell;
	UITableViewCell* imagesCell;
	UITableViewCell* cssCell;
	UITableViewCell* jsCell;
	UITableViewCell* currencySymbolCell;
	UITableViewCell* costPerMegCell;
	UISwitch* mobilizerSwitch;
	UISwitch* imagesSwitch;
	UISwitch* cssSwitch;
	UISwitch* jsSwitch;
	UITextField* currencySymbolField;
	UITextField* costPerMegField;
}

@property (nonatomic, retain) IBOutlet UINavigationBar* navBar;
@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet UITableViewCell* mobilizerCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* imagesCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* cssCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* jsCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* currencySymbolCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* costPerMegCell;
@property (nonatomic, retain) IBOutlet UISwitch* mobilizerSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* imagesSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* cssSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* jsSwitch;
@property (nonatomic, retain) IBOutlet UITextField* currencySymbolField;
@property (nonatomic, retain) IBOutlet UITextField* costPerMegField;

-(IBAction)saveSettings;

@end
