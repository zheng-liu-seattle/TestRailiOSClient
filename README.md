TestRailiOSClient
=================

It is a test rail iOS client

Currently it is for TestRail Server 3.0 or above.

Example:

[TestRailClient sharedInstance].username = TESTRAIL_USER_NAME;
[TestRailClient sharedInstance].password = TESTRAIL_PASSWORD;
[TestRailClient sharedInstance].host = TESTRAIL_SERVER_HOST;

NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:NO], @"include_all",
                                    testCaseIds, @"case_ids",
                                    nil];
[TestRailClient sharedInstance].currentTestRunId = [[TestRailClient sharedInstance] addTestRun:testRunName
                                                                                            setSuiteId:TESTRAIL_SUITE_ID
                                                                                          setProjectId:TESTRAIL_PR
