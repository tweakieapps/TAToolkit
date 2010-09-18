//
//  UIToolbar+TAToolkitAdditons.m
//  TAToolkit
//
//  Created by Tom Krush on 9/18/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "UIToolbar+TAToolkitAdditons.h"

static NSMutableDictionary *toolbarImages = NULL;

@implementation UIToolbar (TAToolkitAdditons)

- (void)scDrawRect:(CGRect)rect
{
    UIImage *image=[toolbarImages objectForKey:[NSValue valueWithNonretainedObject: self]];

    if (image) {
		[image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    } else {
		[self scDrawRect:rect];
	}	
}

//Allow the setting of an image for the navigation bar
-(void)setBackgroundImage:(UIImage*)image
{
    if(toolbarImages==NULL){
        toolbarImages=[[NSMutableDictionary alloc] init];
    }   

    [toolbarImages setObject:image forKey:[NSValue valueWithNonretainedObject: self]];
}

@end