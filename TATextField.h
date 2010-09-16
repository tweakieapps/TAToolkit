//
//  TATextField.h
//  TAToolkit
//
//  Created by Tom Krush on 9/16/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TATextField : UITextField 
{
	UIEdgeInsets _textInsets;
}

@property (nonatomic, assign) UIEdgeInsets textInsets;

@end
