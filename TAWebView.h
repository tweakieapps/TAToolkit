//
//  TAWebView.h
//  TAToolkit
//
//  Created by Tom Krush on 9/21/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TAWebView : UIWebView 
{

}

@property (nonatomic, assign) BOOL shadowsHidden;
@property (nonatomic, readonly) UIScrollView *scrollView;

- (void)loadURL:(NSURL *)url;
- (void)loadHTMLStringInMainBundle:(NSString *)string;

- (void)loadTemplate:(NSString *)templateName variables:(NSDictionary *)variables;

@end
