//
//  MainViewController.m
//  Bragi
//
//  Created by Yvonne on 1/21/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
#import <pjsua-lib/pjsua.h>
#import "DialingCallViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize phonenumber;
@synthesize callbut;
//@synthesize phoneNumber;
//@synthesize callId;

pjsua_call_id _call_id;

DialingCallViewController *dialingcallviewcontroller;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCallStatusChanged:)
                                                 name:@"SIPCallStatusChangedNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRegisterStatus:)
                                                 name:@"SIPRegisterStatusNotification"
                                               object:nil];

    self.view = [[UIView alloc]init];
    phonenumber = [[UITextField alloc]initWithFrame:CGRectMake(0,0, 100, 100)];
    
//    phonenumber.backgroundColor = [UIColor whiteColor];
//    [self.phonenumber.borderStyle = UIText]
//    [self.editableText setBackgroundColor:[UIColor whiteColor]];
    phonenumber.borderStyle = UITextBorderStyleRoundedRect;
    phonenumber.placeholder = NSLocalizedString(@"Please input the phoneNumber",nil);
    phonenumber.returnKeyType = UIReturnKeyDone;
    phonenumber.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    phonenumber.delegate = self;
    
//    self.editableText.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.editableText.textColor  =[UIColor themeColorNamed:@"textColor"];
//    [self.editableText setFont:[UIFont themeFontNamed:@"textFont" andSize:16]];
//    [self.editableText setAdjustsFontSizeToFitWidth:YES];
//    callbut = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    //        self.saveButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-170, [UIScreen mainScreen].bounds.size.height-50, 50, 30);
    callbut = [UIButton buttonWithType:UIButtonTypeCustom];
    callbut.backgroundColor = [UIColor blackColor];
    [callbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callbut setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    

    [callbut setTitle:@"Call" forState:UIControlStateNormal];
    [callbut addTarget:self action:@selector(__processMakeCall) forControlEvents:UIControlEventTouchUpInside];
    callbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100, [UIScreen mainScreen].bounds.size.height-300, 100, 30);

    [self.view addSubview:phonenumber];
    [self.view addSubview:callbut];
    
    
    //        self.editableText = [[UITextField alloc]initWithFrame:CGRectMake(50,0,self.frame.size.width-50,self.frame.size.height)];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)handleRegisterStatus:(NSNotification *)notification {
    pjsua_acc_id acc_id = [notification.userInfo[@"acc_id"] intValue];
    pjsip_status_code status = [notification.userInfo[@"status"] intValue];
    NSString *statusText = notification.userInfo[@"status_text"];
    
    if (status != PJSIP_SC_OK) {
        NSLog(@"Login Failed : %d(%@)", status, statusText);
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:acc_id forKey:@"login_account_id"];
    [[NSUserDefaults standardUserDefaults] setObject:@"140.114.71.165:12373" forKey:@"server_uri"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleCallStatusChanged:(NSNotification *)notification {
    pjsua_call_id call_id = [notification.userInfo[@"call_id"] intValue];
    pjsip_inv_state state = [notification.userInfo[@"state"] intValue];
    
    if(call_id != _call_id) return;
    
    if (state == PJSIP_INV_STATE_DISCONNECTED) {
        [callbut setTitle:@"Call" forState:UIControlStateNormal];
        [callbut setEnabled:YES];
    } else if(state == PJSIP_INV_STATE_CONNECTING){
        NSLog(@"Connecting...");
    } else if(state == PJSIP_INV_STATE_CONFIRMED) {
    }
}

//- (IBAction)actionButtonTouched:(UIButton *)sender {
//    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"Call"]) {
//        [self __processMakeCall];
//    } else {
//        [self __processHangup];
//    }
//    [sender setEnabled:NO];
//}

- (void)__processMakeCall {
    
    pjsua_acc_id acct_id = (pjsua_acc_id)[[NSUserDefaults standardUserDefaults] integerForKey:@"login_account_id"];
//    NSString *server = [[NSUserDefaults standardUserDefaults] stringForKey:@"server_uri"];
    NSString *targetUri = [NSString stringWithFormat:@"sip:%@@140.114.71.165:12373", phonenumber.text];
    //    //  NSURL *phoneNumber = [NSURL urlWithString:[NSString stringWithFormat:@"tel://%@", username]];
    //
    //    // Whilst this version will return you to your app once the phone call is over.
        NSURL *phoneNum = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", targetUri]];
    //
    //    // Now that we have our `phoneNumber` as a URL. We need to check that the device we are using can open the URL.
    //    // Whilst iPads, iPhone, iPod touchs can all open URLs in safari mobile they can't all
    //    // open URLs that are numbers this is why we have `tel://` or `telprompt://`
//        if([[UIApplication sharedApplication] canOpenURL:phoneNum]) {
//            // So if we can open it we can now actually open it with
//            [[UIApplication sharedApplication] openURL:phoneNum];
//        }
    
    pj_status_t status;
    pj_str_t dest_uri = pj_str((char *)targetUri.UTF8String);
    
    status = pjsua_call_make_call(acct_id, &dest_uri, 0, NULL, NULL, &_call_id);
    
    if (status != PJ_SUCCESS) {
        char  errMessage[PJ_ERR_MSG_SIZE];
        pj_strerror(status, errMessage, sizeof(errMessage));
        NSLog(@"Error in calling:%d(%s) !", status, errMessage);
    }else{
        dialingcallviewcontroller = [[DialingCallViewController alloc]init];
        UIViewController *rootViewController = self;
        [rootViewController presentViewController:dialingcallviewcontroller animated:YES completion:nil];

    }
}

- (void)__processHangup {
    pj_status_t status = pjsua_call_hangup(_call_id, 0, NULL, NULL);
    
    if (status != PJ_SUCCESS) {
        const pj_str_t *statusText =  pjsip_get_status_text(status);
        NSLog(@"Error in hanging up:%d(%s) !", status, statusText->ptr);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
