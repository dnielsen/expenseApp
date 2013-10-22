//
//  AppDelegate.h
//  My ExpenceApp
//
//  Created by Dimple on 08/10/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RXMLElement.h"
#import "Base64.h"
#import "utility.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

//- (void)authenticateUser:(NSString *)uname1 : (NSString *)pass1;


@end
