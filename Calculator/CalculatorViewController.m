//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Ramachandran Ramarathinam on 21/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
- (BOOL)containsDecimalPoint:(NSString *)number;
- (void)appendToHistory:(NSString *)literal;
- (void)appendToHistoryWithEquals:(NSString *)literal;
- (void)removeEqualsOperatorFromHistory;
@end

@implementation CalculatorViewController

@synthesize history = _history;
@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;

- (CalculatorBrain *) brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton  *)sender 
{
    NSString *digit = sender.currentTitle;
    
    if (self.userIsInTheMiddleOfEnteringNumber){
        if ([digit isEqualToString:@"."] && [self containsDecimalPoint:self.display.text]){
            return;
        }
        self.display.text = [self.display.text stringByAppendingString:digit];
        
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringNumber = TRUE;
        [self removeEqualsOperatorFromHistory];
    }
}

- (IBAction)clearPressed {
    [self.brain clear];
    self.display.text = @"";
    self.history.text = @"";
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self appendToHistory:self.display.text];
    self.userIsInTheMiddleOfEnteringNumber = FALSE;
}

- (IBAction)backspacePressed {
    if ([self.display.text length] > 0 && self.userIsInTheMiddleOfEnteringNumber)
        self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
}

- (IBAction)changeSignPressed {
    double signToggledValue = [self.display.text doubleValue] * -1;
    self.display.text = [NSString stringWithFormat:@"%g", signToggledValue];
}


- (IBAction)operatorPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringNumber) [self enterPressed];
    [self removeEqualsOperatorFromHistory];
    [self appendToHistoryWithEquals:sender.currentTitle];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString =[NSString stringWithFormat:@"%g", result];  
    self.display.text = resultString;
}

- (BOOL)containsDecimalPoint:(NSString *)number
{
    return [number rangeOfString:@"."].location != NSNotFound;
}

- (void)appendToHistory:(NSString*)literal
{
    self.history.text = [self.history.text stringByAppendingString:literal];
    self.history.text = [self.history.text stringByAppendingString:@" "];
}

- (void)appendToHistoryWithEquals:(NSString*)literal
{
    [self appendToHistory:literal];
    [self appendToHistory:@"="];
}

- (void)removeEqualsOperatorFromHistory
{
    self.history.text = [self.history.text stringByReplacingOccurrencesOfString:@" =" withString:@""];
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [super viewDidUnload];
}
@end
