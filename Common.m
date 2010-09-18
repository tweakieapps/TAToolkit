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