//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Ramachandran Ramarathinam on 21/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) setVariable:(NSString *)variable withValue:(double)value;
- (NSString *) popOperand;
- (void) pushOperand:(NSString *)operand;
- (double)performOperation:(NSString *)operation;
- (NSString *)descriptionOfProgram;
- (void) clear;
- (NSString *)variablesUsedInProgram;

@property (readonly) id program;

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

@end
