//
//  TestRailClient.h
//  TestRailClient
//
//  Created by Liu, Zheng on 10/7/14.
//  Copyright (c) 2014 Liu, Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestRailUtility.h"

#define TEST_RESULT_PASSED 1
#define TEST_RESULT_BLOCKED 2
#define TEST_RESULT_UNTESTED 3
#define TEST_RESULT_RETEST 4
#define TEST_RESULT_FAILED 5

@interface TestRailClient : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *currentTestRunId;

+ (instancetype)sharedInstance;

/**
 * get testrail user account info, <username>:<password>
 */
- (NSString *)getAuthString;
/**
 * return the RESTFul API url
 */
- (NSString *)getUrl:(NSString *)path;
/**
 * Add test run
 * @name: The name of the test run
 * @suiteId: The ID of the test suite
 * @data, a NSDictionary object contains test run needed data: http://docs.gurock.com/testrail-api2/reference-runs#add_run
 * @projectId: The ID of the project the test run should be added to
 */
- (NSString *)addTestRun:(NSString *)name setSuiteId:(NSString *)suiteId setProjectId:(NSString *)projectId setData:(NSDictionary *)data;
/*
 * Update test case result for specifed test run
 * @testCaseId: the test case id
 * @testRunId: the test run ud
 * @statusId: the status of the current test case
 * @data: a NSDictionary object contains 
 */
- (BOOL)updateTestCaseResult:(NSString *)testCaseId setTestRunId:(NSString *)testRunId setStatusId:(NSNumber *)statusId setData:(NSDictionary *)data;

@end
