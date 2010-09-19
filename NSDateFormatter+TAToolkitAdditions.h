//
//  NSDateFormatter+TAToolkitAdditions.h
//  TAToolkit
//
//  Created by Tom Krush on 9/18/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDateFormatter (TAToolkitAdditions) 

+ (NSString *)relativeTime:(NSDate *)date;
+ (NSString *)relativeTime:(NSDate *)date makeDaysBiggestUnit:(BOOL)answer;

@end

