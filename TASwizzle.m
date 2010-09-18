//
//  TASwizzle.m
//  TAToolkit
//
//  Created by Tom Krush on 9/18/10.
//  Copyright 2010 Tweakie Apps. All rights reserved.
//

#import "TASwizzle.h"


@implementation TASwizzle

+ (void)swizzleSelector:(SEL)orig ofClass:(Class)c withSelector:(SEL)new;
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);

    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
    {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@end
