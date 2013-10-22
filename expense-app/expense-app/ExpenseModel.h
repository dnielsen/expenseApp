//
//  ExpenseModel.h
//  expense-app
//
//  Created by Matt Schmulen on 9/30/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpenseModel : NSObject

//@property (nonatomic, assign) NSUInteger postID;
//@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSString *ReportName;
@property (nonatomic, strong) NSString *PaymentStatus;
@property (nonatomic, strong) NSString *ReportDetailsURL;
@property (nonatomic, strong) NSString *ReportCurrency;
@property (nonatomic, strong) NSString *ReportDate;
@property (nonatomic, strong) NSString *ReportId;
@property (nonatomic, assign) double ReportTotal;
@property (nonatomic, strong) NSString *LastComment;
@property (nonatomic, strong) NSString *ExpenseUserLoginID;
@property (nonatomic, strong) NSString *EmployeeName;
@property (nonatomic, strong) NSString *ApprovalStatus;
@property (nonatomic, strong) NSString *ExpenseType;
@property (nonatomic, strong) NSString *ExpenseTypeId;
@property (nonatomic, strong) NSString *entryId;
//@property (nonatomic, strong) User *user;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
