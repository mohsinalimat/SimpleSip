//
//  NetworkActivityIndicatorManager.h
//  Bragi
//
//  Created by Yvonne on 2/23/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#ifndef Bragi_NetworkActivityIndicatorManager_h
#define Bragi_NetworkActivityIndicatorManager_h


#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NetworkActivityIndicatorManager : NSObject

@property (nonatomic) NSInteger tasks;
@property (strong, nonatomic) UIApplication *application;

// Get class singleton
+ (NetworkActivityIndicatorManager *)sharedManager;

// Show network activity indicator
// Each call adds an activity to the internal queue
- (void)startActivity;

// Hide network activity indicator
// Will not hide the indicator until all activities are complete
- (void)endActivity;

// Hide the network activity indicator
// This will hide the indicator regardless of how many activities have been started
- (void)allActivitiesComplete;
@end
