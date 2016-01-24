//
//  IncomingCallViewController.h
//  Bragi
//
//  Created by Yvonne on 1/22/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#ifndef Bragi_IncomingCallViewController_h
#define Bragi_IncomingCallViewController_h


#endif
#import <UIKit/UIKit.h>

@interface IncomingCallViewController : UIViewController


@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) NSInteger callId;
@property (strong,nonatomic) UIButton *answerbut;
@property (strong,nonatomic) UIButton *hangupbut;


@end