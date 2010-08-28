//
//  UIViewAdditions.h
//  TAToolkit
//
//  Created by Tom Krush on 8/28/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewAdditions)

#pragma mark -
#pragma mark Frame

@property(nonatomic) CGFloat left;

@property(nonatomic) CGFloat top;

@property(nonatomic) CGFloat right;

@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;

@property(nonatomic) CGFloat height;

@property(nonatomic) CGPoint origin;

@property(nonatomic) CGSize size;

#pragma mark -
#pragma mark Bounds

@property(nonatomic) CGFloat paddingLeft;

@property(nonatomic) CGFloat paddingTop;

@property(nonatomic) CGFloat paddingRight;

@property(nonatomic) CGFloat paddingBottom;

@property(nonatomic) CGFloat innerWidth;

@property(nonatomic) CGFloat innerHeight;

@property(nonatomic) CGPoint paddingOrigin;

@property(nonatomic) CGSize paddingSize;

#pragma mark -
#pragma mark Center

@property(nonatomic) CGFloat centerX;

@property(nonatomic) CGFloat centerY;

#pragma mark -

- (UIImage *)imageRepresentation;

- (void)removeAllSubviews;

@end
