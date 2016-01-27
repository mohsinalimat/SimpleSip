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
//#import "DialPad.h"
@interface DialingCallViewController(){
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
  //  [dialpadbut addTarget:self action:@selector(dialpad:) forControlEvents:UIControlEventTouchUpInside];

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCallStatusChanged:)
                                                 name:@"SIPCallStatusChangedNotification"
                                               object:nil];
    
}

- (void)dialpad:(id)sender{
//    DialPad *pad = [[DialPad alloc]init];
//    UIViewController *rootViewController = self;
//    [rootViewController presentViewController:pad animated:YES completion:nil];

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleCallStatusChanged:(NSNotification *)notification {
    pjsua_call_id call_id = [notification.userInfo[@"call_id"] intValue];
    pjsip_inv_state state = [notification.userInfo[@"state"] intValue];
    
    if(call_id != self.callId) return;
    if (state == PJSIP_INV_STATE_DISCONNECTED) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(state == PJSIP_INV_STATE_CONNECTING){
        NSLog(@"连接中...");
    } else if(state == PJSIP_INV_STATE_CONFIRMED) {
        NSLog(@"接听成功！");
    }
    
}


- (void)hangupButtonTouched:(id)sender {
    pj_status_t status = pjsua_call_hangup((pjsua_call_id)self.callId, 0, NULL, NULL);
    
    if (status != PJ_SUCCESS) {
        const pj_str_t *statusText =  pjsip_get_status_text(status);
        NSLog(@"Error in hanging up :%d(%s) !", status, statusText->ptr);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end