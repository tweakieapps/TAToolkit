//
//  Common.m
//  TAToolkit
//
//  Created by Tom Krush on 8/28/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "Common.h"
#import "TASwizzle.h"

void TAToolkitSetup()
{
	[TASwizzle swizzleSelector:@selector(drawRect:)
                          ofClass:[UINavigationBar class]
                     withSelector:@selector(scDrawRect:)];

	[TASwizzle swizzleSelector:@selector(drawRect:)
                          ofClass:[UIToolbar class]
                     withSelector:@selector(scDrawRect:)]; 
}

CGFloat floatBetween(CGFloat smallNumber, CGFloat bigNumber)
{
    CGFloat diff = bigNumber - smallNumber;
    return (((CGFloat) arc4random() / RAND_MAX) * diff) + smallNumber;
}

void CGRectLog(CGRect rect) {
	NSLog(@"x=%f, y=%f, w=%f, h=%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

void CGSizeLog(CGSize size) {
	NSLog(@"w=%f, h=%f", size.width, size.height);
}


void CGPointLog(CGPoint point) {
	NSLog(@"x=%f, y=%f", point.x, point.y);
}

void UIInterfaceOrientationLog(UIInterfaceOrientation orientation) {
	if (UIInterfaceOrientationPortrait == orientation) {
		NSLog(@"Interface Orientation: Portrait");
	}
	else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
		NSLog(@"Interface Orientation: Portrait Upside Down");
	}
	else if (UIInterfaceOrientationLandscapeLeft == orientation) {
		NSLog(@"Interface Orientation: Landscape Left");
	}
	else if (UIInterfaceOrientationLandscapeRight == orientation) {
		NSLog(@"Interface Orientation: Landscape Right");
	}
}

void UIEdgeInsetsLog(UIEdgeInsets insets) {
	NSLog(@"top=%f, right=%f, bottom=%f, left=%f,", insets.top, insets.right, insets.bottom, insets.left);
}
