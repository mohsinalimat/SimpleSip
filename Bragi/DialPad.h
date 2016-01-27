//
//  DialPad.h
//  Bragi
//
//  Created by Yvonne on 1/26/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#ifndef Bragi_DialPad_h
#define Bragi_DialPad_h


#endif

#import <UIKit/UIKit.h>

@interface DialPad : UIViewController<UITextFieldDelegate>
@property (strong,nonatomic) UITextField  *phonenumber;
@property (strong,nonatomic) UIButton *callbut;
@property (nonatomic, assign) NSInteger callId;
@property (strong,nonatomic) UIButton *hangupbut;
@property (strong,nonatomic) UIButton *onebut;
@property (strong,nonatomic) UIButton *twobut;
@property (strong,nonatomic) UIButton *threebut;
@property (strong,nonatomic) UIButton *fourbut;
@property (strong,nonatomic) UIButton *fivebut;
@property (strong,nonatomic) UIButton *sixbut;
@property (strong,nonatomic) UIButton *sevenbut;
@property (strong,nonatomic) UIButton *eightbut;
@property (strong,nonatomic) UIButton *ninebut;
@property (strong,nonatomic) UIButton *zerobut;
@property (strong,nonatomic) UIButton *jinbut;
@property (strong,nonatomic) UIButton *backbut;
@property (strong,nonatomic) UIButton *digestbut;
@property (strong,nonatomic) UITextField *numberField;



@end