//
//  HomeViewController.h
//  expense-app
//
//  Created by Matt Schmulen on 9/28/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController < UIImagePickerControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property BOOL usedCamera;

@end
