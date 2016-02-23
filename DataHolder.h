//
//  DataHolder.h
//  Bragi
//
//  Created by Yvonne on 2/23/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#ifndef Bragi_DataHolder_h
#define Bragi_DataHolder_h


#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DataHolder : NSObject

@property (nonatomic,retain) NSString *deviceID;


typedef enum {
    Success = 200,
    DefaultImage = 304,
    SameContent = 302,
    Error_ArgumentNull= 40001,
    Error_UnknownServerNumber = 40002,
    Error_IncorrectDeviceKey = 40102,
    Error_IncorrectAPIKey = 40301,
    Error_DuplicatedAccount = 40901,
    Error_AccountNotFound = 40902,
    Error_AlreadyValidated = 40903,
    Error_IncorrectAuthCode = 40904,
    Error_NotValidated = 40905,
    Error_NotMvpn = 40906,
    Error_HistoryRecordNotFound = 40907,// The results were not found in the cache.
    Error_InvalidIndex = 40908,
    Error_UserNotMvpn = 40909,
    Error_InsufficientCredit = 40913,
    Error_InternalError = 500, // Internal server error. No information available.
    Error_SipServerError = 50001,
    Error_Connection = 600,//error when request connection
    Error_RequestTimeOut = -1001,
    Error_FailingURLKey = -1003,
    Error_CantConnectServer = -1004,
    Error_NoNetwork = -1009,
    Error_Domain = -1012,
    
} StatusCode;

+ (DataHolder *)sharedDataHolder;

@end