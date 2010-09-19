//
//  NSString+TAToolkitAdditions.h
//  TAToolkit
//
//  Created by Tom Krush on 9/14/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TAToolkitAdditions)

- (id)initWithContentsOfURLRequest:(NSURLRequest *)request encoding:(NSStringEncoding)enc error:(NSError **)error;

+ (NSString *)md5:(NSString *)sting;

- (BOOL)empty;


- (NSString *)escapeHTML;
- (NSString *)unescapeHTML;

- (NSString *)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font;

@end
