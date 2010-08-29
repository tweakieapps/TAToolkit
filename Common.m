//
//  Common.m
//  TAToolkit
//
//  Created by Tom Krush on 8/28/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "Common.h"

CGFloat floatBetween(CGFloat smallNumber, CGFloat bigNumber)
{
    CGFloat diff = bigNumber - smallNumber;
    return (((CGFloat) arc4random() / RAND_MAX) * diff) + smallNumber;
}