//
//  ContactViewController.m
//  Bragi
//
//  Created by Yvonne on 2/21/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactViewController.h"
#import "RestWebService.h"
#import "NetworkActivityIndicatorManager.h"
@implementation ContactViewController

- init{
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Contacts",nil)
                                                    image:[UIImage imageNamed:@"ampImg.png"]
                                                      tag:1];
    self.navigationItem.title = NSLocalizedString(@"Contact",nil);

    return self;
}

-(void)viewDidLoad{
    NSLog(@"view");
    [self getContact];
}

-(void)getContact{
    [[NetworkActivityIndicatorManager sharedManager] startActivity];
    
    NSDictionary *dictr = [RestWebService getContacts];
    NSLog(@"result:%@",dictr);

}

@end