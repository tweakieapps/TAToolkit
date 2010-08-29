//
//  UIViewAdditions.m
//  TAToolkit
//
//  Created by Tom Krush on 8/28/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "UIView+TAToolkitAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (TAToolkitAdditions)

#pragma mark -
#pragma mark Frame

- (CGFloat)left {
  return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (CGFloat)top {
  return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}

- (CGFloat)right {
  return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
  CGRect frame = self.frame;
  frame.origin.x = right - frame.size.width;
  self.frame = frame;
}

- (CGFloat)bottom {
  return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
  CGRect frame = self.frame;
  frame.origin.y = bottom - frame.size.height;
  self.frame = frame;
}

- (CGFloat)width {
  return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}

- (CGFloat)height {
  return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}

- (CGPoint)origin {
  return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
  CGRect frame = self.frame;
  frame.origin = origin;
  self.frame = frame;
}
- (CGSize)size {
  return self.frame.size;
}

- (void)setSize:(CGSize)size {
  CGRect frame = self.frame;
  frame.size = size;
  self.frame = frame;
}


#pragma mark -
#pragma mark Bounds

- (CGFloat)paddingLeft {
  return self.bounds.origin.x;
}

- (void)setPaddingLeft:(CGFloat)x {
  CGRect bounds = self.bounds;
  bounds.origin.x = x;
  self.bounds = bounds;
}

- (CGFloat)paddingTop {
  return self.bounds.origin.y;
}

- (void)setPaddingTop:(CGFloat)y {
  CGRect bounds = self.bounds;
  bounds.origin.y = y;
  self.bounds = bounds;
}

- (CGFloat)paddingRight {
  return self.bounds.origin.x + self.bounds.size.width;
}

- (void)setPaddingRight:(CGFloat)right {
  CGRect bounds = self.bounds;
  bounds.origin.x = right - bounds.size.width;
  self.bounds = bounds;
}

- (CGFloat)paddingBottom {
  return self.bounds.origin.y + self.bounds.size.height;
}

- (void)setPaddingBottom:(CGFloat)bottom {
  CGRect bounds = self.bounds;
  bounds.origin.y = bottom - bounds.size.height;
  self.bounds = bounds;
}

- (CGFloat)innerWidth {
  return self.bounds.size.width;
}

- (void)setInnerWidth:(CGFloat)width {
  CGRect bounds = self.bounds;
  bounds.size.width = width;
  self.bounds = bounds;
}

- (CGFloat)innerHeight {
  return self.bounds.size.height;
}

- (void)setInnerHeight:(CGFloat)height {
  CGRect bounds = self.bounds;
  bounds.size.height = height;
  self.bounds = bounds;
}

- (CGPoint)paddingOrigin {
  return self.bounds.origin;
}

- (void)setPaddingOrigin:(CGPoint)origin {
  CGRect bounds = self.bounds;
  bounds.origin = origin;
  self.bounds = bounds;
}
- (CGSize)paddingSize {
  return self.bounds.size;
}

- (void)setPaddingSize:(CGSize)size {
  CGRect bounds = self.bounds;
  bounds.size = size;
  self.bounds = bounds;
}

#pragma mark -
#pragma mark Center

- (CGFloat)centerX {
  return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
  self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
  return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
  self.center = CGPointMake(self.center.x, centerY);
}

#pragma mark -

- (UIImage *)imageRepresentation {
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (void)removeAllSubviews {
  while (self.subviews.count) {
    UIView* child = self.subviews.lastObject;
    [child removeFromSuperview];
  }
}

@end
