//
//  AppDelegate.h
//  expense-app
//
//  Created by Matt Schmulen on 9/27/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import <Availability.h>
#import <UIKit/UIKit.h>
#import "utility.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//+ (LBRESTAdapter *) adapter;
//+ (LBModel *) currentUser;

//+ (void) submitExpenseToConcur;
//+ (void) facePrintFromImage;

+ (void) initializeServerData;

+ (void) updateHPToken;
+ (void) forceHPTokenRefresh;
+ (void) identifyFacesFromPicture: (NSString*) photoURL;
+ (void) faceDetectFromPicture: (NSString*) photoURL;
//+ (void) forceHPTokenRefresh;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil


@end
