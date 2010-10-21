//
//  Common.h
//  TAToolkit
//
//  Created by Tom Krush on 8/28/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

void TAToolkitSetup();

CGFloat floatBetween(CGFloat smallNumber, CGFloat bigNumber);

void CGRectLog(CGRect rect);
void CGSizeLog(CGSize size);
void CGPointLog(CGPoint point);
void CFRangeLog(CFRange range);
void UIEdgeInsetsLog(UIEdgeInsets insets);

void UIInterfaceOrientationLog(UIInterfaceOrientation orientation);