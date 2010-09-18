//
//  TATableViewController.h
//  TAToolkit
//
//  Created by Tom Krush on 9/18/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TARefreshTableHeaderView;

@interface TATableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
	TARefreshTableHeaderView *refreshHeaderView;
	
	//  Reloading should really be your tableviews model class
	//  Putting it here for demo purposes 
	BOOL _reloading;
}

@property(assign,getter=isReloading) BOOL reloading;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end