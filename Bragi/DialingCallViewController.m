//
//  DialingCallViewController.m
//  Bragi
//
//  Created by Yvonne on 1/22/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DialingCallViewController.h"
#import <pjsua-lib/pjsua.h>
#import "MainViewController.h"
@interface DialingCallViewController(){
    pjsua_call_id _call_id;
}

@end

@implementation DialingCallViewController

@synthesize mutebut;
@synthesize dialpadbut;
@synthesize amplbut;
@synthesize hangupbut;
@synthesize callId;
@synthesize phoneNumber;

MainViewController *mainviewcontroller;
-(void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[UIView alloc]init];
    self.view.backgroundColor = [UIColor blackColor];
    //mutebutton
    mutebut = [UIButton buttonWithType:UIButtonTypeCustom];
    mutebut.backgroundColor = [UIColor clearColor];
    UIImage *muteImg = [UIImage imageNamed:@"muteImg.png"];
    [mutebut setImage:muteImg forState:UIControlStateNormal];
    mutebut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*0.1, [UIScreen mainScreen].bounds.size.height/2-100, 64, 64);

    //dialpadbutton
    dialpadbut = [UIButton buttonWithType:UIButtonTypeCustom];
    dialpadbut.backgroundColor = [UIColor clearColor];
    UIImage *dialpadImg = [UIImage imageNamed:@"dialpadImg.png"];
    [dialpadbut setImage:dialpadImg forState:UIControlStateNormal];
    dialpadbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-32, [UIScreen mainScreen].bounds.size.height/2-100, 64, 64);
    //amplbutton
    amplbut = [UIButton buttonWithType:UIButtonTypeCustom];
    amplbut.backgroundColor = [UIColor clearColor];
    UIImage *ampImg = [UIImage imageNamed:@"ampImg"];
    [amplbut setImage:ampImg forState:UIControlStateNormal];
    amplbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*0.9-64, [UIScreen mainScreen].bounds.size.height/2-100, 64, 64);
    //hangupnutton
    
    hangupbut = [UIButton buttonWithType:UIButtonTypeCustom];
    hangupbut.backgroundColor = [UIColor clearColor];
    UIImage *hangupImg = [UIImage imageNamed:@"hangupImg.png"];
    [hangupbut setImage:hangupImg forState:UIControlStateNormal];
    hangupbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-64, [UIScreen mainScreen].bounds.size.height-200, 128, 128);
    [hangupbut addTarget:self action:@selector(hangupButtonTouched:) forControlEvents:UIControlEventTouchUpInside];



    [self.view addSubview:mutebut];
    [self.view addSubview:dialpadbut];
    [self.view addSubview:amplbut];
    [self.view addSubview:hangupbut];
    
    
}

- (void)hangupButtonTouched:(id)sender {
    pj_status_t status = pjsua_call_hangup(_call_id, 0, NULL, NULL);
    
    if (status != PJ_SUCCESS) {
        const pj_str_t *statusText =  pjsip_get_status_text(status);
        NSLog(@"Error in hanging up :%d(%s) !", status, statusText->ptr);
    }
    mainviewcontroller = [[MainViewController alloc]init];

    UIViewController *rootViewController = self;
    [rootViewController presentViewController:mainviewcontroller animated:YES completion:nil];
    
//    pjsua_call_hangup((pjsua_call_id)self.callId, 0, NULL, NULL);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end