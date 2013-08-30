//
//  Roaming_BrowserViewController.h
//  Roaming Browser
//
//  Created by Marcus Greenwood on 12/02/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface BrowserViewController : UIViewController
<UIWebViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, 
UITableViewDelegate, UITableViewDataSource> {
	UIWebView* browser;
	UIScrollView* browserScrollView;
	UILabel* titleLabel;
	UITextField* urlField;
	UITextField* searchField;
	UIView* overlayFrame;
	UITableView* autocompleteTable;
	UIProgressView* progressBar;
	UIBarButtonItem* searchFieldButton;
	UIBarButtonItem* urlFieldButton;
	UIBarButtonItem* cancelButton;
	UIToolbar* toolbar;
	UIView* toolbarFrame;
	UIView* browserFrame;
	UIView* refreshFrame;
	UIView* progressBarFrame;
	UIButton* refreshButton;
	UIButton* stopButton;
	UIButton* stopDummyButton;
	UIBarButtonItem* forwardButton;
	UIBarButtonItem* backButton;
	UILabel* totalBytesLabel;
	UILabel* totalCostLabel;
	
	NSMutableData* data;
	NSInteger byteCounter;
	NSInteger totalByteCounter;
	float totalCostCounter;
	float totalSavingsCounter;
	
	NSString* editingText;
	
	NSMutableArray* urlHistory;
	NSMutableArray* searchHistory;
	NSMutableArray* history;
}

@property (nonatomic, retain) IBOutlet UIWebView *browser;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIView *browserFrame;
@property (nonatomic, retain) IBOutlet UIView *toolbarFrame;
@property (nonatomic, retain) IBOutlet UIView *refreshFrame;
@property (nonatomic, retain) IBOutlet UIView *progressBarFrame;
@property (nonatomic, retain) IBOutlet UIButton *refreshButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UIButton *stopDummyButton;
@property (nonatomic, retain) IBOutlet UITextField *urlField;
@property (nonatomic, retain) IBOutlet UITextField *searchField;
@property (nonatomic, retain) IBOutlet UIView *overlayFrame;
@property (nonatomic, retain) IBOutlet UITableView *autocompleteTable;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *searchFieldButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *urlFieldButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UILabel *totalBytesLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalCostLabel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;

@property (assign) float totalCostCounter;
@property (assign) NSInteger totalByteCounter;
@property (assign) float totalSavingsCounter;

-(IBAction)loadUrl;
-(IBAction)search;
-(IBAction)urlFieldChanged;
-(IBAction)searchFieldChanged;
-(IBAction)goBack;
-(IBAction)goForward;
-(IBAction)stopLoading;
-(IBAction)reload;
-(IBAction)showUrlField;
-(IBAction)showSearchField;
-(IBAction)cancel;
-(IBAction)showSettings;
-(IBAction)showStats;
-(IBAction)showPageActions;
-(IBAction)resetDataCounters;
-(IBAction)scrollsToTop;

-(void)updateCounters;
-(void)updateToolbarPosition;
-(void)restoreFields;
-(void)showUrlFieldButton;

@end

