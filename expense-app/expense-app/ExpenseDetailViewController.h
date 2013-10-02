//
//  ExpenseDetailViewController.h
//  expense-app
//
//  Created by Matt Schmulen on 9/28/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ExpenseModel.h"

@interface ExpenseDetailViewController : UIViewController < UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate >

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property BOOL usedCamera;
@property ExpenseModel *model;

@end
