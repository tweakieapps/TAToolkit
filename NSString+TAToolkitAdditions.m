//
//  NSString+TAToolkitAdditions.m
//  TAToolkit
//
//  Created by Tom Krush on 9/14/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "NSString+TAToolkitAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@interface TAStripHTML : NSObject <NSXMLParserDelegate>
{
	NSMutableString *_string;
}

- (NSString *)strip:(NSString *)string;

@end


@implementation TAStripHTML

- (id)init
{
	if(self = [super init]) 
	{
		_string = [[NSMutableString alloc] init];
	}

	return self;
}

- (NSString *)strip:(NSString *)string 
{
	NSMutableString *temp = [NSMutableString stringWithString:string];
	
	NSString* xmlStr = [NSString stringWithFormat:@"<d>%@</d>", temp];
	NSData *data = [xmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSXMLParser* xmlParse = [[NSXMLParser alloc] initWithData:data];
	[xmlParse setDelegate:self];
	[xmlParse parse];
	NSString* returnStr = [NSString stringWithFormat:@"%@", _string];
	[xmlParse release];
	
	return returnStr;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[_string appendString:string];
}

- (void)dealloc 
{
	[_string release];
	[super dealloc];
}

@end


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

- (NSString *)escapeHTML {
	NSMutableString *s = [NSMutableString string];

	int start = 0;
	int len = [self length];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];

	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound) {
			[s appendString:[self substringFromIndex:start]];
			break;
		}

		if (start < r.location) {
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}

		switch ([self characterAtIndex:r.location]) {
			case '<':
				[s appendString:@"&lt;"];
				break;
			case '>':
				[s appendString:@"&gt;"];
				break;
			case '"':
				[s appendString:@"&quot;"];
				break;
				//			case '…':
				//				[s appendString:@"&hellip;"];
				//				break;
			case '&':
				[s appendString:@"&amp;"];
				break;
		}

		start = r.location + 1;
	}

	return s;
}

- (NSString *)unescapeHTML {
	NSMutableString *s = [NSMutableString string];
	NSMutableString *target = [[self mutableCopy] autorelease];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];

	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[s appendString:target];
			break;
		}

		if (r.location > 0) {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}

		if ([target hasPrefix:@"&lt;"]) {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]) {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]) {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&#39;"] || [target hasPrefix:@"&#039;"]) {
			[s appendString:@"'"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else if ([target hasPrefix:@"&amp;"]) {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else if ([target hasPrefix:@"&hellip;"]) {
			[s appendString:@"…"];
			[target deleteCharactersInRange:NSMakeRange(0, 8)];
		} else if ([target hasPrefix:@"&#8217;"]) {
			[s appendString:@"’"];
			[target deleteCharactersInRange:NSMakeRange(0, 7)];
		} else if ([target hasPrefix:@"&rsquo;"]) {
			[s appendString:@"’"];
			[target deleteCharactersInRange:NSMakeRange(0, 7)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}

	return s;
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

- (NSString*)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font
{
	// Create copy that will be the returned result
	NSMutableString *truncatedString = [[self mutableCopy] autorelease];
 
	NSString *ellipsis = @"…";
 
	// Make sure string is longer than requested width
	if ([self sizeWithFont:font].width > width)
	{
		// Accommodate for ellipsis we'll tack on the end
		width -= [ellipsis sizeWithFont:font].width;

		// Get range for last character in string
		NSRange range = {truncatedString.length - 1, 1};

		// Loop, deleting characters until string fits within width
		while ([truncatedString sizeWithFont:font].width > width) 
		{
			// Delete character at end
			[truncatedString deleteCharactersInRange:range];

			// Move back another character
			range.location--;
		}

		// Append ellipsis
		[truncatedString replaceCharactersInRange:range withString:ellipsis];
	}

	return truncatedString;
}

- (NSString *)stripHTML
{
	NSString *string = self;
	NSError *error = nil;
	
	NSRegularExpression *replace = [[NSRegularExpression alloc] initWithPattern:@"<script[^>]*>.*</script>|<style[^>]*>.*</style>|<[^>]*>" options:0 error:&error];
	string = [replace stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
	[replace release];

	return string;
}

@end
