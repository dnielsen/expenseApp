//
//  Base64.h
//  Concur Sample
//
//  Created by charlottef on 10/23/12.
//  Copyright (c) 2012 Concur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject
+(NSString *)encode:(NSData *)plainText;
@end
