//
//  TAWebViewController.m
//  TAToolkit
//
//  Created by Tom Krush on 9/21/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "TAWebViewController.h"

@interface TAWebViewController ()

- (void)webViewDidFinishLoadingDom:(TAWebView *)webview;

@end


@implementation TAWebViewController

- (TAWebView *)webview
{
	if ( ! _webview )
	{
		_webview = [[TAWebView alloc] init];
		_webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_webview.frame = self.view.bounds;
		_webview.shadowsHidden = YES;
		_webview.delegate = self;
		_webview.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
	}
	
	return _webview;
}

- (void)webViewDidFinishLoadingDom:(TAWebView *)webview
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webview
{	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidStartLoad:(TAWebView *)webview
{	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	//[webview stringByEvaluatingJavaScriptFromString:@"window.addEventListener('load',function(){location.href='x-tawebview://dom-loaded';});"];
}

- (BOOL)webView:(TAWebView *)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {

	NSURL *url = request.URL;	
		
	if ( [[url absoluteString] isEqualToString:@"x-tawebview://dom-loaded"] ) 
	{
		[self webViewDidFinishLoadingDom:webView];
		return NO;
	}
	
	return YES;
}

- (void)viewDidLoad
{
	[self.view addSubview:self.webview];
}

- (void)dealloc
{
	[_webview release];

	[super dealloc];
}

@end