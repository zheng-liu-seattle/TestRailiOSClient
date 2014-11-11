//
//  TestRailClient.m
//  TestRailClient
//
//  Created by Liu, Zheng on 10/7/14.
//  Copyright (c) 2014 Liu, Zheng. All rights reserved.
//

#import "TestRailClient.h"

@implementation TestRailClient

@synthesize username = _username,
            host = _host,
            password = _password,
            currentTestRunId = _currentTestRunId;

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)getAuthString {
    return [NSString stringWithFormat:@"%@:%@", self.username, self.password];
}

- (NSString *)getUrl:(NSString *)path {
    return [NSString stringWithFormat:@"%@/api.php?/api/v2/%@", self.host, path];
}

- (NSString *)addTestRun:(NSString *)name setSuiteId:(NSNumber *)suiteId setProjectId:(NSString *)projectId setData:(NSDictionary *)data {
    NSMutableDictionary *postData = [NSMutableDictionary dictionaryWithDictionary:data];
    [postData setObject:name forKey:@"name"];
    [postData setObject:suiteId forKey:@"suite_id"];
    NSString *response = [TestRailUtility postHttpRequest:postData setPath:[NSString stringWithFormat:@"add_run/%@/", projectId]];
    //get run id
    NSError *error = nil;
    NSDictionary *reponseData = [NSJSONSerialization JSONObjectWithData: [response dataUsingEncoding:NSUTF8StringEncoding]
                                                                options: NSJSONReadingMutableContainers
                                                                  error: &error];
    if(error == nil) {
        NSString *testRunId = [reponseData objectForKey:@"id"];
        NSLog(@"test run created id: %@", testRunId);
        return testRunId;
    }
    return nil;
}

- (BOOL)updateTestCaseResult:(NSString *)testCaseId setTestRunId:(NSString *)testRunId setStatusId:(NSNumber *)statusId setData:(NSDictionary *)data {
    NSMutableDictionary *postData = [NSMutableDictionary dictionaryWithDictionary:data];
    [postData setObject:statusId forKey:@"status_id"];
    NSString *response = [TestRailUtility postHttpRequest:postData setPath:[NSString stringWithFormat:@"add_result_for_case/%@/%@/", testRunId, testCaseId]];
    NSError *error = nil;
    [NSJSONSerialization JSONObjectWithData: [response dataUsingEncoding:NSUTF8StringEncoding]
                                                                options: NSJSONReadingMutableContainers
                                                                  error: &error];
    if(error != nil) {
        NSLog(@"Updated test case %@ for test run %@ result %@", testCaseId, testCaseId, statusId);
        return YES;
    }
    return NO;
}

@end
