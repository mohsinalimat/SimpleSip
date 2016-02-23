//
//  RestWebService.h
//  Bragi
//
//  Created by Yvonne on 1/20/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//


#import <Foundation/Foundation.h>
//
//typedef void (^myCompletionBlock)(BOOL success, NSDictionary *string, NSError *error);
//
@interface RestWebService : NSObject
typedef void (^myCompletionBlock)(BOOL success, NSDictionary *string, NSError *error);

+(void)getContacts;//Bragi
+(void)checkAuthWithCompletionHandler:(myCompletionBlock)completionBlock;//Bragi
+(NSDictionary* )getSIPInfo;//Bragi
-(NSString*)getIPAddress;//Bragi

//@property(nonatomic,retain) NSString* number;
//@property(nonatomic,retain) NSString* token;
//
//+(RestWebService *)defaultRestWebService;
//+ (void)registerMVPN:(NSString*)number andCompletionHandler:(myCompletionBlock)completionBlock;
//+ (NSDictionary *)registerMVPN:(NSString*)number;
//+ (void)switchingNewDevice:(NSString*)number andCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)registerPushMessageWithCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)resendCode:(NSString*)number andCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)validateCode:(NSString *)code withNumber:(NSString *)number andCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)loginMVPNServiceWithCompletionHandler:(myCompletionBlock)completionBlock;
//+(NSDictionary *)loginMVPNService;
//+(void)setLoginArgWithDict:(NSDictionary *)dictr;
//+(void)getMappedListWithCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)setMappedListWithDict:(NSMutableDictionary *)editObj andCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)delMappingListWithServerNumber:(NSString *)delNum andCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)checkFreeListForCoreDataWithArray:(NSMutableArray *)numberArray CompletionHandler:(myCompletionBlock)completionBlock;
//+(void)checkFreeListWithTimeStampAndCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)lunchCallToPhone:(NSString *)phoneNum WithCompletionHandler:(myCompletionBlock)completionBlock;
//+(NSDictionary *)getUUIDList;
//+(void)getContactsByUUID:(NSString *)UUID WithCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)getSIPAccWhenForeignWithCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)deleteSIPAccWithCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)getHistoryWithCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)clearHistoryWithCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)delHistory:(NSDictionary *)history WithCompletionHandler:(myCompletionBlock)completionBlock;
//+(void)delSIPArg;
@end
