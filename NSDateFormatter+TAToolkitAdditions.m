//
//  NSDateFormatter+TAToolkitAdditions.m
//  TAToolkit
//
//  Created by Tom Krush on 9/18/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "NSDateFormatter+TAToolkitAdditions.h"


@implementation NSDateFormatter (TAToolkitAdditions)

+ (NSString *)relativeTime:(NSDate *)date 
{
	return [NSDateFormatter relativeTime:date makeDaysBiggestUnit:NO];
}

+ (NSString *)relativeTime:(NSDate *)date makeDaysBiggestUnit:(BOOL)answer
{
    double ti = [date timeIntervalSinceDate:[NSDate date]];
    ti = ti * -1;
	
    if(ti < 1) {
        return @"never";
    } else if (ti < 60) {
        return @"now";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
		
		if (diff == 1) {
			return [NSString stringWithFormat:@"%d minute ago", diff];
		} else {
			return [NSString stringWithFormat:@"%d minutes ago", diff];
		}
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
		
		if (diff == 1) {
			return [NSString stringWithFormat:@"%d hour ago", diff];
		} else {
			return [NSString stringWithFormat:@"%d hours ago", diff];
		}
    } else {
		if (answer == YES || ti < 604800) {
			int diff = round(ti / 60 / 60 / 24);
			
			if (diff == 1) {
				return [NSString stringWithFormat:@"%d day ago", diff];
			} else {
				return [NSString stringWithFormat:@"%d days ago", diff];
			}		
		} else {
			int diff = round(ti / 60 / 60 / 24 / 7);

			if (diff == 1) {
				return [NSString stringWithFormat:@"%d week ago", diff];
			} else {
				return [NSString stringWithFormat:@"%d weeks ago", diff];
			}
		}	
    }   
}

@end
