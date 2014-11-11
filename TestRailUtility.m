//
//  TestRrailUtility.m
//  TestRailClient
//
//  Created by Liu, Zheng on 10/7/14.
//  Copyright (c) 2014 Liu, Zheng. All rights reserved.
//

#import "TestRailUtility.h"
#import "TestRailClient.h"

static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

//work around: since our testrail server's SSL cerificate is self signed, need to add this dummy interface to call private API to allow it.
@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

@implementation TestRailUtility

+ (NSString *)getHttpRequest:(NSString *)path {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    NSString *targetURL = [[TestRailClient sharedInstance] getUrl:path];
    [request setURL:[NSURL URLWithString:targetURL]];
    //allow invalid ssl connection, see above comment
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[[NSURL URLWithString:targetURL] host]];
    //set headers
    NSData *authData = [[[TestRailClient sharedInstance] getAuthString] dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [self base64Encode:authData]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    //send request
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&responseCode
                                                              error:&error];
    NSString *response = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    if([responseCode statusCode] != 200) {
        NSLog(@"Error getting %@, HTTP status code %li response: %@ error code: %ld", targetURL, (long)[responseCode statusCode], response, (long)[error code]);
        return nil;
    }
    return response;
}

+ (NSString *)postHttpRequest:(NSDictionary *)data setPath:(NSString *)path {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    NSString *targetURL = [[TestRailClient sharedInstance] getUrl:path];
    [request setURL:[NSURL URLWithString:targetURL]];
    //set headers
    NSData *authData = [[[TestRailClient sharedInstance] getAuthString] dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [self base64Encode:authData]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    //allow invalid ssl connection, see above comment
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[[NSURL URLWithString:targetURL] host]];
    //build the body
    NSError *error = nil;
    NSData *json = nil;
    NSString *jsonString = nil;
    //Dictionary convertable to JSON ?
    if ([NSJSONSerialization isValidJSONObject:data])
    {
        //Serialize the dictionary
        json = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
        //If no errors, let's view the JSON
        if (json != nil && error == nil)
        {
            jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        }
    }
    NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    //send request
    NSHTTPURLResponse *responseCode = nil;
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&responseCode
                                                              error:&error];
    NSString *response = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    if([responseCode statusCode] != 200) {
        NSLog(@"Error getting %@, HTTP status code %li response: %@ error code: %ld desc:%@", targetURL, (long)[responseCode statusCode], response, (long)[error code], [error description]);
        return nil;
    }
    return response;
}

+ (NSString *)base64Encode:(NSData *)plainText {
    NSInteger encodedLength = (4 * (([plainText length] / 3) + (1 - (3 - ([plainText length] % 3)) / 3))) + 1;
    unsigned char *outputBuffer = malloc(encodedLength);
    unsigned char *inputBuffer = (unsigned char *)[plainText bytes];
    NSInteger i;
    NSInteger j = 0;
    NSInteger remain;
    for(i = 0; i < [plainText length]; i += 3) {
        remain = [plainText length] - i;
        outputBuffer[j++] = alphabet[(inputBuffer[i] & 0xFC) >> 2];
        outputBuffer[j++] = alphabet[((inputBuffer[i] & 0x03) << 4) |
                                     ((remain > 1) ? ((inputBuffer[i + 1] & 0xF0) >> 4): 0)];
        
        if(remain > 1)
            outputBuffer[j++] = alphabet[((inputBuffer[i + 1] & 0x0F) << 2)
                                         | ((remain > 2) ? ((inputBuffer[i + 2] & 0xC0) >> 6) : 0)];
        else
            outputBuffer[j++] = '=';
        if(remain > 2)
            outputBuffer[j++] = alphabet[inputBuffer[i + 2] & 0x3F];
        else
            outputBuffer[j++] = '=';
    }
    outputBuffer[j] = 0;
    NSString *result = [NSString stringWithCString:(char *)outputBuffer encoding:NSUTF8StringEncoding];
    free(outputBuffer);
    return result;
}

@end
