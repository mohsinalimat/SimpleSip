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

+(void)getContacts{
   }
+(void)updatePrivacy:(BOOL)isPrivate ofGroup:(NSString *)groupUUID withCompletionHandler:(myCompletionBlock)completionBlock{
}
+(void)checkAuthWithCompletionHandler:(myCompletionBlock)completionBlock{
    NSString *cryKey = [self createSHA512:[self md5:[self getIPAddress]]];
    NSString *authKey = [APIKey stringByAppendingString:cryKey];
    
    NSLog(@"authKey:%@",authKey);
    
    NSError *error = nil;
    NSMutableURLRequest *muRequest = [self initRequest:@"http://ip/login" andMethod:@"POST"];
    
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
    NSString* urlString = [NSString stringWithFormat:@"http://ip/voip/account?%@",holder.deviceID];
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
        NSLog(@"success1!!!!!");
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            NSLog(@"success2!!!!!");

            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                NSLog(@"success3!!!!!");

                // Check if interface is en0 which is the wifi connection on the iPhone
                NSLog(@"what?%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
//                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en1"])
//                {
//                    // Get NSString from C String
//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                    NSLog(@"adr:%@",address);
//                }
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
//
//#import "RestWebService.h"
//#import "AppDelegate.h"
////#import "KITsDataHolder.h"
//
//
//@implementation RestWebService
//
//@synthesize number = _number;
//@synthesize token = _token;
//
//static RestWebService *defaultRestAgent;
//
//NSString *const APIKey = @"B335B1D479D566EF1ED1DE08A19F41B1D68E9C8E6DB4E6AD5CE7D86D90C108B4";
//
//+(RestWebService *)defaultRestWebService{
//    if ( !defaultRestAgent ){
//        defaultRestAgent = [[RestWebService alloc]init];
//    }
//    
//    return defaultRestAgent;
//}
//-(id) init{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
////    
////    self.number = [defaults objectForKey:@"userNumber"];
////    if ( holder.token ) self.token = holder.token;//new token after everytime login
////    else NSLog(@"Error ------- No Token");
//    
//    return self;
//}
//+(NSMutableURLRequest *)initRequest:(NSString *)url andMethod:(NSString *)method{
//   // NSMutableURLRequest *muRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]  cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10.0];
//    NSMutableURLRequest *muRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15.0];
//    
//    //muRequest.HTTPMethod = method;
//    [muRequest setHTTPMethod:method];
//    [muRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [muRequest setValue:APIKey forHTTPHeaderField:@"apiKey"];
//    [muRequest setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
//    
//    return muRequest;
//}
//+ (void)registerMVPN:(NSString*)number andCompletionHandler:(myCompletionBlock)completionBlock{//Asynchronous
//    NSError *error = nil;
//    
//    NSMutableURLRequest *muRequest = [self initRequest:@"https://ts.kits.tw/projectLYS/v0/Account/" andMethod:@"POST"];
//    
//    NSDictionary *mapData = [NSDictionary dictionaryWithObjectsAndKeys:
//                             number,@"account", nil];
//    NSLog(@"mapdData %@",mapData);
//    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    muRequest.HTTPBody = requestBodyData;
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[AppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in registerMVPN: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"registerMVPN return");
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}/*
//+ (NSDictionary *)registerMVPN:(NSString*)number{//Synchronous
//    NSError *error = nil;
//    
//    NSMutableURLRequest *muRequest = [self initRequest:@"https://ts.kits.tw/projectLYS/v0/Account/" andMethod:@"POST"];
//    
//    NSDictionary *mapData = [NSDictionary dictionaryWithObjectsAndKeys:
//                             number,@"account", nil];
//    NSLog(@"mapdData %@",mapData);
//    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    muRequest.HTTPBody = requestBodyData;
//    NSURLResponse * response = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:muRequest returningResponse:&response error:&error];
//    NSLog(@"in register %@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]);
//    if(error)
//        NSLog(@"error in registerMVPN %@",error);
//    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//}*/
//+ (void)switchingNewDevice:(NSString*)number andCompletionHandler:(myCompletionBlock)completionBlock{//resend Code also use it
//    NSError *error = nil;
//    NSMutableURLRequest *muRequest = [self initRequest:@"https://ts.kits.tw/projectLYS/v0/Account/authentication" andMethod:@"POST"];
//    
//    NSDictionary *mapData = [NSDictionary dictionaryWithObjectsAndKeys:number,@"account",@"SMS",@"mediaType", nil];
//    NSLog(@"mapdData %@",mapData);
//    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    muRequest.HTTPBody = requestBodyData;
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in switchingNewDevice: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"switchingNewDevice return");
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(void)resendCode:(NSString*)number andCompletionHandler:(myCompletionBlock)completionBlock{
//    [self switchingNewDevice:number andCompletionHandler:completionBlock];
//}
//+(void)validateCode:(NSString *)code withNumber:(NSString *)number andCompletionHandler:(myCompletionBlock)completionBlock{
//    NSString* UUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSError *error = nil;
//    NSDictionary *mapData = [NSDictionary dictionaryWithObjectsAndKeys:number,@"account",code,@"authCode",UUIDStr,@"deviceKey", nil];
//    NSLog(@"validateCode arg %@",mapData);
//    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    //NSString* stringContent = [NSString stringWithFormat:@"{\"_method\"=\"PUT\";\"account\"=\"%@\";\"authCode\"=\"%@\";\"deviceKey\"=\"%@\";}",number,code,UUIDStr];
//   // NSLog(@"stringContent %@",stringContent);
//    //NSData *requestBodyData = [stringContent dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableURLRequest *muRequest = [self initRequest:@"https://ts.kits.tw/projectLYS/v0/Account/authentication" andMethod:@"PUT"];
//    muRequest.HTTPBody = requestBodyData;
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in validateCode: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             //NSLog(@"%@",data);
//             //NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//             //NSLog(@"string %@",myString);
//             NSLog(@"validateCode return");
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//
//}
//+(void)loginMVPNServiceWithCompletionHandler:(myCompletionBlock)completionBlock{//unused
//    //identifierForVendor: Identifying the Device and Operating System
////    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString* UUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSError *error = nil;
//    NSMutableURLRequest *muRequest = [self initRequest:@"https://ts.kits.tw/projectLYS/v0/Account/accessToken" andMethod:@"POST"];
//    
//    NSDictionary *mapData = [NSDictionary dictionaryWithObjectsAndKeys:
//        holder.userNumber,@"account",UUIDStr,@"deviceKey", nil];
//    NSLog(@"loginMVPNService arg %@",mapData);
//    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    muRequest.HTTPBody = requestBodyData;
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in loginMVPNService: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             //NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//             //NSLog(@"reason string %@",myString);
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             //NSLog(@"loginMVPN return is: %@",dictrc);
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(NSDictionary *)loginMVPNService{
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString* UUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    
//    NSError *error = nil;
//    
//    NSMutableURLRequest *muRequest = [self initRequest:@"https://ts.kits.tw/projectLYS/v0/Account/accessToken" andMethod:@"POST"];
//    
//    NSDictionary *mapData = [NSDictionary dictionaryWithObjectsAndKeys:
//                             holder.userNumber,@"account",UUIDStr,@"deviceKey", nil];
//    NSLog(@"mapdData of login %@",mapData);
//    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    muRequest.HTTPBody = requestBodyData;
//    NSURLResponse * response = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:muRequest returningResponse:&response error:&error];
//    NSLog(@"response by login webservice");
//    NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"reason %@",myString);
//    if(error){
//        NSLog(@"error in login %@",error);
//        NSDictionary *errorDict;
//        if ( [[error domain] isEqualToString:NSURLErrorDomain] ) {
//            switch([error code]) {
//                case -1001:
//                    errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 @"-1001",@"status",[error localizedFailureReason],@"description", nil];
//                    // handle POSIX I/O error
//                    break;
//                case -1003:
//                    errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 @"-1003",@"status",[error localizedFailureReason],@"description", nil];
//                    break;
//                case -1012:
//                    errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 @"-1012",@"status",[error localizedFailureReason],@"description", nil];
//                    break;
//            }
//            if(!data)
//                return errorDict;
//        }
//    }
//    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//}
//+(void)registerPushMessageWithCompletionHandler:(myCompletionBlock)completionBlock{
//    
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString* registrationID = [NSString stringWithFormat:@"apple_%@",holder.APNToken];
//    NSError *error = nil;
//    
//    NSMutableURLRequest *muRequest = [self initRequest:[NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/Account/%@/pushID",holder.token] andMethod:@"PUT"];
//    NSDictionary *mapData = [NSDictionary dictionaryWithObjectsAndKeys:
//                             registrationID,@"pushID",nil];
//    NSLog(@"registerPush arg %@",mapData);
//    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    muRequest.HTTPBody = requestBodyData;
//
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in registerPush");
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"registerPush return");
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(void)setLoginArgWithDict:(NSMutableDictionary *)dictr{
//    NSLog(@"%@",dictr);
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    holder.token = [NSString stringWithString:[dictr objectForKey:@"token"]];
//    holder.userDidLogin  = YES;
//    [self delSIPArg];
//    [self setSIPArg:dictr];
//    if([dictr objectForKey:@"sipAccount"]){
//        holder.MVPN = NO;
//    }else{
//        holder.MVPN = YES;
//    }
//    [defaults setObject:holder.token forKey:@"token"];
//    [defaults synchronize];//store into disk
//}
//+(void)delSIPArg{//reset all the arg relatetd to sip
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    if(holder.sipAcc){
//        holder.sipAcc = NULL;
//        holder.sipPass = NULL;
//        holder.sipServerIP = NULL;
//        [defaults removeObjectForKey:@"sipAcc"];
//        [defaults removeObjectForKey:@"sipPass"];
//        [defaults removeObjectForKey:@"sipServerIP"];
//        holder.pjHasInput = NO;
//        [defaults synchronize];
//    }//store into disk
//}
//+(void)setSIPArg:(NSMutableDictionary *)dictr{
//    NSLog(@"%@",dictr);
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString *oldAcc = holder.sipAcc;
//    
//    if ( [dictr objectForKey:@"sipAccount"] != NULL  && ![oldAcc isEqualToString:[dictr objectForKey:@"sipAccount"]]){
//        holder.sipAcc = [dictr objectForKey:@"sipAccount"];
//        holder.sipPass = [dictr objectForKey:@"sipPassword"];
//        holder.sipServerIP = [dictr objectForKey:@"sipServer"];
//        [defaults setObject:holder.sipAcc forKey:@"sipAcc"];
//        [defaults setObject:holder.sipPass forKey:@"sipPass"];
//        [defaults setObject:holder.sipServerIP forKey:@"sipServerIP"];
//        [defaults synchronize];//store into disk
//        
//        //TODO: login SIP account
//        holder.pjHasInput = YES;
//        if(!holder.SIPDidlogin)//don't start again when sip already start
//            [[NSNotificationCenter defaultCenter] postNotificationName:startSIPClient object:nil];
//        
//    }
//}
//+(void)getMappedListWithCompletionHandler:(myCompletionBlock)completionBlock{
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/OfflineNumber/%@",holder.token];
//    NSLog(@"getMapped url %@",urlString);
//    NSError *error = nil;
//    //NSLog(@"getMapped url %@",urlString);
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"GET"];
//    
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in getMappedList: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"getMappedList return");
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(void)setMappedListWithDict:(NSMutableDictionary *)editObj andCompletionHandler:(myCompletionBlock)completionBlock{
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/OfflineNumber/%@",holder.token];
//    NSError *error = nil;
//    NSLog(@"setMapped url %@",urlString);
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"PUT"];
//    NSDictionary *mapData = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [editObj objectForKey:@"mappingNumber"],@"serverNumber",[editObj objectForKey:@"phoneNumber"],@"calleeNumber",[editObj objectForKey:@"fullName"],@"calleeName",nil];
//    NSLog(@"setMapping arg %@",mapData);
//    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    muRequest.HTTPBody = requestBodyData;
//    
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in setMappedList: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//              NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//              NSLog(@"reason string %@",myString);
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"setMappedList return");
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(void)delMappingListWithServerNumber:(NSString *)delNum andCompletionHandler:(myCompletionBlock)completionBlock{
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/OfflineNumber/%@?serverNumber=%@",holder.token,delNum];
//    NSError *error = nil;
//    //NSLog(@"getMapped url %@",urlString);
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"DELETE"];
//    
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in delMappingNum: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"delMappingNum return");
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(void)checkFreeListForCoreDataWithArray:(NSMutableArray *)numberArray CompletionHandler:(myCompletionBlock)completionBlock{
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/Contact/%@/freeNumber",holder.token];
//    NSLog(@"url %@",urlString);
//    NSError *error = nil;
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"PUT"];
//    NSMutableArray *numberArgs = [[NSMutableArray alloc]init];
//    for ( int j = 0 ; j < [numberArray count] ; j ++ ){
//        [numberArgs addObject:[[numberArray objectAtIndex:j] objectForKey:@"phoneNumber"]];
//    }
//    NSDictionary *mapData = [NSDictionary dictionaryWithObjectsAndKeys:
//                             numberArgs,@"numberList", nil];
//    NSLog(@"checkFreeList arg %@",mapData);
//    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    muRequest.HTTPBody = requestBodyData;
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in checkFreeList: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//            // NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            // NSLog(@"reason string %@",myString);
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"checkFreeList return");
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(void)checkFreeListWithTimeStampAndCompletionHandler:(myCompletionBlock)completionBlock{
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/Contact/%@/freeNumber",holder.token];
//    NSLog(@"url %@",urlString);
//    NSError *error = nil;
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"PUT"];
//    
//    if(![defaults objectForKey:@"freeHash"]){
//       [defaults setObject:@"000000" forKey:@"freeHash"];
//       [defaults synchronize];
//    }
//    NSDictionary *mapData = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [defaults objectForKey:@"freeHash"],@"timeStamp", nil];
//    NSLog(@"checkFreeList with time arg %@",mapData);
//    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    muRequest.HTTPBody = requestBodyData;
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in checkFreeList with time: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             // NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//             // NSLog(@"reason string %@",myString);
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"checkFreeList with time return %@",dictrc);
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//
//+(void)lunchCallToPhone:(NSString *)phoneNum WithCompletionHandler:(myCompletionBlock)completionBlock{
//    
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/Call/%@/callRequest",holder.token];
//    NSError *error = nil;
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"POST"];
//    
//    NSDictionary *mapData = [NSDictionary dictionaryWithObjectsAndKeys:
//            phoneNum,@"callee", nil];
//    NSLog(@"lunchCallToPhone arg %@",mapData);
//    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    muRequest.HTTPBody = requestBodyData;
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in lunchCallToPhone: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//            
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"lunchCallToPhone return is: %@",dictrc);
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(NSDictionary *)getUUIDList{
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/Contact/%@",holder.token];
//    NSError *error = nil;
//    //NSLog(@"getMapped url %@",urlString);
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"GET"];
//    NSURLResponse * response = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:muRequest returningResponse:&response error:&error];
//    NSLog(@"response by getUUID");
//    if(error){
//        NSLog(@"error in getUUID %@",error);
//        NSDictionary *errorDict;
//        if ( [[error domain] isEqualToString:NSURLErrorDomain] ) {
//            switch([error code]) {
//                case -1001:
//                    errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 @"-1001",@"status",[error localizedFailureReason],@"description", nil];
//                    // handle POSIX I/O error
//                    break;
//                case -1003:
//                    errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 @"-1003",@"status",[error localizedFailureReason],@"description", nil];
//                    break;
//            }
//            return errorDict;
//        }
//    }
//    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//}
//+(void)getContactsByUUID:(NSString *)UUID WithCompletionHandler:(myCompletionBlock)completionBlock{
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/Contact/%@/%@",holder.token,UUID];
//    NSError *error = nil;
//    //NSLog(@"getMapped url %@",urlString);
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"GET"];
//    
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in getUUIDList: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//             NSLog(@"reason %@",myString);
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"getUUIDList return");
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(void)getSIPAccWhenForeignWithCompletionHandler:(myCompletionBlock)completionBlock{
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/Account/%@/sipAccount",holder.token];
//    NSError *error = nil;
//    //NSLog(@"getMapped url %@",urlString);
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"GET"];
//    
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in getSIPAcc: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"getSIPAcc return");
//             [self setSIPArg:dictrc];
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(void)deleteSIPAccWithCompletionHandler:(myCompletionBlock)completionBlock{
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/Account/%@/sipAccount",holder.token];
//    NSError *error = nil;
//    //NSLog(@"getMapped url %@",urlString);
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"DELETE"];
//    
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in deleteSIPAcc: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"deleteSIPAcc return");
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(void)getHistoryWithCompletionHandler:(myCompletionBlock)completionBlock{
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/History/%@?timeStamp=%@",holder.token,[defaults objectForKey:@"historyHash"]];
//    NSLog(@"old hash %@",[defaults objectForKey:@"historyHash"]);
//    NSError *error = nil;
//    //NSLog(@"getMapped url %@",urlString);
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"GET"];
//    
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in getHistory");
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//             NSLog(@"reason %@",myString);
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"getHistory return");
//             
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(void)clearHistoryWithCompletionHandler:(myCompletionBlock)completionBlock{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/History/%@?hisUUID=all",holder.token];
//    NSError *error = nil;
//    //NSLog(@"getMapped url %@",urlString);
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"DELETE"];
//    
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in clearHistory: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"clearHistory return");
//             
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//+(void)delHistory:(NSDictionary *)history WithCompletionHandler:(myCompletionBlock)completionBlock{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    KITsDataHolder *holder = [KITsDataHolder defaultHolder];
//    
//    NSString* urlString = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/History/%@?hisUUID=%@",holder.token,[history objectForKey:@"uuid"]];
//    NSError *error = nil;
//    //NSLog(@"getMapped url %@",urlString);
//    NSMutableURLRequest *muRequest = [self initRequest:urlString andMethod:@"DELETE"];
//    
//    [NSURLConnection sendAsynchronousRequest:muRequest  queue:[KITsAppDelegate connectionQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         // Check to make sure there are no errors
//         if (error) {
//             NSLog(@"Error in delHistory: %@ %@", error, [error localizedDescription]);
//             completionBlock(NO, nil, error);
//         } else if (!response) {
//             completionBlock(NO, nil, error);
//         } else if (!data) {
//             completionBlock(NO, nil, error);
//         } else {
//             NSDictionary *dictrc = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//             NSLog(@"delHistory return");
//             
//             //NSLog(@"%@",[dictrc objectForKey:@"status"]);
//             completionBlock(YES, dictrc, nil);
//         }
//     }];
//}
//@end
