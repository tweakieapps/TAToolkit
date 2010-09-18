//
//  TASwizzle.h
//  TAToolkit
//
//  Created by Tom Krush on 9/18/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import </usr/include/objc/objc-class.h>


@interface TASwizzle : NSObject 

+ (void)swizzleSelector:(SEL)orig ofClass:(Class)c withSelector:(SEL)new;

@end
