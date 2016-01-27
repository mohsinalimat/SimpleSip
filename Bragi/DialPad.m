////
////  DialPad.m
////  Bragi
////
////  Created by Yvonne on 1/26/16.
////  Copyright (c) 2016 Yvonne. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import "DialPad.h"
//#import <pjsua-lib/pjsua.h>
//#import "GSPJUtil.h"
//@interface DialPad(){
//   // pjsua_call_id _call_id;
//
//}
//
//@end
//
//@implementation DialPad
//@synthesize phonenumber;
//@synthesize callbut;
//
//- (void)viewDidLoad{
//    [super viewDidLoad];
//    
//    self.view = [[UIView alloc]init];
//    phonenumber = [[UITextField alloc]initWithFrame:CGRectMake(0,0, 100, 100)];
//    
//    //    phonenumber.backgroundColor = [UIColor whiteColor];
//    //    [self.phonenumber.borderStyle = UIText]
//    //    [self.editableText setBackgroundColor:[UIColor whiteColor]];
//    phonenumber.borderStyle = UITextBorderStyleRoundedRect;
//    phonenumber.placeholder = NSLocalizedString(@"Please input the phoneNumber",nil);
//    phonenumber.returnKeyType = UIReturnKeyDone;
//    phonenumber.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    phonenumber.delegate = self;
//    
//    //    self.editableText.clearButtonMode = UITextFieldViewModeWhileEditing;
//    //    self.editableText.textColor  =[UIColor themeColorNamed:@"textColor"];
//    //    [self.editableText setFont:[UIFont themeFontNamed:@"textFont" andSize:16]];
//    //    [self.editableText setAdjustsFontSizeToFitWidth:YES];
//    //    callbut = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    //        self.saveButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-170, [UIScreen mainScreen].bounds.size.height-50, 50, 30);
//    callbut = [UIButton buttonWithType:UIButtonTypeCustom];
//    callbut.backgroundColor = [UIColor blackColor];
//    [callbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [callbut setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    
//    
//    [callbut setTitle:@"Call" forState:UIControlStateNormal];
//    [callbut addTarget:self action:@selector(but:) forControlEvents:UIControlEventTouchUpInside];
//    callbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100, [UIScreen mainScreen].bounds.size.height-300, 100, 30);
//    
//    [self.view addSubview:phonenumber];
//    [self.view addSubview:callbut];
//    
//    /*
//     
//     
//     - (BOOL)sendDTMFDigits:(NSString *)digits {
//     pj_str_t pjDigits = [GSPJUtil PJStringWithString:digits];
//     pjsua_call_dial_dtmf(_callId, &pjDigits);
//     }
//     */
//    
////    [[NSNotificationCenter defaultCenter] addObserver:self
////                                             selector:@selector(handleCallStatusChanged:)
////                                                 name:@"SIPCallStatusChangedNotification"
////                                               object:nil];
//
//
//}
//
//- (void)but:(id)sender{
//    [self sendDTMFDigits:phonenumber.text];
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//}
//
////- (void)handleCallStatusChanged:(NSNotification *)notification {
////    pjsua_call_id call_id = [notification.userInfo[@"call_id"] intValue];
////    pjsip_inv_state state = [notification.userInfo[@"state"] intValue];
////    
////    if(call_id != _call_id) return;
//////    if (state == PJSIP_INV_STATE_DISCONNECTED) {
//////        [self dismissViewControllerAnimated:YES completion:nil];
//////    }else if(state == PJSIP_INV_STATE_CONNECTING){
//////        NSLog(@"连接中...");
//////    } else if(state == PJSIP_INV_STATE_CONFIRMED) {
//////        NSLog(@"接听成功！");
//////    }
//////    
////}
//
////- (void)sendDTMFDigits:(NSString *)digits {
////    pj_str_t pjDigits = [GSPJUtil PJStringWithString:digits];
////    pjsua_call_dial_dtmf(_call_id, &pjDigits);
////}
//
//- (void)sendDTMFDigits:(NSString *)digits {
//    
//    pj_status_t status;
//    pj_str_t pjDigits = [GSPJUtil PJStringWithString:digits];
//    
//    // Try to send RFC2833 DTMF first.
//    status = pjsua_call_dial_dtmf(_call_id, &pjDigits);
//    
//    if(status != PJ_SUCCESS) {  // Okay, that didn't work. Send INFO DTMF.
//        const pj_str_t kSIPINFO = pj_str("INFO");
//        
//        for (NSUInteger i = 0; i < [digits length]; ++i) {
//            pjsua_msg_data messageData;
//            pjsua_msg_data_init(&messageData);
//            messageData.content_type = pj_str("application/dtmf-relay");
//            
//            NSString *messageBody
//            = [NSString stringWithFormat:@"Signal=%C\r\nDuration=300",
//               [digits characterAtIndex:i]];
//            messageData.msg_body =[GSPJUtil PJStringWithString:messageBody];
//            
//            status = pjsua_call_send_request(_call_id, &kSIPINFO, &messageData);
//            if (status != PJ_SUCCESS)
//                NSLog(@"Error sending DTMF");
//        }
//    }
//}
//
//
////- (void)but:(id)sender{
////    pj_str_t pjDigits = [GSPJUtil PJStringWithString:digits];
////    pjsua_call_dial_dtmf(_callId, &pjDigits);
////}
//
//@end