//
//  utility.h
//  expenseWithFaceRecognition
//
//  Created by Matt Schmulen on 9/23/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#ifndef expenseWithFaceRecognition_utility_h
#define expenseWithFaceRecognition_utility_h


#pragma mark - Platform
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_SIMULATOR TARGET_IPHONE_SIMULATOR



#define kURL @"https://www.concursolutions.com"

//Dimple
#define kConsumerKey @"C7lBL79v9y3CCzV2GnLCje"
//get your own consumer key by registering with Concur Connect as a developer

#define ALERTLOGIN                  101
#define ALERTNOUSERPASS             102




#endif
