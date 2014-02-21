//
//  SPTPlaySession.m
//  SPT
//
//  Created by Dima on 2/14/14.
//  Copyright (c) 2014 Dima. All rights reserved.
//

#import "SPTPlaySession.h"
#import "SPTQuestion.h"

@interface SPTPlaySession ()

@end

@implementation SPTPlaySession

- (instancetype)initWithQuestions
{
    if (self) {
        NSArray *rawQuestions = [self readQuestionsFromFile];
        NSMutableArray *questions = [NSMutableArray new];
        
        for (NSDictionary *rawQuestion in rawQuestions) {
            SPTQuestion *question = [[SPTQuestion alloc] initWithDictionary:rawQuestion];
            [questions addObject:question];
        }
        
        _score = 0;
        _currentQuestionIndex = 0;
        _questions = questions;
    }
    
    return self;
}

- (NSArray *)readQuestionsFromFile
{
    NSArray *array;
    NSDictionary *dictionary;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"QuestionsDB" ofType:@"plist"];
    
    dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    array = [NSArray arrayWithArray:dictionary[@"questions"]];
    
    return array;
}

- (BOOL)checkQuestionWithAnswer:(NSString *)answer
{
    SPTQuestion *question = [SPTQuestion new];
    question = self.questions[_currentQuestionIndex];
    return [question.answer isEqualToString:answer];
}

@end
