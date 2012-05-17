//
//  MainViewController.h
//  caculator
//
//  Created by Weiwu on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MainViewController : UIViewController {
    IBOutlet UILabel *statuLabel;
    float memory;
    BOOL memoryUsed;
    BOOL dotUsed;
    int controlState;
    BOOL hasError;
    BOOL needClear;
}
@end
