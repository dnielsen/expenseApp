//
//  ExpenseModel.m
//  expense-app
//
//  Created by Matt Schmulen on 9/30/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "ExpenseModel.h"
#import "ModelUser.h"

//#import "AFAppDotNetAPIClient.h"

@implementation ExpenseModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.ApprovalStatus = [attributes valueForKeyPath:@"ApprovalStatus"];
    self.EmployeeName = [attributes valueForKeyPath:@"EmployeeName"];
    
    self.ExpenseUserLoginID = [attributes valueForKeyPath:@"ExpenseUserLoginID"];
    self.LastComment = [attributes valueForKeyPath:@"LastComment"];
    self.PaymentStatus = [attributes valueForKeyPath:@"PaymentStatus"];
    self.ReportCurrency = [attributes valueForKeyPath:@"ReportCurrency"];
    self.ReportDate = [attributes valueForKeyPath:@"ReportDate"];
    self.ReportDetailsURL = [attributes valueForKeyPath:@"ReportDetailsURL"];
    self.ReportId = [attributes valueForKeyPath:@"ReportId"];
    self.ReportName = [attributes valueForKeyPath:@"ReportName"];
    self.ReportTotal = [[attributes valueForKeyPath:@"ReportTotal"] doubleValue];
//    self.ExpenseType = [attributes valueForKeyPath:@"ReportName"];
    //self.user = [[User alloc] initWithAttributes:[attributes valueForKeyPath:@"user"]];
    
    
    return self;
}

#pragma mark -
/*
+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    return [[AFAppDotNetAPIClient sharedClient] GET:@"expense" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            ExpenseModel *post = [[ExpenseModel alloc] initWithAttributes:attributes];
            [mutablePosts addObject:post];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
 */
@end
