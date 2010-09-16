//
//  TASplitViewController.m
//  TAToolkit
//
//  Created by Tom Krush on 9/11/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "TASplitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+TAToolkitAdditions.h"

@interface TASplitViewController ()
- (void)togglePopover:(UIBarButtonItem *)button;

- (void)adjustFrameForController:(UIViewController *)viewController dimension:(CGFloat)dimension;

// Delegate Methods
- (void)splitViewController: (TASplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc;
- (void)splitViewController: (TASplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)splitViewController: (TASplitViewController *)svc popoverController: (UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController;
- (CGFloat)splitViewController: (TASplitViewController *)svc dimensionForController:(UIViewController *)viewController;
- (BOOL)splitViewControllerIsVertical:(TASplitViewController *)svc;
- (BOOL)splitViewController:(TASplitViewController *)svc hideController:(UIViewController *)viewController forOrientation:(UIInterfaceOrientation)orientation;
- (void)splitViewController: (TASplitViewController *)svc willHideViewController:(UIViewController *)aViewController;
- (void)splitViewController: (TASplitViewController *)svc willShowViewController:(UIViewController *)aViewController;

@end

@implementation TASplitViewController

@synthesize enablePopovers			= _enablePopovers;
@synthesize viewControllers			= _viewControllers;
@synthesize separator				= _separator;
@synthesize delegate				= _delegate;

- (id)init {
	self = [super init];
	
	if (self) {
		_enablePopovers				= NO;
		_gutterWidth				= 1;
		_hiddenControllers			= [[NSMutableArray alloc] init];
		_willHide					= [[NSMutableArray alloc] init];
		_barButtonItems				= [[NSMutableArray alloc] init];
	}
	
	return self;
}

#pragma mark -
#pragma mark View Management
- (void)viewDidLoad {
	self.view.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {	
	NSArray	*visibleControllers = [self visibleControllers];
	NSInteger total = [visibleControllers count];

	for (int i = 0; i < total; i++) {	
		UIViewController *viewController = [visibleControllers objectAtIndex:i];
		
		[viewController viewWillAppear:animated];
	}
}

- (void)viewDidAppear:(BOOL)animated {	

	[self adjustControllers:NO];

	NSArray	*visibleControllers = [self visibleControllers];
	NSInteger total = [visibleControllers count];
	//UIInterfaceOrientation interfaceOrientation = ASInterfaceOrientation();
	UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
	
	
	for (int i = 0; i < total; i++) {	
		UIViewController *viewController = [visibleControllers objectAtIndex:i];
		
		BOOL hide = [self splitViewController:self hideController:viewController forOrientation:interfaceOrientation];
				
		if (hide) {
			[self hideController:viewController animate:NO];
		}
		
		[viewController viewDidAppear:animated];
	}
}

- (void)viewWillDisappear:(BOOL)animated {	
	NSArray	*visibleControllers = [self visibleControllers];
	NSInteger total = [visibleControllers count];

	for (int i = 0; i < total; i++) {	
		UIViewController *viewController = [visibleControllers objectAtIndex:i];
		
		[viewController viewWillDisappear:animated];
	}
}

- (void)viewDidDisappear:(BOOL)animated {	
	NSArray	*visibleControllers = [self visibleControllers];
	NSInteger total = [visibleControllers count];

	for (int i = 0; i < total; i++) {	
		UIViewController *viewController = [visibleControllers objectAtIndex:i];
		
		[viewController viewDidDisappear:animated];
	}
}

#pragma mark -
#pragma mark Orientation Management
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

	NSArray	*visibleControllers = [self viewControllers];
	NSInteger total = [visibleControllers count];

	for (int i = 0; i < total; i++) {	
		UIViewController *viewController = [visibleControllers objectAtIndex:i];

		BOOL hide = [self splitViewController:self hideController:viewController forOrientation:toInterfaceOrientation];
		
		if (hide) {
			//[_willHide addObject:viewController];
			[self hideController:viewController animate:NO];
		} else {
			[self showController:viewController animate:NO];
			[viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
		}
	}			
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];

	if (_hiddenPopoverController) {
		[_hiddenPopoverController dismissPopoverAnimated:NO];
	}

	NSArray	*visibleControllers = [self viewControllers];
	NSInteger total = [visibleControllers count];

	[self adjustControllers:NO];

	for (int i = 0; i < total; i++) {	
		UIViewController *viewController = [visibleControllers objectAtIndex:i];
		
	//	BOOL hide = [self splitViewController:self hideController:viewController forOrientation:interfaceOrientation];
		
//		if (hide) {
//			//[_willHide addObject:viewController];
//			[self hideController:viewController animate:YES];
//		} else {
//			[self showController:viewController animate:YES];
//			[viewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
//		}
		
		if ( ! [_willHide containsObject:viewController]) {
			[viewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
		}
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
	NSArray	*viewControllers = [self viewControllers];
	NSInteger total = [viewControllers count];

	for (int i = 0; i < total; i++) {	
		UIViewController *viewController = [viewControllers objectAtIndex:i];

		if ( [_willHide containsObject:viewController]) {
			[self hideController:viewController animate:NO];
		} else {
			[viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
		}
	}

	[_willHide removeAllObjects];	
}


#pragma mark -
#pragma mark View Controllers Management

- (void)setViewControllers:(NSArray *)controllers {
	[controllers retain];
	[_viewControllers release];
	
	_viewControllers = controllers;

	for (UIViewController *viewController in _viewControllers) {
		[self.view addSubview:viewController.view];
	}

	[self adjustControllers:NO];	
}

- (NSArray *)visibleControllers {	
	if ([_hiddenControllers count] > 0) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", _hiddenControllers];
		
		return [self.viewControllers filteredArrayUsingPredicate:predicate];
	}
	
	return [self viewControllers];
}

- (void)adjustControllers:(BOOL)animate {
	NSInteger total = [[self visibleControllers] count];
	CGFloat dimension = TASPLITVIEW_FLEXIBLE_VIEW;
	NSMutableArray *dimensions = [[NSMutableArray alloc] init];
	CGFloat sum = 0;
	NSInteger totalFlexibleViews = 0;
	CGFloat flexibleDimension = 0;
	UIViewController *viewController = nil;

	for (int i = 0; i < total; i++) {
		viewController = [[self visibleControllers] objectAtIndex:i];
	
		dimension = [self splitViewController:self dimensionForController:viewController];
		
		if ( dimension != TASPLITVIEW_FLEXIBLE_VIEW) {
			sum += dimension;
		} else {
			totalFlexibleViews++;
		}
		
		[dimensions addObject:[NSNumber numberWithFloat:dimension]];
	}
	
	if ([self splitViewControllerIsVertical:self]) {
		flexibleDimension = (self.view.bounds.size.height - sum) / totalFlexibleViews;
	} else {
		flexibleDimension = (self.view.bounds.size.width - sum) / totalFlexibleViews;
	}
	
	if (animate) {
		[UIView beginAnimations:nil context:NULL];  
		[UIView setAnimationDuration:0.4];  
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}

	for (int i = 0; i < total; i++) {
		dimension = [[dimensions objectAtIndex:i] floatValue];
		
		viewController = [[self visibleControllers] objectAtIndex:i];
		
		if (dimension == TASPLITVIEW_FLEXIBLE_VIEW) {
			[self adjustFrameForController:viewController dimension:flexibleDimension];
		} else {
			[self adjustFrameForController:viewController dimension:dimension];
		}
	}
	
	if (animate) {
		[UIView commitAnimations];  
	}
	
	[dimensions release];
}

- (BOOL)isControllerCollapsed:(UIViewController *)viewController {
	if ([[self visibleControllers] containsObject:viewController]) {		
		return NO;
	}
	
	return YES;
}

- (void)hideController:(UIViewController *)viewController animate:(BOOL)animate {
	if ([self.viewControllers containsObject:viewController]) {				
		if ( ! [_hiddenControllers containsObject:viewController]) {
			BOOL vertical = [self splitViewControllerIsVertical:self];
			NSInteger total = [[self viewControllers] count];
			NSInteger index = [[self viewControllers] indexOfObject:viewController];
			CGRect frame = viewController.view.frame;
		
			[_hiddenControllers addObject:viewController];
			
			if (_enablePopovers) {
				UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Controller" style:UIBarButtonItemStyleBordered target:self action:@selector(togglePopover:)];
				[_barButtonItems addObject:barButtonItem];
				
				if ( ! _hiddenPopoverController) {
					_hiddenPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
				} else {
					_hiddenPopoverController.contentViewController = viewController;
				}
				
				[self splitViewController:self willHideViewController:viewController withBarButtonItem:barButtonItem forPopoverController:_hiddenPopoverController];
			}
			else {
				[self splitViewController:self willHideViewController:viewController];
			}
			
			[viewController viewWillDisappear:animate];
			
			if (animate) {
				[UIView beginAnimations:nil context:NULL];  
				[UIView setAnimationDuration:0.4];  
				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
				[UIView setAnimationDelegate:viewController.view];
				[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
				
				if (vertical) {
					if (index == 0) {
						frame.origin.y -= frame.size.height;
					} else if (index == (total - 1)) {
						frame.origin.y += frame.size.height;
					} else {
						viewController.view.alpha = 0;
					}			
				} else {
					if (index == 0) {
						frame.origin.x -= frame.size.width;					
					} else if (index == (total - 1)) {
						frame.origin.x += frame.size.width;					
					} else {
						viewController.view.alpha = 0;
					}			
				}
				
				viewController.view.frame = frame;
			}
		
			if ( ! animate) {
				[viewController.view removeFromSuperview];
			}
		
			[self adjustControllers:animate];
					
			if (animate) {
				[UIView commitAnimations];  
			}
			[viewController viewDidDisappear:animate];
		}
	}
}

- (void)showController:(UIViewController *)viewController animate:(BOOL)animate {
	if ([self.viewControllers containsObject:viewController]) {						
		if ([_hiddenControllers containsObject:viewController]) {
			BOOL vertical = [self splitViewControllerIsVertical:self];
			NSInteger total = [[self viewControllers] count];
			NSInteger index = [[self viewControllers] indexOfObject:viewController];
			CGRect frame = viewController.view.frame;

			if (_enablePopovers) {
				UIBarButtonItem *barButtonItem = [_barButtonItems objectAtIndex:[_hiddenControllers indexOfObject:viewController]];

				[self splitViewController:self willShowViewController:viewController invalidatingBarButtonItem:barButtonItem];


				[_barButtonItems removeObject:barButtonItem];
			}
			else {
				[self splitViewController:self willShowViewController:viewController];
			}

			[_hiddenControllers removeObject:viewController];
			
			if (animate) {
				if (vertical) {
					if (index == 0) {
						frame.origin.y -= frame.size.height;
					} else if (index == (total - 1)) {
						frame.origin.y += frame.size.height;
					} else {
						viewController.view.alpha = 0;
					}			
				} else {
					if (index == 0) {
						frame.origin.x -= frame.size.width;					
					} else if (index == (total - 1)) {
						frame.origin.x += frame.size.width;					
					} else {
						viewController.view.alpha = 0;
					}			
				}			
		
				[UIView beginAnimations:nil context:NULL];  
				[UIView setAnimationDuration:0.4];  
				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
				
				if (vertical) {
					if (index == 0) {
						frame.origin.y += frame.size.height;
					} else if (index == (total - 1)) {
						frame.origin.y -= frame.size.height;
					} else {
						viewController.view.alpha = 1;
					}			
				} else {
					if (index == 0) {
						frame.origin.x += frame.size.width;					
					} else if (index == (total - 1)) {
						frame.origin.x -= frame.size.width;					
					} else {
						viewController.view.alpha = 1;
					}			
				}
			}
			
			[viewController viewWillAppear:animate];

			if ( ! [viewController.view.superview isEqual:self.view]) {
				if (_separator) {
					[self.view insertSubview:viewController.view belowSubview:self.separator];
				} else {
					[self.view addSubview:viewController.view];
				}
			}					
			
			[self adjustControllers:animate];
					
			if (animate) {
				[UIView commitAnimations];  
			}
			
			[viewController viewDidAppear:animate];	
		}
	}
}

- (void)adjustFrameForController:(UIViewController *)viewController dimension:(CGFloat)dimension {
	if ([[self visibleControllers] containsObject:viewController]) {
		CGSize size;

		if ([self splitViewControllerIsVertical:self]) {
			size.width  = self.view.bounds.size.width;
			size.height = dimension;
		} else {
			size.width  = dimension;
			size.height = self.view.bounds.size.height;	
		}
				
		NSInteger index = [[self visibleControllers] indexOfObject:viewController];
		
		if (index == 0) {
			viewController.view.frame = CGRectMake(self.view.paddingLeft, self.view.paddingTop, size.width, size.height);
			
			if (_separator) {
				self.separator.hidden = YES;
			}
			
		} else {			
			UIViewController *prevController = [[self visibleControllers] objectAtIndex:index-1];
			
			if ([self splitViewControllerIsVertical:self]) {			
				viewController.view.frame = CGRectMake(self.view.paddingLeft, prevController.view.frame.origin.y + prevController.view.frame.size.height, size.width, size.height);
			} else {
				viewController.view.frame = CGRectMake(prevController.view.frame.origin.x + prevController.view.frame.size.width, self.view.paddingTop, size.width, size.height);

				if (_separator) {
					self.separator.hidden = NO;
					self.separator.top = 0;
					self.separator.left = viewController.view.left - 1;
					self.separator.height = 44;
					self.separator.width = 2;
				}
			}
		}
	}
}

#pragma mark -
#pragma mark Split View Delegate
// Called when a button should be added to a toolbar for a hidden view controller
- (void)splitViewController: (TASplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
	if([_delegate respondsToSelector:@selector(splitViewController:willHideViewController:withBarButtonItem:forPopoverController:)]) {
		[_delegate splitViewController:svc willHideViewController:aViewController withBarButtonItem:barButtonItem forPopoverController:pc];
	}
}

// Called when the view is shown again in the split view, invalidating the button and popover controller
- (void)splitViewController: (TASplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	if([_delegate respondsToSelector:@selector(splitViewController:willShowViewController:invalidatingBarButtonItem:)]) {
		return [_delegate splitViewController:svc willShowViewController:aViewController invalidatingBarButtonItem:barButtonItem];
	}	
}

- (void)splitViewController: (TASplitViewController *)svc willHideViewController:(UIViewController *)aViewController {
	if([_delegate respondsToSelector:@selector(splitViewController:willHideViewController:)]) {
		[_delegate splitViewController:svc willHideViewController:aViewController];
	}
}

- (void)splitViewController: (TASplitViewController *)svc willShowViewController:(UIViewController *)aViewController {
	if([_delegate respondsToSelector:@selector(splitViewController:willShowViewController:)]) {
		[_delegate splitViewController:svc willShowViewController:aViewController];
	}
}

// Called when the view controller is shown in a popover so the delegate can take action like hiding other popovers.
- (void)splitViewController: (TASplitViewController *)svc popoverController: (UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController {
	if([_delegate respondsToSelector:@selector(splitViewController:popoverController:willPresentViewController:)]) {
		return [_delegate splitViewController:svc popoverController:pc willPresentViewController:aViewController];
	}
}

- (BOOL)splitViewControllerIsVertical:(TASplitViewController *)svc {
	if([_delegate respondsToSelector:@selector(splitViewControllerIsVertical:)]) {
		return [_delegate splitViewControllerIsVertical:svc];
	}	

	return NO;
}

- (CGFloat)splitViewController: (TASplitViewController *)svc dimensionForController:(UIViewController *)viewController {
	CGFloat dimension = -1;
	
	if([_delegate respondsToSelector:@selector(splitViewController:dimensionForController:)]) {	
		dimension = [_delegate splitViewController:self dimensionForController:viewController];
	}
		
	return dimension;
}

- (BOOL)splitViewController:(TASplitViewController *)svc hideController:(UIViewController *)viewController forOrientation:(UIInterfaceOrientation)orientation {
	if([_delegate respondsToSelector:@selector(splitViewController:hideController:forOrientation:)]) {
		return [_delegate splitViewController:svc hideController:viewController forOrientation:orientation];
	}

	return [self isControllerCollapsed:viewController];
}

#pragma mark -
#pragma mark Master Controller Actions

- (void)togglePopover:(UIBarButtonItem *)button {
	if ([_barButtonItems containsObject:button]) {
		NSInteger index = [_barButtonItems indexOfObject:button];
		UIViewController *viewController = [_hiddenControllers objectAtIndex:index];
		
		// Is View Controller already Visible (Dismiss it)
		if (_hiddenPopoverController.popoverVisible && [_hiddenPopoverController.contentViewController isEqual:viewController]) {
			[viewController viewWillDisappear:YES];
			[_hiddenPopoverController dismissPopoverAnimated:YES];
			[viewController viewDidDisappear:YES];
		} 
		else {
			// If Popover is already visible (dismiss it)
			if (_hiddenPopoverController.popoverVisible) {
				[_hiddenPopoverController.contentViewController viewWillDisappear:YES];
				[_hiddenPopoverController dismissPopoverAnimated:YES];
				[_hiddenPopoverController.contentViewController viewDidDisappear:YES];
			}

			[self splitViewController:self popoverController:_hiddenPopoverController willPresentViewController:viewController];
			
			// Present View Controller
			[_hiddenPopoverController setContentViewController:viewController animated:NO];
			[viewController viewWillAppear:YES];
			[_hiddenPopoverController presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
			[viewController viewDidAppear:YES];
		}
	}
}

#pragma mark -
#pragma mark Separator
- (UIImageView *)separator {
	if ( ! _separator) {
		_separator = [[UIImageView alloc] init];
		_separator.backgroundColor = [UIColor blueColor];
		[self.view addSubview:_separator];
	}
	
	return _separator;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[_barButtonItems release];
	[_willHide release];
	[_hiddenControllers release];
	[_hiddenPopoverController release];
	[_separator release];
	[_viewControllers release];
	
	[super dealloc];
}

@end