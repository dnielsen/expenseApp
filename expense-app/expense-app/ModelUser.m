//
//  ModelUser.m
//  expense-app
//
//  Created by Matt Schmulen on 9/30/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "ModelUser.h"
//#import "AFHTTPRequestOperation.h"

NSString * const kUserProfileImageDidLoadNotification = @"com.alamofire.user.profile-image.loaded";

@interface ModelUser ()
@property (readwrite, nonatomic, assign) NSUInteger userID;
@property (readwrite, nonatomic, copy) NSString *username;
@property (readwrite, nonatomic, copy) NSString *avatarImageURLString;
//@property (readwrite, nonatomic, strong) AFHTTPRequestOperation *avatarImageRequestOperation;

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
+ (NSOperationQueue *)sharedProfileImageRequestOperationQueue;
#endif
@end

@implementation ModelUser


- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.userID = [[attributes valueForKeyPath:@"id"] integerValue];
    self.username = [attributes valueForKeyPath:@"username"];
    self.avatarImageURLString = [attributes valueForKeyPath:@"avatar_image.url"];
    
    return self;
}

- (NSURL *)avatarImageURL {
    return [NSURL URLWithString:self.avatarImageURLString];
}

//#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
//
//@synthesize profileImage = _profileImage;
//
//+ (NSOperationQueue *)sharedProfileImageRequestOperationQueue {
//    static NSOperationQueue *_sharedProfileImageRequestOperationQueue = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedProfileImageRequestOperationQueue = [[NSOperationQueue alloc] init];
//        [_sharedProfileImageRequestOperationQueue setMaxConcurrentOperationCount:8];
//    });
//
//    return _sharedProfileImageRequestOperationQueue;
//}
//
//- (NSImage *)profileImage {
//	if (!_profileImage && !_avatarImageRequestOperation) {
//		_avatarImageRequestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:self.avatarImageURL] success:^(NSImage *image) {
//			self.profileImage = image;
//
//			_avatarImageRequestOperation = nil;
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:kUserProfileImageDidLoadNotification object:self userInfo:nil];
//		}];
//
//		[_avatarImageRequestOperation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
//			return [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:cachedResponse.userInfo storagePolicy:NSURLCacheStorageAllowed];
//		}];
//
//        [[[self class] sharedProfileImageRequestOperationQueue] addOperation:_avatarImageRequestOperation];
//	}
//
//	return _profileImage;
//}
//
//#endif

@end
