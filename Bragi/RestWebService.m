//
//  RestWebService.h
//  Bragi
//
//  Created by Yvonne on 1/20/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#import "RestWebService.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "NetworkActivityIndicatorManager.h"
#import "DataHolder.h"
@implementation RestWebService

static RestWebService *defaultRestAgent;
NSString *const APIKey = @"93f5cf71940e939bc50992e53e8fb0cb4eba6877f9fa7a33c3dfa2c93e8618b1583169eac8d0671354e0fb36bd4184b5c2d7c365035be0cc6ffd75d6b21b3054";

+(RestWebService *)defaultRestWebService{
    if ( !defaultRestAgent ){
        defaultRestAgent = [[RestWebService alloc]init];
    }

    return defaultRestAgent;
}

+(void)checkAuthWithCompletionHandler:(myCompletionBlock)completionBlock{
    NSString *cryKey = [self createSHA512:[self md5:[self getIPAddress]]];
    NSString *authKey = [APIKey stringByAppendingString:cryKey];
    
    NSLog(@"authKey:%@",authKey);
    
    NSError *error = nil;
    NSMutableURLRequest *muRequest = [self initRequest:@"http://192.168.1.1:3676/login" andMethod:@"POST"];
    
    //http://<gateway:appPort>/login
    NSDictionary *mapData = [NSDictionary dictionaryWithObjectsAndKeys:authKey,@"AUTH:",nil];

    NSLog(@"mapdData of login %@",mapData);
    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    muRequest.HTTPBody = requestBodyData;
   // NSURLResponse * response = nil;
    
    [[NetworkActivityIndicatorManager sharedManager]startActivity];
    
    [NSURLConnection sendAsynchronousRequest:muRequest queue:[AppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [[NetworkActivityIndicatorManager sharedManager] endActivity];
         // Check to make sure there are no errors
         if (error) {
             NSLog(@"Error in uploadHistory: %@ %@", error, [error localizedDescription]);
             completionBlock(NO, nil, error);
         } else if (!response) {
             completionBlock(NO, nil, error);
         } else if (!data) {
             completionBlock(NO, nil, error);
         } else {
             
             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             NSLog(@"uploadHistory return%@",dictrc);
             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
             completionBlock(YES, dictrc, nil);
         }
     }];

}

+(NSDictionary* )getSIPInfo{
    DataHolder *holder = [DataHolder sharedDataHolder];
    NSString* urlString = [NSString stringWithFormat:@"http://192.168.1.1:3676/voip/account?%@",holder.deviceID];
    NSError *error = nil;
    NSLog(@"getMapped url %@",urlString);
    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"GET"];
    NSURLResponse * response = nil;
    [[NetworkActivityIndicatorManager sharedManager] startActivity];
    NSData *data = [NSURLConnection sendSynchronousRequest:muRequest returningResponse:&response error:&error];
    [[NetworkActivityIndicatorManager sharedManager] endActivity];
    NSLog(@"response by getUUID");
    if(error){
        NSLog(@"error in getUUID %@",error);
        NSDictionary* errorDict = [RestWebService errorDiscriptor:error];
        return errorDict;
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}
+(NSDictionary* )getContacts{
    NSString* urlString = [NSString stringWithFormat:@"http://192.168.1.1:3676/voip/contact"];
    NSError *error = nil;
    NSLog(@"getMapped url %@",urlString);
    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"GET"];
    NSURLResponse * response = nil;
    [[NetworkActivityIndicatorManager sharedManager] startActivity];
    NSData *data = [NSURLConnection sendSynchronousRequest:muRequest returningResponse:&response error:&error];
    [[NetworkActivityIndicatorManager sharedManager] endActivity];
    NSLog(@"response by getUUID");
    if(error){
        NSLog(@"error in getUUID %@",error);
        NSDictionary* errorDict = [RestWebService errorDiscriptor:error];
        return errorDict;
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

}
+(NSDictionary *)errorDiscriptor:(NSError *)error{
    NSDictionary *errorDict =[[NSDictionary alloc]init];
    NSLog(@"code: %ld",[error code]);
    if( [[error domain] isEqualToString:NSURLErrorDomain] ) {
        switch([error code]) {
            case -1001:
                errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"-1001",@"status",[error localizedFailureReason],@"description", nil];
                // handle POSIX I/O error
                break;
            case -1003:
                errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"-1003",@"status",[error localizedFailureReason],@"description", nil];
                break;
            case -1009:
                errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"-1009",@"status",[error localizedFailureReason],@"description", nil];
                break;
            default:
                errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"-1012",@"status",[error localizedFailureReason],@"description", nil];
                
        }
    }
    return errorDict;
}
+(NSMutableURLRequest *)initRequest:(NSString *)url andMethod:(NSString *)method{
    // NSMutableURLRequest *muRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]  cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10.0];
    NSMutableURLRequest *muRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:12.0];
    
    //muRequest.HTTPMethod = method;
    [muRequest setHTTPMethod:method];
    [muRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [muRequest setValue:APIKey forHTTPHeaderField:@"apiKey"];
    [muRequest setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    
    return muRequest;
}

+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)createSHA512:(NSString *)string
{
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
  //  CC_SHA512(data.bytes, data.length, digest);
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                NSArray *items = [address componentsSeparatedByString:@"."];   //take the one array for split the string
                if(![address isEqualToString:@"127.0.0.1"])
                    address = address;
                NSLog(@"adr:%@",address);
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    NSLog(@"address...:%@",address);
    return address;
}
@end