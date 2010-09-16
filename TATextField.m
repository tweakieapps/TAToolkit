//
//  TATextField.m
//  TAToolkit
//
//  Created by Tom Krush on 9/16/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "TATextField.h"


@implementation TATextField

@synthesize textInsets = _textInsets;

#pragma mark UIView

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
        self.textInsets = UIEdgeInsetsZero;
    }
    return self;
}

#pragma mark UITextField

- (CGRect)textRectForBounds:(CGRect)bounds 
{
	return UIEdgeInsetsInsetRect(bounds, self.textInsets);
}


- (CGRect)editingRectForBounds:(CGRect)bounds 
{
	return [self textRectForBounds:bounds];
}

@end
