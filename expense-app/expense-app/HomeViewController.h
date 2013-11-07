//
//  HomeViewController.h
//  expense-app
//
//  Created by Matt Schmulen on 9/28/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HomeViewController : UIViewController < UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
{
    AppDelegate *appdel;
    IBOutlet UIView *imageDrawView;
}
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property BOOL usedCamera;

- (void)HpFaceDetection;
- (void)HpAuthentication;

@end
