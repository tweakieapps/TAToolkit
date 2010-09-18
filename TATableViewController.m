//
//  TATableViewController.m
//  TAToolkit
//
//  Created by Tom Krush on 9/18/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "TATableViewController.h"
#import "TARefreshTableHeaderView.h"
#import "UIView+TAToolkitAdditions.h"

@interface TATableViewController ()

- (void)dataSourceDidFinishLoadingNewData;

@end

@implementation TATableViewController

@synthesize reloading=_reloading;


- (void)viewDidLoad 
{
    [super viewDidLoad];

	if (refreshHeaderView == nil) 
	{
		refreshHeaderView = [[TARefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height)];
		refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		[self.tableView addSubview:refreshHeaderView];
		self.tableView.showsVerticalScrollIndicator = YES;
		[refreshHeaderView release];
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	// Return YES for supported orientations.
	return YES;
}

- (void)viewDidUnload 
{
	refreshHeaderView=nil;
}

- (void)reloadTableViewDataSource
{

}


- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	[self dataSourceDidFinishLoadingNewData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	if (scrollView.isDragging) 
	{
		if (refreshHeaderView.state == TAPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_reloading) 
		{
			[refreshHeaderView setState:TAPullRefreshNormal];
		} 
		else if (refreshHeaderView.state == TAPullRefreshNormal && scrollView.contentOffset.y < -65.0f && ! _reloading) 
		{
			[refreshHeaderView setState:TAPullRefreshPulling];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) 
	{
			_reloading = YES;
			[self reloadTableViewDataSource];
			[refreshHeaderView setState:TAPullRefreshLoading];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.2];
			self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
			[UIView commitAnimations];
	}
}

- (void)dataSourceDidFinishLoadingNewData
{	
	_reloading = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView setState:TAPullRefreshNormal];
	[refreshHeaderView setCurrentDate];  //  should check if data reload was successful 
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	[self configureCell:cell atIndexPath:indexPath];

    return cell;
}

// Subclass method for customization
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc 
{
	refreshHeaderView = nil;
    [super dealloc];
}


@end
