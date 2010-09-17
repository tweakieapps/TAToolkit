//
//  NSMutableURLRequest+TAToolkitAdditions.h
//  TAToolkit
//
//  Created by Tom Krush on 9/16/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableURLRequest (TAToolkitAdditions)

- (void)addPostValue:(NSString *)value forKey:(NSString *)key;

@end