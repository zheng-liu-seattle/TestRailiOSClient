//
//  TestRrailUtility.h
//  TestRailClient
//
//  Created by Liu, Zheng on 10/7/14.
//  Copyright (c) 2014 Liu, Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestRailUtility : NSObject

/**
 Utility method to send http get request
 */
+ (NSString *)getHttpRequest:(NSString *)path;
/**
 Utility method to send http post request
 */
+ (NSString *)postHttpRequest:(NSDictionary *)data setPath:(NSString *)path;
/**
 Utility method to encode string to base64
 */
+ (NSString *)base64Encode:(NSData *)plainText;

@end
