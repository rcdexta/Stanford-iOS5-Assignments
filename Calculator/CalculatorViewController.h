//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Ramachandran Ramarathinam on 21/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *history;
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (nonatomic,strong) CalculatorBrain *brain;
@property (weak, nonatomic) IBOutlet UILabel *testVariablesDisplay;


@end
