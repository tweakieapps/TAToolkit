//
//  TAWebViewController.h
//  TAToolkit
//
//  Created by Tom Krush on 9/21/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAViewController.h"
#import "TAWebView.h"

@interface TAWebViewController : TAViewController <UIWebViewDelegate>
{
	TAWebView *_webview;
}

- (TAWebView *)webview;

@end
