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
#import "utility.h"



@interface ExpenseDetailViewController : UIViewController < UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *appdel;
    NSString *Flag;
    IBOutlet UITextField *txtExpType;
    IBOutlet UIPickerView *picker;
    NSArray *arrPicker;
    NSString *strExpKey;
    UIViewController *controller;
    NSString *groupImgStr;
    IBOutlet UITableView *tbl;
    IBOutlet UITableView *tblAttendeeList;
    NSMutableArray *arrVerifyFacesRect;
    NSMutableArray *arrVerifyFacesNames;
    NSMutableArray *arrFinal;
    NSArray *arrTable;
    BOOL TouchFlg;
    IBOutlet UIView *loadView;
    NSMutableArray *arrAttendeeList;
}

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property BOOL usedCamera;
@property ExpenseModel *model;
@property (strong, nonatomic) IBOutlet UITextField *txtExpType;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSString *Flag;


- (void)authenticateUser:(NSString *)uname1 : (NSString *)pass1;
- (void)addWaitView;
- (void)removeWaitView;
- (void)faceTouched:(id)sender;

@end
