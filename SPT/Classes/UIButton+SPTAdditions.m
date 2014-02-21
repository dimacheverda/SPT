//
//  UIButton+SPTAdditions.m
//  SPT
//
//  Created by Dima on 2/15/14.
//  Copyright (c) 2014 Dima. All rights reserved.
//

#import "UIButton+SPTAdditions.h"

@implementation UIButton (SPTAdditions)

- (void)setFlatBackgroundColor:(UIColor *)aColor withCornerRadius:(CGFloat)aRadius
{
    [self setBackgroundColor:aColor];
    [self.layer setCornerRadius:aRadius];
}

@end
