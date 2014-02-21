//
//  SPTPlaySession.h
//  SPT
//
//  Created by Dima on 2/14/14.
//  Copyright (c) 2014 Dima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPTQuestion;

@interface SPTPlaySession : NSObject

@property (strong, nonatomic) NSArray *questions;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger currentQuestionIndex;

- (instancetype)initWithQuestions;
- (BOOL)checkQuestionWithAnswer:(NSString *)answer;

@end