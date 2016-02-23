//
//  DataHolder.m
//  Bragi
//
//  Created by Yvonne on 2/23/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataHolder.h"

@implementation DataHolder
@synthesize deviceID = _deviceID;

static DataHolder *sharedDataHolder;
+ (DataHolder *)sharedDataHolder
{
    if (sharedDataHolder == nil)
    {
        sharedDataHolder = [[DataHolder alloc] init];
    }
    return sharedDataHolder;
}

-(id)init{
   if((self = [super init])){
       self.deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

        NSLog(@"selfDeviceID:%@",self.deviceID);

    }
    return self;
}
@end