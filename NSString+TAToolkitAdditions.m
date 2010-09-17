//
//  NSString+TAToolkitAdditions.m
//  TAToolkit
//
//  Created by Tom Krush on 9/14/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "NSString+TAToolkitAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (TAToolkitAdditions)

- (id)initWithContentsOfURLRequest:(NSURLRequest *)request encoding:(NSStringEncoding)enc error:(NSError **)error
{
	// Create pool to drain all unneccessary memory created at initializion. 
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	// Retrieve data from connection
	NSError *connectionError = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&connectionError];

	[connectionError retain];
	
	// Create string for return
	NSString *string = [[NSString alloc] initWithData:data encoding:enc];
	
	// Drain Pool
	[pool drain];
	
	if ( error != NULL ) 
	{
		*error = connectionError;
		[*error retain];
		[*error autorelease];
	}
	
	[connectionError release];
	
	// Return requested string
	return string;
}

- (BOOL)empty
{
	return ! self.length || ! [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

+ (NSString *) md5:(NSString *)str 
{
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [[NSString stringWithFormat:
		@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
		result[0], result[1], result[2], result[3], 
		result[4], result[5], result[6], result[7],
		result[8], result[9], result[10], result[11],
		result[12], result[13], result[14], result[15]
		] lowercaseString];	
}

@end
