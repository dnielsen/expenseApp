//
//  ExpenseListViewController.h
//  expense-app
//
//  Created by Matt Schmulen on 9/28/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ExpenseModel.h"
@interface ExpenseListViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>
{
    AppDelegate *appdel;
    NSString *strFlag;
    int a;
    UIViewController *controller;
    ExpenseModel *detailModel;
    
}
@property (nonatomic, strong)NSString *strFlag;

- (void)getReportDetails : (NSString *)repId;
- (void)authenticateUser:(NSString *)uname1 : (NSString *)pass1;


@end
