//
//  AppDelegate.m
//  expense-app
//
//  Created by Matt Schmulen on 9/27/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//
#import <Crashlytics/Crashlytics.h>
#import "AppDelegate.h"
 #import "AFNetworkActivityIndicatorManager.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [Crashlytics startWithAPIKey:@"bcc6ec11a2934eaf4cf2218cf4928e52b6f7be66"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}








// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Show error
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Once this method is invoked, "responseData" contains the complete result
}


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

+ (void) faceDetectFromPicture: (NSString*) photoURL
{
    
}//end getSignatureFromPicture


//update the HP Token
static NSString* _HPTOKEN = nil;
+ (void ) updateHPToken
{
}

+ (void ) forceHPTokenRefresh
{
    
}//end forceHPTokenRefresh

+ (void) identifyFacesFromPicture: (NSString*) photoURL
{
    
}//end identifyFacesFromPicture

+ (void) facePrintFromImage : (NSURL *)imageURL
{
}//end facePrintFromImage

- (void) submitExpenseToConcur
{
}//end submitToConcur


+ (void) initializeServerData
{
}


@end
