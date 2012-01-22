//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Ramachandran Ramarathinam on 21/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#import <math.h>

@interface CalculatorBrain()
@property (nonatomic,strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSMutableDictionary *testVariables;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize testVariables = _testVariables;
@synthesize numberFormatter = _numberFormatter;

- (NSNumberFormatter *)numberFormatter
{
    if (!_numberFormatter) _numberFormatter = [[NSNumberFormatter alloc] init];
    return _numberFormatter;
}

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (NSDictionary *)testVariables
{
    if (!_testVariables) _testVariables = [[NSMutableDictionary alloc] init];
    return _testVariables;
}

- (void)setVariable:(NSString *)variable withValue:(double)value
{
    [self.testVariables setValue:[NSNumber numberWithDouble:value] forKey:variable];
}

- (void)clear
{
    [self.programStack removeAllObjects];
}

- (void) pushOperand:(NSString *)operand
{
    if ([self.numberFormatter numberFromString:operand]){
        [self.programStack addObject:[NSNumber numberWithDouble:[operand doubleValue]]];
    } else {
        [self.programStack addObject:operand];
    }
    
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program usingVariableValues:self.testVariables];
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"implement as home work";
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    } 
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([@"*" isEqualToString:operation]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        }
        else if ([@"/" isEqualToString:operation]){
            double divisor = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] / divisor;
        }
        else if ([@"-" isEqualToString:operation]){
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        }
        else if ([@"sin" isEqualToString:operation]){
            result = sin([self popOperandOffStack:stack] * M_PI / 180);
        }
        else if ([@"cos" isEqualToString:operation]){
            result = cos([self popOperandOffStack:stack] * M_PI / 180);
        }
        else if ([@"sqrt" isEqualToString:operation]){
            result = sqrt([self popOperandOffStack:stack]);
        }
        else if ([@"π" isEqualToString:operation]){
            result = M_PI;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    
    NSArray *variables = [variableValues allKeys];
    
    for(int index=0;index<stack.count;index++){
        id element = [stack objectAtIndex:index];
        if ([element isKindOfClass:[NSString class]] && //operator or variable maybe..
            [variables containsObject:element]) //definitely variable
        { 
            [stack replaceObjectAtIndex:index withObject:[variableValues objectForKey:element]];
        }
    }
    
    return [self popOperandOffStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    return [[NSSet alloc]init];
}

@end
