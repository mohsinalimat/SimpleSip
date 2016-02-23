//
//  NetworkActivityIndicatorManager.m
//  Bragi
//
//  Created by Yvonne on 2/23/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#import "NetworkActivityIndicatorManager.h"

@implementation NetworkActivityIndicatorManager
+ (NetworkActivityIndicatorManager *)sharedManager {
    
    static NetworkActivityIndicatorManager *sharedInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)startActivity {
    
    @synchronized(self)
    {
        if (self.application.isStatusBarHidden) {
            return;
        }
        
        if (!self.application.isNetworkActivityIndicatorVisible) {
            self.application.networkActivityIndicatorVisible = YES;
            self.tasks = 0;
        }
        
        self.tasks++;
    }
}

- (void)endActivity {
    
    @synchronized(self)
    {
        if (self.application.isStatusBarHidden) {
            return;
        }
        
        self.tasks--;
        
        if (self.tasks <= 0) {
            self.application.networkActivityIndicatorVisible = NO;
            self.tasks = 0;
        }
    }
}

- (void)allActivitiesComplete {
    
    @synchronized(self)
    {
        if (self.application.isStatusBarHidden) {
            return;
        }
        
        self.application.networkActivityIndicatorVisible = NO;
        self.tasks = 0;
    }
}

-(UIApplication *)application {
    
    if (!_application) {
        _application = [UIApplication sharedApplication];
    }
    
    return _application;
}

- (NetworkActivityIndicatorManager *)init {
    
    self = [super init];
    
    self.tasks = 0;
    
    return self;
}
@end
