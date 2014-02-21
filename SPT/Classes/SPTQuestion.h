//
//  SPTQuestion.h
//  SPT
//
//  Created by Dima on 2/14/14.
//  Copyright (c) 2014 Dima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPTQuestion : NSObject

@property (strong, nonatomic) NSString *problem;
@property (strong, nonatomic) NSString *answer;
@property (strong, nonatomic) NSArray *variants;

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

@end
