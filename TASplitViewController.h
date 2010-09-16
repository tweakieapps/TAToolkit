//
//  TASplitViewController.h
//  TAToolkit
//
//  Created by Tom Krush on 9/11/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAViewController.h"

@protocol TASplitViewControllerDelegate;

#define TASPLITVIEW_FLEXIBLE_VIEW -1

@interface TASplitViewController : TAViewController 
{
	NSArray					*_viewControllers;
    UIPopoverController     *_hiddenPopoverController;
	UIImageView				*_separator;
	CGFloat					_gutterWidth;
	
	NSMutableArray			*_barButtonItems;
	NSMutableArray			*_hiddenControllers;
					
	id <TASplitViewControllerDelegate> _delegate;
	
	BOOL _enablePopovers;
	
	NSMutableArray *_willHide;
	
}

@property(nonatomic) BOOL enablePopovers;
@property(nonatomic, readonly)	UIImageView *separator;
@property(nonatomic,retain)		NSArray		*viewControllers; 
@property(nonatomic, assign)    id <TASplitViewControllerDelegate> delegate;

- (NSArray *)visibleControllers;
- (void)adjustControllers:(BOOL)animate;
- (BOOL)isControllerCollapsed:(UIViewController *)viewController;
- (void)hideController:(UIViewController *)viewController animate:(BOOL)animate;
- (void)showController:(UIViewController *)viewController animate:(BOOL)animate;

@end

@protocol TASplitViewControllerDelegate <NSObject>

@optional

// Called when a button should be added to a toolbar for a hidden view controller
- (void)splitViewController: (TASplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc;

- (void)splitViewController: (TASplitViewController *)svc willHideViewController:(UIViewController *)aViewController;
- (void)splitViewController: (TASplitViewController *)svc willShowViewController:(UIViewController *)aViewController;


// Called when the view is shown again in the split view, invalidating the button and popover controller
- (void)splitViewController: (TASplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem;

// Called when the view controller is shown in a popover so the delegate can take action like hiding other popovers.
- (void)splitViewController: (TASplitViewController *)svc popoverController: (UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController;

// Called when the split view controller needs either a height or width for controller.
- (CGFloat)splitViewController: (TASplitViewController *)svc dimensionForController:(UIViewController *)viewController;

// Called when the split view controller needs to no its orientation.
- (BOOL)splitViewControllerIsVertical:(TASplitViewController *)svc;

// Called when the split view controller needs to either hide or show controllers.
- (BOOL)splitViewController:(TASplitViewController *)svc hideController:(UIViewController *)viewController forOrientation:(UIInterfaceOrientation)orientation;

@end