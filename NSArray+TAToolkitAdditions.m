//
//  NSArray+TAToolkitAdditions.m
//  TAToolkit
//
//  Created by Guest Account on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSArray+TAToolkitAdditions.h"

@implementation NSArray (TAToolkitAdditions)

- (NSArray *)arrayReversed
{
	return [[self reverseObjectEnumerator] allObjects];
}

@end
