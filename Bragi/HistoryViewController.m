//
//  HistoryViewController.m
//  Bragi
//
//  Created by Yvonne on 2/21/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryViewController.h"

@interface HistoryViewController()

@end

@implementation HistoryViewController
-init{
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"History",nil)
                                                    image:[UIImage imageNamed:@"muteImg"]
                                                      tag:0];
    self.navigationItem.title = NSLocalizedString(@"History",nil);
    
    return self;

}
@end