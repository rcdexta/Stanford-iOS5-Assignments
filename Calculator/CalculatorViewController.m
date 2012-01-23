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
- (void)appendToHistoryWithEquals:(NSString *)literal;
- (void)removeEqualsOperatorFromHistory;
- (void)updateCalculatorDisplay:(NSString *)resultString;
@end

@implementation CalculatorViewController

@synthesize history = _history;
@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;

@synthesize brain = _brain;
@synthesize testVariablesDisplay = testVariablesDisplay;

- (CalculatorBrain *) brain
{
  if (!_brain) _brain = [[CalculatorBrain alloc] init];
  return _brain;
}

- (IBAction)testVarsPressed:(id)sender {
  [self.brain setVariable:@"a" withValue:1];
  [self.brain setVariable:@"b" withValue:2];
  [self.brain setVariable:@"x" withValue:3];
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
  [self.brain pushOperand:self.display.text];
  self.userIsInTheMiddleOfEnteringNumber = FALSE;
}

- (IBAction)backspacePressed {
  if ([self.display.text length] > 0 && self.userIsInTheMiddleOfEnteringNumber){
    self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
  }
  else if (!self.userIsInTheMiddleOfEnteringNumber){
    [self.brain popOperand];
    [self updateCalculatorDisplay:self.display.text];
  }
}


- (IBAction)operatorPressed:(UIButton *)sender 
{
  if (self.userIsInTheMiddleOfEnteringNumber) [self enterPressed];
  double result = [self.brain performOperation:sender.currentTitle];
  NSString *resultString =[NSString stringWithFormat:@"%g", result];  
  [self updateCalculatorDisplay:resultString];
}

- (BOOL)containsDecimalPoint:(NSString *)number
{
  return [number rangeOfString:@"."].location != NSNotFound;
}

- (void)appendToHistoryWithEquals:(NSString*)literal
{
  self.history.text = literal;
  self.history.text = [self.history.text stringByAppendingString:@"="];
}

- (void)removeEqualsOperatorFromHistory
{
  self.history.text = [self.history.text stringByReplacingOccurrencesOfString:@" =" withString:@""];
}

- (void)updateCalculatorDisplay:(NSString *)resultString
{
  [self removeEqualsOperatorFromHistory];
  [self appendToHistoryWithEquals:[self.brain descriptionOfProgram]];
  self.testVariablesDisplay.text = [self.brain variablesUsedInProgram];
  self.display.text = resultString;
}

- (void)viewDidUnload {
  [self setHistory:nil];
  [self setTestVariablesDisplay:nil];
  [self setTestVariablesDisplay:nil];
  [super viewDidUnload];
}
@end
