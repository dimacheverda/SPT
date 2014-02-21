//
//  SPTTextField.m
//  SPT
//
//  Created by Dima on 2/16/14.
//  Copyright (c) 2014 Dima. All rights reserved.
//

#import "SPTTextField.h"

@implementation SPTTextField {
    UIImage *_backgroundImageNormal;
    UIImage *_backgroundImageSelected;
    UIImage *_backgroundImageError;
}

#define NORMAL_IMAGE @"text-field-normal"
#define SELECTED_IMAGE @"text-field-selected"
#define ERROR_IMAGE @"text-field-error"

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    _backgroundImageNormal = [[UIImage imageNamed:NORMAL_IMAGE] resizableImageWithCapInsets:UIEdgeInsetsMake(23.0, 8.0, 23.0, 8.0)];
    _backgroundImageSelected = [[UIImage imageNamed:SELECTED_IMAGE] resizableImageWithCapInsets:UIEdgeInsetsMake(23.0, 8.0, 23.0, 8.0)];
    _backgroundImageError = [[UIImage imageNamed:ERROR_IMAGE] resizableImageWithCapInsets:UIEdgeInsetsMake(23.0, 8.0, 23.0, 8.0)];
    
    self.background = _backgroundImageNormal;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x += 15;
    bounds.size.width -= 30;
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds.origin.x += 15;
    bounds.size.width -= 30;
    return bounds;
}

- (BOOL)becomeFirstResponder
{
	BOOL flag = [super becomeFirstResponder];
	if(flag) {
        self.background = _backgroundImageSelected;
//        NSLog(@"Become first responder");
	}
	return flag;
}

- (BOOL)resignFirstResponder {
	BOOL flag = [super resignFirstResponder];
	if(flag) {
        self.background = _backgroundImageNormal;
//        NSLog(@"Resign first responder");
    }
	return flag;
}

- (void)setBackgroundToError
{
    self.background = _backgroundImageError;
}

@end
