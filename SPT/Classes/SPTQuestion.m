//
//  SPTQuestion.m
//  SPT
//
//  Created by Dima on 2/14/14.
//  Copyright (c) 2014 Dima. All rights reserved.
//

#import "SPTQuestion.h"

@implementation SPTQuestion

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    if (self) {
        if (aDictionary[@"problem"]) {
            self.problem = aDictionary[@"problem"];
        } else
            self.problem = @"empty";
        
        if (aDictionary[@"answer"]) {
            self.answer = aDictionary[@"answer"];
        } else
            self.answer = @"empty";
        
        if (aDictionary[@"variants"]) {
            self.variants = aDictionary[@"variants"];
        } else
            self.variants = @[@"empty",@"empty",@"empty",@"empty"];

    }
    
    return self;
}

@end
