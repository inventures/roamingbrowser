//
//  Roaming_BrowserViewController.m
//  Roaming Browser
//
//  Created by Marcus Greenwood on 12/02/2011.
//  Copyright 2011 Inventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BrowserViewController.h"
#import "NetworkUtils.h"
#import "MyMutableURLRequest.h"
#import "AppDelegate.h"
#import "SettingsController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "Timer.h"
#import "Url.h"
#import "NSArrayUtils.h"
#import "StatsController.h"

@implementation BrowserViewController

@synthesize browser;
@synthesize titleLabel;
@synthesize toolbar;
@synthesize browserFrame;
@synthesize toolbarFrame;
@synthesize urlField;
@synthesize searchField;
@synthesize overlayFrame;
@synthesize autocompleteTable;
@synthesize urlFieldButton;
@synthesize searchFieldButton;
@synthesize cancelButton;
@synthesize forwardButton;
@synthesize backButton;
@synthesize totalBytesLabel;
@synthesize totalCostLabel;
@synthesize refreshFrame;
@synthesize refreshButton;
@synthesize stopButton;
@synthesize stopDummyButton;
@synthesize progressBar;
@synthesize progressBarFrame;
@synthesize totalByteCounter;
@synthesize totalCostCounter;
@synthesize totalSavingsCounter;

extern NSString *WebViewProgressEstimateChangedNotification;
typedef struct CGPoint CGPoint;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self becomeFirstResponder];
	
	//get the scroll view within the browser and remember
	for (UIView* subview in browser.subviews) {
		if ([subview isKindOfClass:[UIScrollView class]]) {
			browserScrollView = (UIScrollView *)subview;
		}
	}
	
	//browserScrollView.delegate = self;
	[browserScrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
	
	//setup the user agent to be a mobile
	[NSMutableURLRequest setupUserAgentOverwrite];
	
	//show the appropriate url field button
	[self showUrlFieldButton];
	
	//disable the forward and back buttons?
	forwardButton.enabled = browser.canGoForward;
	backButton.enabled = browser.canGoBack;
	
	//amend the toolbar to make it look right
	toolbar.bounds = CGRectMake(0, 0, toolbar.bounds.size.width, 75);
	[toolbar setItems:[NSArray arrayWithObjects:urlFieldButton, searchFieldButton, nil] animated:NO];
	
	searchField.layer.cornerRadius = 15;
	searchField.layer.borderWidth = 1;
	searchField.layer.borderColor = [[UIColor colorWithRed:67.0/255 green:89.0/255 blue:120.0/255 alpha:1.0] CGColor];
	searchField.layer.masksToBounds = YES;
	
	//hide the progress bar to begin with
	progressBarFrame.hidden = YES;
	
	CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 4.0f);
	progressBar.transform = transform;
	progressBar.clipsToBounds = YES;
	progressBarFrame.layer.cornerRadius = 7;
	
	[self restoreFields];
	
	//initialise the history variables
	urlHistory = [[NSMutableArray alloc] init];
	searchHistory = [[NSMutableArray alloc] init];
	history = [[NSMutableArray alloc] init];

	//get the app delegate
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

	[urlHistory addObjectsFromArray:appDelegate.urlHistory];
	[searchHistory addObjectsFromArray:appDelegate.searchHistory];
	
	//load the default start page
	NSURL* url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
	NSURLRequest* request = [[[NSURLRequest alloc] initWithURL:url] autorelease];
	[browser loadRequest:request];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if([keyPath isEqualToString:@"contentOffset"])
	{
		[self updateToolbarPosition];
	}
}

-(void)updateToolbarPosition
{
	if(browserScrollView.zooming) return;
	
	float y = browserScrollView.contentOffset.y;
	y = y * 5;
	if(y > 57) y = 57;
	else if(y < 0) y = 0;
	
	//if we're loading, make sure the toolbar is shown
	if(browser.loading) y = 0;
	
	browserFrame.bounds = CGRectMake(0, y, browserFrame.bounds.size.width, browserFrame.bounds.size.height);
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	browser.delegate = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{	
	//add the gzip header
	[(NSMutableURLRequest*)request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"]; 

	//complete the load
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSString* urlString = webView.request.mainDocumentURL.absoluteString;
	
	//get the app delegate
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if([urlString hasPrefix:@"http://www.google.com/gwt/x"])
	{
		urlString = [urlString substringFromIndex:[urlString rangeOfString:@"u="].location + 2];
		if([urlString rangeOfString:@"&"].length > 0) urlString = [urlString substringToIndex:[urlString rangeOfString:@"&"].location];
		
		//de-url encode
		urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		//NSString* mobilizerCssScriptPath = [[NSBundle mainBundle] pathForResource:@"mobilizerCSS" ofType:@"txt"];
		//NSString* mobilizerCssScript = [NSString stringWithUTF8String: [[NSData dataWithContentsOfFile:mobilizerCssScriptPath]	bytes]];
		
		//apply the mobilizer style
		//[webView stringByEvaluatingJavaScriptFromString:mobilizerCssScript];
	}
	
	if(![urlString hasPrefix:@"file:///"]) urlField.text = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	else urlField.text = @"";
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if(![urlString hasPrefix:@"file:///"])
	{
		byteCounter = [NetworkUtils getTotalDataUsageInBytes] - byteCounter;
		
		//responses larger than 5 meg are probably errors
		if(byteCounter < 5000000) 
		{
			totalByteCounter += byteCounter;
			
			//calculate the total savings
			float savings = 0;
			
			if(!appDelegate.imagesOn) savings += 206;
			if(appDelegate.imagesOn && !appDelegate.jsOn) savings += 10;
			else if(!appDelegate.imagesOn && !appDelegate.jsOn) savings += 35;
			if(appDelegate.imagesOn && !appDelegate.cssOn) savings += 5;
			else if(!appDelegate.imagesOn && !appDelegate.cssOn) savings += 20;
			
			totalSavingsCounter += appDelegate.costPerMeg * savings * (float)byteCounter / 100 / 1000 / 1000;
		}
		
		[self updateCounters];
	}
	
	//disable the forward and back buttons?
	forwardButton.enabled = browser.canGoForward;
	backButton.enabled = browser.canGoBack;
	
	//show the appropriate url field button
	[self showUrlFieldButton];
	
	//show the page title
	titleLabel.text = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
	
	//add the page to the url history
	Url* url = [[[Url alloc] init] autorelease];
	url.title = [NSString stringWithString:titleLabel.text];
	url.url = [NSString stringWithString:urlString];
	
	if(![urlHistory containsObject:url] && ![urlString hasPrefix:@"file:///"])
	{
		[urlHistory addObject:url];
	
		//trim to 500
		if([urlHistory count] > 500)
		{
			[urlHistory removeObjectAtIndex:0];
		}
		
		//save history
		appDelegate.urlHistory = [NSMutableArray arrayWithArray:urlHistory];
		appDelegate.searchHistory = [NSMutableArray arrayWithArray:searchHistory];
		[appDelegate saveHistory];
	}

	progressBarFrame.hidden = YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	if([error code] == -999)
	{
		//stop was pushed
	}
	else {
		//show the error
		UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	//show the appropriate url field button
	[self showUrlFieldButton];
	
	progressBarFrame.hidden = YES;
}

//updates the usage counters
-(void)updateCounters
{	
	//get the app delegate
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

	//display megabytes if over 1000000 bytes, otherwise just show kbytes
	if(totalByteCounter > 1000000) totalBytesLabel.text = [NSString stringWithFormat:@"%.1fM", 1.0 * totalByteCounter / 1000000];
	else totalBytesLabel.text = [NSString stringWithFormat:@"%ik", totalByteCounter / 1000];
	
	//show the total cost of the browsing session so far
	self.totalCostCounter = appDelegate.costPerMeg * totalByteCounter / 1000 / 1000;
	totalCostLabel.text = [NSString stringWithFormat:@"%@%.2f", appDelegate.currencySymbol, self.totalCostCounter];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	byteCounter = [NetworkUtils getTotalDataUsageInBytes];
	
	//show the progress bar
	progressBarFrame.hidden = NO;
	[progressBar setProgress:0.1];
	[self updateToolbarPosition];
	
	//animate the progress bar
	Timer* timer = [[Timer new] autorelease];
    timer.interval = 0.7;
    timer.iterations = 70; 
    timer.target = self;
    timer.selector = @selector(updateProgressBar);
    [timer schedule];
	
	//show the appropriate url field button
	[self showUrlFieldButton];
}

-(void)updateProgressBar
{
	if(progressBar.progress < 0.2) progressBar.progress += 0.02;
	else if(progressBar.progress < 0.4) progressBar.progress += 0.04;
	else if(progressBar.progress < 0.5) progressBar.progress += 0.02;
	else if(progressBar.progress < 0.8) progressBar.progress += 0.01;
	else progressBar.progress += 0.003;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
	if(textField == searchField) [self search];
	if(textField == urlField) [self loadUrl];
	
	return YES;
}

//action called when the user enters a url to browse to
-(IBAction)loadUrl
{
	NSString* urlString = urlField.text;
	
	//use google mobilizer?
	//get the app delegate
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

	if(appDelegate.mobilizerOn)
	{
		urlString = [NSString stringWithFormat:@"http://www.google.com/gwt/x?u=%@", [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	
		//add the noimg switch because google mobilizer gets around the usual image blocking code
		if(!appDelegate.imagesOn) urlString = [urlString stringByAppendingString:@"&noimg=1"];
	}
	
	if([urlString length] > 0) // && ![editingText isEqualToString:urlField.text])
	{
		if(![urlString hasPrefix:@"http"])
		{
			urlString = [NSString stringWithFormat:@"http://%@", urlString];
		}
		
		NSURL* url = [[[NSURL alloc] initWithString:urlString] autorelease];
		NSURLRequest* request = [[[NSURLRequest alloc] initWithURL:url] autorelease];
		
		[browser loadRequest:request];
	}
	
	//restore the fields
	[self restoreFields];
}

-(IBAction)goBack
{
	[browser goBack];
}

-(IBAction)goForward
{
	[browser goForward];
}

-(IBAction)reload
{
	[self loadUrl];
}

-(IBAction)stopLoading
{
	[browser stopLoading];
	
	[self showUrlFieldButton];
}

-(IBAction)search
{
	if([searchField.text length] > 0) // && ![editingText isEqualToString:searchField.text])
	{
		urlField.text = [NSString stringWithFormat:@"www.google.com/search?q=%@", [searchField.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		[self loadUrl];
		
		//store the search query in the search history
		if(![searchHistory containsString:searchField.text])
		{
			[searchHistory addObject:[NSString stringWithString:searchField.text]];
			
			//trim to 500
			if([searchHistory count] > 500)
			{
				[searchHistory removeObjectAtIndex:0];
			}
		}
	}
	else
	{
		//restore the fields
		[self restoreFields];
	}
}

-(IBAction)showUrlField
{
	editingText = [[NSString stringWithString: urlField.text] retain];
	refreshFrame.hidden = YES;
	overlayFrame.hidden = NO;
	
	[self urlFieldChanged];
	
	//fade out the search field and slide the cancel button over
	[toolbar setItems:[NSArray arrayWithObjects:urlFieldButton, cancelButton, nil] animated:YES];
	
	[self stopLoading];
	[self showUrlFieldButton];
	
	//animate the urlField expand
	[UIView beginAnimations:@"animation" context:nil];
	urlField.bounds = CGRectMake(0, 0, toolbar.bounds.size.width - 115, urlField.bounds.size.height);
	[UIView commitAnimations]; 
}

-(IBAction)showSearchField
{
	editingText = [[NSString stringWithString:searchField.text] retain];
	refreshFrame.hidden = YES;
	overlayFrame.hidden = NO;
	
	[self searchFieldChanged];
	[autocompleteTable scrollsToTop];
	
	//fade out the url field
	[toolbar setItems:[NSArray arrayWithObjects:searchFieldButton, cancelButton, nil] animated:YES];
	[self stopLoading];
	
	//animate the searchField expand
	[UIView beginAnimations:@"animation" context:nil];
	searchField.bounds = CGRectMake(0, 0, toolbar.bounds.size.width - 115, searchField.bounds.size.height);
	[UIView commitAnimations]; 
}

-(IBAction)cancel
{
	[[urlField undoManager] undo];
	[[searchField undoManager] undo];
	
	[urlField resignFirstResponder];
	[searchField resignFirstResponder];

	[self restoreFields];
}

-(void)restoreFields
{
	//fade in all fields
	refreshFrame.hidden = NO;
	[toolbar setItems:[NSArray arrayWithObjects:urlFieldButton, searchFieldButton, nil] animated:YES];
	
	[UIView beginAnimations:@"animation" context:nil];
	overlayFrame.hidden = YES;
	overlayFrame.alpha = 0.6f;
	urlField.bounds = CGRectMake(0, 0, toolbar.bounds.size.width - 152, urlField.bounds.size.height);
	searchField.bounds = CGRectMake(0, 0, 97, searchField.bounds.size.height);
	[UIView commitAnimations]; 
	
	//show the appropriate url field button
	[self showUrlFieldButton];
}

-(void)showUrlFieldButton
{	
	//don't show a button - let uitextfield handle it
	if(urlField.editing)
	{
		urlField.rightView = nil;
		[autocompleteTable scrollsToTop];
	}
	//show stop button
	else if(browser.loading)
	{
		urlField.rightViewMode = UITextFieldViewModeAlways;
		urlField.rightView = stopDummyButton;
	}
	//show refresh button
	else 
	{
		urlField.rightViewMode = UITextFieldViewModeAlways;
		urlField.rightView = refreshButton;
	}
}

-(IBAction)urlFieldChanged
{
	NSPredicate *filterByUrl = [NSPredicate predicateWithFormat:@"url LIKE[c] %@ AND NOT url == %@", [NSString stringWithFormat:@"*%@*", urlField.text], [NSString stringWithFormat:@"http://%@", urlField.text]];
	[history release];
	history = [[NSMutableArray arrayWithArray:urlHistory] retain];
	
	if([history count] > 0)
	{
		[history filterUsingPredicate:filterByUrl];
		[history sortUsingSelector:@selector(compare:)];
	}
	
	if([history count] == 0 || [urlField.text length] == 0)
	{
		overlayFrame.alpha = 0.6f;
		autocompleteTable.hidden = YES;
	}
	else {
		overlayFrame.alpha = 1;
		autocompleteTable.hidden = NO;
		[autocompleteTable reloadData];	
		[autocompleteTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
}

-(IBAction)searchFieldChanged
{
	NSPredicate *filterByQuery = [NSPredicate predicateWithFormat:@"SELF LIKE[c] %@ AND NOT SELF == %@", [NSString stringWithFormat:@"*%@*", searchField.text], searchField.text];
	[history release];
	history = [[NSMutableArray arrayWithArray:searchHistory] retain];
	
	if([history count] > 0)	
	{
		[history filterUsingPredicate:filterByQuery];
		[history sortUsingSelector:@selector(compare:)];
	}
	
	if([history count] == 0 || [searchField.text length] == 0)
	{
		overlayFrame.alpha = 0.6f;
		autocompleteTable.hidden = YES;
	}
	else {
		overlayFrame.alpha = 1;
		autocompleteTable.hidden = NO;
		[autocompleteTable reloadData];	
		[autocompleteTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
}

-(IBAction)showPageActions
{
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"" 
															 delegate:self 
													cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:nil 
													otherButtonTitles:@"Open in Safari", @"Email a link to this page", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view]; 			
	[actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSURL *url = [NSURL URLWithString:browser.request.mainDocumentURL.absoluteString];
		[[UIApplication sharedApplication] openURL:url];
	} 
	else if (buttonIndex == 1) {
		MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
		controller.mailComposeDelegate = self;
		[controller setSubject:titleLabel.text];
		[controller setMessageBody:[NSString stringWithFormat:@"%@\n\nSent via iPhone Roaming Browser", browser.request.mainDocumentURL.absoluteString] isHTML:NO]; 
		if (controller) [self presentModalViewController:controller animated:YES];
		[controller release];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
	if (result == MFMailComposeResultSent) {
		
	}
	[self dismissModalViewControllerAnimated:YES];
}


-(IBAction)showSettings
{
	SettingsController* settingsController = [[SettingsController alloc] init];
	[self presentModalViewController:settingsController animated:YES];
	
	//recalculate costs
	[self updateCounters];
}

-(IBAction)showStats
{
	StatsController* statsController = [[StatsController alloc] init];
	statsController.browser = self;
	[self presentModalViewController:statsController animated:YES];
	
	//recalculate costs
	[self updateCounters];
}

-(IBAction)resetDataCounters
{
	totalByteCounter = 0;
	self.totalSavingsCounter = 0;
	[self updateCounters];
}

//how many rows should we display in the history table
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [history count];
}

//displays the rows within the table
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Set up the cell...
	id cellValue = [history objectAtIndex:indexPath.row];
	
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%@", [cellValue class]];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		if([cellValue isKindOfClass:[Url class]]) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		else cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	if([cellValue isKindOfClass:[Url class]])
	{
		cell.textLabel.text = [NSString stringWithString:((Url*)cellValue).title];
		cell.detailTextLabel.text = [NSString stringWithString:((Url*)cellValue).url];
	}
	else {
		cell.textLabel.text = cellValue;
	}
	
	cellValue = nil;

	return cell;
}

//handles the user touching the cell in the history table
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id cellValue = [history objectAtIndex:indexPath.row];
	
	if([cellValue isKindOfClass:[Url class]])
	{
		Url* url = (Url*)cellValue;
		urlField.text = url.url;
		[self textFieldShouldReturn:urlField];
	}
	else {
		searchField.text = cellValue;
		[self textFieldShouldReturn:searchField];
	}	
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if(scrollView == autocompleteTable)
	{
		//hide the keyboard
		[urlField resignFirstResponder];
		[searchField resignFirstResponder];
	}
}

//scroll the browser to the top of the page
-(IBAction)scrollsToTop
{
	[browserScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
