//
//  IncomingCallViewController.m
//  Bragi
//
//  Created by Yvonne on 1/22/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IncomingCallViewController.h"
#import <pjsua-lib/pjsua.h>

@interface IncomingCallViewController()
@end

@implementation IncomingCallViewController

@synthesize hangupbut;
@synthesize answerbut;
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view = [[UIView alloc]init];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    answerbut = [UIButton buttonWithType:UIButtonTypeCustom];
    answerbut.backgroundColor = [UIColor clearColor];
//    [answerbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [answerbut setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    UIImage *answerImg = [UIImage imageNamed:@"answerImg.png"];
    [answerbut setImage:answerImg forState:UIControlStateNormal];

    [answerbut addTarget:self action:@selector(answerButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    answerbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-150, [UIScreen mainScreen].bounds.size.height-300, 128, 128);
    
    hangupbut = [UIButton buttonWithType:UIButtonTypeCustom];
    hangupbut.backgroundColor = [UIColor clearColor];
    
    UIImage *hangupImg = [UIImage imageNamed:@"hangupImg.png"];
    [hangupbut setImage:hangupImg forState:UIControlStateNormal];
    
    [hangupbut addTarget:self action:@selector(hangupButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    hangupbut.frame = CGRectMake(50,[UIScreen mainScreen].bounds.size.height-300,128,128);
    [self.view addSubview:hangupbut];
    [self.view addSubview:answerbut];
   // self.phoneNumberLabel.text = self.phoneNumber;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCallStatusChanged:)
                                                 name:@"SIPCallStatusChangedNotification"
                                               object:nil];

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)answerButtonTouched:(id)sender {
    pjsua_call_answer((pjsua_call_id)self.callId, 200, NULL, NULL);
}

- (void)hangupButtonTouched:(id)sender {
    pjsua_call_hangup((pjsua_call_id)self.callId, 0, NULL, NULL);
}
- (void)handleCallStatusChanged:(NSNotification *)notification {
    pjsua_call_id call_id = [notification.userInfo[@"call_id"] intValue];
    pjsip_inv_state state = [notification.userInfo[@"state"] intValue];
    
    NSLog(@"WWW call_id :%d YYY callID:%ld",call_id,(long)self.callId);
    if(call_id != self.callId) return;
    
    if (state == PJSIP_INV_STATE_DISCONNECTED) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if(state == PJSIP_INV_STATE_CONNECTING){
        NSLog(@"连接中...");
    } else if(state == PJSIP_INV_STATE_CONFIRMED) {
        NSLog(@"接听成功！");
    }
}
//-(void) stopotherapp{
//NSError *setCategoryError =nil;
//BOOL success = [[AVAudioSessionsharedInstance]
//                setCategory:AVAudioSessionCategorySoloAmbient
//                error: &setCategoryError];
//if (!success) {
//    UIAlertView *alert = [[UIAlertViewalloc]initWithTitle:@"～"message:@"器"delegate:nilcancelButtonTitle:@"OK!"otherButtonTitles:nil];
//    
//}
//[selfdisplayIncomingCall:call];
//
//break;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end