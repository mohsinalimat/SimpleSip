//
//  DialingCallViewController.h
//  Bragi
//
//  Created by Yvonne on 1/22/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#ifndef Bragi_DialingCallViewController_h
#define Bragi_DialingCallViewController_h


#endif

#import <UIKit/UIKit.h>

@interface DialingCallViewController : UIViewController

@property (strong,nonatomic) UIButton *mutebut;
@property (strong,nonatomic) UIButton *dialpadbut;
@property (strong,nonatomic) UIButton *amplbut;
@property (strong,nonatomic) UIButton *hangupbut;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) NSInteger callId;

//@property (nonatomic, copy) NSString *phoneNumber;
//@property (nonatomic, assign) NSInteger callId;
//@property (strong,nonatomic) UIButton *answerbut;
//@property (strong,nonatomic) UIButton *hangupbut;


@end