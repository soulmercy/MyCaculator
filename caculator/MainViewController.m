//
//  MainViewController.m
//  caculator
//
//  Created by Weiwu on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#define kDigitalButtonBaseTag 1000
#define kControlButtonBaseTag 2000

#define MaxLength 9
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self clearAll];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - Private
- (void)showOverflowWarning
{
//    UIColor *currentColor = statuLabel.textColor;
//    statuLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    CGFloat currentAlpha = statuLabel.alpha;
    statuLabel.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^(void) {
        statuLabel.alpha = currentAlpha;
    }];
}

- (float)currentValue
{   
    return [statuLabel.text floatValue];
}

- (void)SetCurrentValue:(float)value;
{
    int intArea = (int)value;
    NSString *result;
    if(value - intArea > 0) {
        NSString *formatStr = [NSString stringWithFormat:@"%%%df", MaxLength];
        result = [NSString stringWithFormat:formatStr, value];
    } else {
        result = [NSString stringWithFormat:@"%d", intArea];
    }
    statuLabel.text = result;
}
- (void)saveToMemory
{
    memory = [self currentValue];
    memoryUsed = YES;
}

- (void)saveToMemoryValue:(float)value
{
    memory = value;
    memoryUsed = YES;
}
- (void)clearCurrent
{
    statuLabel.text = @"0";
    dotUsed = 0;
    return;
}

- (void)clearAll
{
    [self clearCurrent];
    memoryUsed = NO;
    controlState = 0;
    hasError = NO;
    needClear = NO;
}

- (void)caculate
{
    double result;
    switch (controlState) {
        case 0:
            break;
        case 1:
            result = [self currentValue] + memory;
            break;
        case 2:
            result = [self currentValue] - memory;
            break;
        case 3:
            result = [self currentValue] * memory;
            break;
        case 4:
            if([self currentValue] == 0) {
                hasError = YES;
            } else {
                result = memory / [self currentValue];
            }
            break;
        default:
            break;
    }
    [self SetCurrentValue:(float)result];
    [self saveToMemoryValue:(float)result];
}
#pragma mark - IBActions
- (IBAction)onDigitalButtonClicked:(id)sender
{
    int digitalNumber = ((UIView *)sender).tag - kDigitalButtonBaseTag;
//    NSLog(@"%d button clicked", digitalNumber);
    if(hasError && digitalNumber != 11) {
        return;
    }
    if(digitalNumber >= 0 && digitalNumber <= 9) {
        if(needClear) {
            [self clearCurrent];
            needClear = NO;
        }
        if(statuLabel.text.length >= MaxLength) {
            [self showOverflowWarning];
            return;
        }
        NSString *formerStr = statuLabel.text;
        if([formerStr isEqualToString:@"0"]) formerStr = @"";
        NSString *newStr = [NSString stringWithFormat:@"%@%d", formerStr, digitalNumber];
        statuLabel.text = newStr;
    } else if(digitalNumber == 12) {
        if(needClear) {
            [self clearCurrent]; 
            needClear = NO;
        }
        if(!dotUsed) {
            NSString *formerStr = statuLabel.text;
            NSString *newStr = [NSString stringWithFormat:@"%@%@", formerStr, @"."];
            statuLabel.text = newStr;
            dotUsed = YES;
        }
    } else if(digitalNumber == 10) {
        [self clearCurrent];
    } else if(digitalNumber == 11) {
        [self clearAll];
    }
}

- (IBAction)onControlButtonClicked:(id)sender
{
    int controlButton = ((UIView *)sender).tag - kControlButtonBaseTag;
    switch (controlButton) {
        case 0: {
            controlState = 0;
            [self caculate];
            needClear = YES;
            break;
        }
        case 1:
        case 2:
        case 3:
        case 4:
//            [self saveToMemory];
            if(!controlState) {
                [self clearCurrent];
            } else {
                [self caculate];
                needClear = YES;
            }
            controlState = controlButton;
            break;
        default:
            NSLog(@"%s: unhandled tag %d", __FUNCTION__ ,((UIView *)sender).tag);
            return;
    }
}
@end
