//
//  ExpenseModel.h
//  expense-app
//
//  Created by Matt Schmulen on 9/30/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpenseModel : NSObject

@property (nonatomic, assign) NSUInteger postID;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *submittingEmployeeEmail;
@property (nonatomic, strong) NSString *submittingEmployeePhotoURL;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSNumber *amount;

//@property (nonatomic, strong) User *user;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
