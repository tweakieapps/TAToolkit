//
//  UINavigationBar+TAToolkitAdditions.m
//  TAToolkit
//
//  Created by Tom Krush on 9/18/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "UINavigationBar+TAToolkitAdditions.h"

static NSMutableDictionary *navigationBarImages = NULL;

@implementation UINavigationBar (TAToolkitAdditions)

- (void)scDrawRect:(CGRect)rect
{
    UIImage *image=[navigationBarImages objectForKey:[NSValue valueWithNonretainedObject: self]];

    if (image) {
		[image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    } else {
		[self scDrawRect:rect];
	}	
}

//Allow the setting of an image for the navigation bar
-(void)setBackgroundImage:(UIImage*)image
{
    if (navigationBarImages==NULL)
	{
        navigationBarImages=[[NSMutableDictionary alloc] init];
    }   

    [navigationBarImages setObject:image forKey:[NSValue valueWithNonretainedObject: self]];
}

- (UIImage *)backgroundImage
{
    UIImage *image=[navigationBarImages objectForKey:[NSValue valueWithNonretainedObject: self]];
	
	return image;
}

@end