//
//  NSMutableURLRequest+TAToolkitAdditions.m
//  TAToolkit
//
//  Created by Tom Krush on 9/16/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "NSMutableURLRequest+TAToolkitAdditions.h"


@implementation NSMutableURLRequest (TAToolkitAdditions)

- (void)addPostValue:(NSString *)value forKey:(NSString *)key
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// Create post string
	NSString *post = [NSString stringWithFormat:@"&%@=%@", key, value];
	
	// Encode it as UTF 8 for data
	NSData *data = [post dataUsingEncoding:NSUTF8StringEncoding];
	
	// Retrieve http body from request
	NSMutableData *postData = [NSMutableData dataWithData:[self HTTPBody]];
	
	// Append new post data
	[postData appendData:data];
	
	// Set post data
	[self setHTTPBody:postData];
	
	[pool release];
}

@end
