//
//  TAWebView.m
//  TAToolkit
//
//  Created by Tom Krush on 9/21/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "TAWebView.h"


@implementation TAWebView

- (void)loadURL:(NSURL *)url
{
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	[self loadRequest:request];
	[request release];
}

- (UIScrollView *)scrollView
{
	UIView *view = [[self subviews] objectAtIndex:0];
	
	if ( [view isKindOfClass:[UIScrollView class]] )
	{
		return (UIScrollView *)[[self subviews] objectAtIndex:0];
	}
	
	return nil;
}

- (BOOL)shadowsHidden 
{
	return [[[self.scrollView subviews] objectAtIndex:0] isHidden];
}

- (void)setShadowsHidden:(BOOL)hide 
{
	NSArray *subviews = [self.scrollView subviews];
	
	for (UIView *subview in subviews) 
	{	
		if ([subview class] == [UIImageView class]) 
		{		
			subview.hidden = hide;
		}
	}
}

- (void)loadHTMLStringInMainBundle:(NSString *)string
{
	NSURL *url = [[NSBundle mainBundle] bundleURL];
			
	[self loadHTMLString:string baseURL:url];
}

- (void)loadTemplate:(NSString *)templateName variables:(NSDictionary *)variables
{
	[variables retain];

	NSString *templatePath = [[NSBundle mainBundle] pathForResource:templateName ofType:@"html"];
	NSData *templateData = [NSData dataWithContentsOfFile:templatePath];
		
	__block NSString *template = [[[NSString alloc] initWithData:templateData encoding:NSUTF8StringEncoding] retain];
	
	// Possible leak. I am doing a lot of retaining to prevent crashes. But I am sure that there is a leak because it.
	[variables enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		NSString *variable = [NSString stringWithFormat:@"{%@}", key];

		template = [[template stringByReplacingOccurrencesOfString:variable withString:obj] retain];
	}];
				
	[variables release];
	
	[self loadHTMLStringInMainBundle:template];
}

@end
