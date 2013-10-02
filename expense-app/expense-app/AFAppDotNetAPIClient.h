//
//  AFAppDotNetAPIClient.h
//  expense-app
//
//  Created by Matt Schmulen on 9/30/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFAppDotNetAPIClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end
