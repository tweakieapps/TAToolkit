//
//  TAViewController.m
//  TAToolkit
//
//  Created by Tom Krush on 8/28/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "TAViewController.h"

@implementation TAViewController

#pragma mark -
#pragma mark View Management

- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
	[self layoutViewsWithOrientation:self.interfaceOrientation];
}

- (void)layoutViewsWithOrientation:(UIInterfaceOrientation)orientation 
{

}

#pragma mark -
#pragma mark Rotation Management

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
	[UIView beginAnimations:@"rotate" context:self];
	[UIView setAnimationDuration:duration];
	[self layoutViewsWithOrientation:toInterfaceOrientation];
	[UIView commitAnimations];
}

@end
