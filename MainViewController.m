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
#import "PhoneNumberFormatter.h"
#import "AppDelegate.h"
@interface MainViewController (){
    pjsua_call_id _call_id;
}
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) PhoneNumberFormatter *numberFormatter;

@end

@implementation MainViewController
@synthesize phonenumber;
@synthesize callbut;
//@synthesize phoneNumber;
//@synthesize callId;
@synthesize onebut;
@synthesize twobut;
@synthesize threebut;
@synthesize fourbut;
@synthesize fivebut;
@synthesize sixbut;
@synthesize sevenbut;
@synthesize eightbut;
@synthesize ninebut;
@synthesize zerobut;
@synthesize jinbut;
@synthesize backbut;
@synthesize digestbut;
@synthesize numberField;

@synthesize phoneNumber = _phoneNumber;
@synthesize numberFormatter = _numberFormatter;


//pjsua_call_id _call_id;

DialingCallViewController *dialingcallviewcontroller;
//- init{
//    NSLog(@"maininit");
//    AppDelegate *delegate = [[AppDelegate alloc]init];
////    self.window.rootViewController = delegate.tabbarController;
//    
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    numberField.text = @"";
    self.phoneNumber = @"";
    self.numberFormatter = [[PhoneNumberFormatter alloc] init];
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

 //   [self.view addSubview:phonenumber];
 //   [self.view addSubview:callbut];
    
    
    //        self.editableText = [[UITextField alloc]initWithFrame:CGRectMake(50,0,self.frame.size.width-50,self.frame.size.height)];
    
    [self initMainView];
}
- (void)initMainView{
    
    onebut = [UIButton buttonWithType:UIButtonTypeCustom];
    onebut.backgroundColor = [UIColor clearColor];
    
    UIImage *oneImg = [UIImage imageNamed:@"1.png"];
    [onebut setImage:oneImg forState:UIControlStateNormal];
    
    onebut.titleLabel.text = @"1";
    [onebut addTarget:self action:@selector(InputNum:) forControlEvents:UIControlEventTouchUpInside];
    onebut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/8,[UIScreen mainScreen].bounds.size.height/6,80,80);
    
    twobut = [UIButton buttonWithType:UIButtonTypeCustom];
    twobut.backgroundColor = [UIColor clearColor];
    
    UIImage *twoImg = [UIImage imageNamed:@"2.png"];
    [twobut setImage:twoImg forState:UIControlStateNormal];
    
    twobut.titleLabel.text = @"2";
    [twobut addTarget:self action:@selector(InputNum:) forControlEvents:UIControlEventTouchUpInside];
    twobut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.5,[UIScreen mainScreen].bounds.size.height/6,80,80);
    
    threebut = [UIButton buttonWithType:UIButtonTypeCustom];
    threebut.backgroundColor = [UIColor clearColor];
    
    UIImage *threeImg = [UIImage imageNamed:@"3.png"];
    [threebut setImage:threeImg forState:UIControlStateNormal];
    threebut.titleLabel.text = @"3";
   [threebut addTarget:self action:@selector(InputNum:) forControlEvents:UIControlEventTouchUpInside];
    threebut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/40*27,[UIScreen mainScreen].bounds.size.height/6,80,80);
    
    fourbut = [UIButton buttonWithType:UIButtonTypeCustom];
    fourbut.backgroundColor = [UIColor clearColor];
    
    UIImage *fourImg = [UIImage imageNamed:@"4.png"];
    [fourbut setImage:fourImg forState:UIControlStateNormal];
    
    fourbut.titleLabel.text = @"4";
    [fourbut addTarget:self action:@selector(InputNum:) forControlEvents:UIControlEventTouchUpInside];
    fourbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/8,[UIScreen mainScreen].bounds.size.height/6*2,80,80);
    
    fivebut = [UIButton buttonWithType:UIButtonTypeCustom];
    fivebut.backgroundColor = [UIColor clearColor];
    
    UIImage *fiveImg = [UIImage imageNamed:@"5.png"];
    [fivebut setImage:fiveImg forState:UIControlStateNormal];
    
    fivebut.titleLabel.text = @"5";
    [fivebut addTarget:self action:@selector(InputNum:) forControlEvents:UIControlEventTouchUpInside];
    fivebut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.5,[UIScreen mainScreen].bounds.size.height/6*2,80,80);
    
    sixbut = [UIButton buttonWithType:UIButtonTypeCustom];
    sixbut.backgroundColor = [UIColor clearColor];
    
    UIImage *sixImg = [UIImage imageNamed:@"6.png"];
    [sixbut setImage:sixImg forState:UIControlStateNormal];
    
    sixbut.titleLabel.text = @"6";
    [sixbut addTarget:self action:@selector(InputNum:) forControlEvents:UIControlEventTouchUpInside];
    sixbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/40*27,[UIScreen mainScreen].bounds.size.height/6*2,80,80);
    
    sevenbut = [UIButton buttonWithType:UIButtonTypeCustom];
    sevenbut.backgroundColor = [UIColor clearColor];
    
    UIImage *sevenImg = [UIImage imageNamed:@"7.png"];
    [sevenbut setImage:sevenImg forState:UIControlStateNormal];
    
    sevenbut.titleLabel.text = @"7";
    [sevenbut addTarget:self action:@selector(InputNum:) forControlEvents:UIControlEventTouchUpInside];    sevenbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/8,[UIScreen mainScreen].bounds.size.height/6*3,80,80);
    
    eightbut = [UIButton buttonWithType:UIButtonTypeCustom];
    eightbut.backgroundColor = [UIColor clearColor];
    
    UIImage *eightImg = [UIImage imageNamed:@"8.png"];
    [eightbut setImage:eightImg forState:UIControlStateNormal];
    
    eightbut.titleLabel.text = @"8";
    [eightbut addTarget:self action:@selector(InputNum:) forControlEvents:UIControlEventTouchUpInside];
    eightbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.5,[UIScreen mainScreen].bounds.size.height/6*3,80,80);
    
    ninebut = [UIButton buttonWithType:UIButtonTypeCustom];
    ninebut.backgroundColor = [UIColor clearColor];
    
    UIImage *nineImg = [UIImage imageNamed:@"9.png"];
    [ninebut setImage:nineImg forState:UIControlStateNormal];
    ninebut.titleLabel.text = @"9";
    [ninebut addTarget:self action:@selector(InputNum:) forControlEvents:UIControlEventTouchUpInside];
    ninebut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/40*27,[UIScreen mainScreen].bounds.size.height/6*3,80,80);
    
    zerobut = [UIButton buttonWithType:UIButtonTypeCustom];
    zerobut.backgroundColor = [UIColor clearColor];
    
    UIImage *zeroImg = [UIImage imageNamed:@"0.png"];
    [zerobut setImage:zeroImg forState:UIControlStateNormal];
    
    zerobut.titleLabel.text = @"0";
    [zerobut addTarget:self action:@selector(InputNum:) forControlEvents:UIControlEventTouchUpInside];
    zerobut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.5,[UIScreen mainScreen].bounds.size.height/6*4,80,80);
    
    jinbut = [UIButton buttonWithType:UIButtonTypeCustom];
    jinbut.backgroundColor = [UIColor clearColor];
    
    UIImage *jinImg = [UIImage imageNamed:@"#.png"];
    [jinbut setImage:jinImg forState:UIControlStateNormal];
    
    jinbut.titleLabel.text = @"#";
    [jinbut addTarget:self action:@selector(InputNum:) forControlEvents:UIControlEventTouchUpInside];
    jinbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/40*27,[UIScreen mainScreen].bounds.size.height/6*4,80,80);
    
    digestbut = [UIButton buttonWithType:UIButtonTypeCustom];
    digestbut.backgroundColor = [UIColor clearColor];
    
    UIImage *digestImg = [UIImage imageNamed:@"digest.png"];
    [digestbut setImage:digestImg forState:UIControlStateNormal];
    
    digestbut.titleLabel.text = @"*";
    [digestbut addTarget:self action:@selector(InputNum:) forControlEvents:UIControlEventTouchUpInside];
    digestbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/8,[UIScreen mainScreen].bounds.size.height/6*4,80,80);
    
    callbut = [UIButton buttonWithType:UIButtonTypeCustom];
    callbut.backgroundColor = [UIColor clearColor];
    
    UIImage *callImg = [UIImage imageNamed:@"answerImg.png"];
    [callbut setImage:callImg forState:UIControlStateNormal];
    
     [callbut addTarget:self action:@selector(__processMakeCall) forControlEvents:UIControlEventTouchUpInside];
    callbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.5,[UIScreen mainScreen].bounds.size.height/6*5,80,80);
    
    
    backbut = [UIButton buttonWithType:UIButtonTypeCustom];
    backbut.backgroundColor = [UIColor clearColor];
    
    UIImage *backImg = [UIImage imageNamed:@"back.png"];
    [backbut setImage:backImg forState:UIControlStateNormal];
    
    [backbut addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    backbut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/40*35,[UIScreen mainScreen].bounds.size.height/10,24,24);
    
    numberField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/10,[UIScreen mainScreen].bounds.size.height/12, [UIScreen mainScreen].bounds.size.width/1.5, 30)];
    [numberField setTextAlignment:NSTextAlignmentCenter];
    [numberField setTextColor:(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) ? [UIColor blackColor] : [UIColor whiteColor]];
    [numberField setFont:[UIFont boldSystemFontOfSize:30]];
    [numberField setBackgroundColor:[UIColor clearColor]];
//    numberField.lineBreakMode = UILineBreakModeCharacterWrap;
 //   self.phoneNumber = [self.phoneNumber stringByAppendingString:@"0988813668"];
    numberField.text = [self.numberFormatter format:self.phoneNumber withLocale:@"US"];
//    numberlabel.text = [self.numberFormatter format:self.phoneNumber withLocale:@"US"];
    [self.view addSubview:onebut];
    [self.view addSubview:twobut];
    [self.view addSubview:threebut];
    [self.view addSubview:fourbut];
    [self.view addSubview:fivebut];
    [self.view addSubview:sixbut];
    [self.view addSubview:sevenbut];
    [self.view addSubview:eightbut];
    [self.view addSubview:ninebut];
    [self.view addSubview:zerobut];
    [self.view addSubview:jinbut];
    [self.view addSubview:callbut];
    [self.view addSubview:backbut];
    [self.view addSubview:digestbut];
    [self.view addSubview:numberField];

}

- (void)InputNum:(id)sender{
    NSLog(@"inputNum...");
    UIButton *clicked = (UIButton *) sender;
  //  numberField.text = @"2";
    
 //   [[tonesArray objectAtIndex:sender.tag] play];
    numberField.text = [numberField.text stringByAppendingString:clicked.titleLabel.text];
  //  numberField.text = [self.numberFormatter format:numberField.text withLocale:@"US"];

    //numberField.text = [[NSString stringWithFormat:@"%ld", (long)((UIControl*)sender).tag];
}

- (void)goBack:(id)sender
{
    NSUInteger currentLength = [numberField.text length];
    if (currentLength > 0)
    {
        NSRange range = NSMakeRange(0, currentLength - 1);
        numberField.text = [numberField.text substringWithRange:range];
      //  numberField.text = [self.numberFormatter format:numberField.text withLocale:@"US"];
    }
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
 //   NSString *targetUri = [NSString stringWithFormat:@"sip:%@@140.114.71.165:12373", phonenumber.text];
    NSString *targetUri = [NSString stringWithFormat:@"sip:%@@140.114.71.165:12373", numberField.text];
    NSLog(@"numberfield:%@",numberField.text);
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
    NSLog(@"ohohmake_call%d",acct_id);
    if (status != PJ_SUCCESS) {
        char  errMessage[PJ_ERR_MSG_SIZE];
        pj_strerror(status, errMessage, sizeof(errMessage));
        NSLog(@"Error in calling:%d(%s) !", status, errMessage);
    }else{
        dialingcallviewcontroller = [[DialingCallViewController alloc]init];
        dialingcallviewcontroller.callId = _call_id;
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
