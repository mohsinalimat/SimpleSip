//
//  MainViewController.h
//  Bragi
//
//  Created by Yvonne on 1/21/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//

#ifndef Bragi_MainViewController_h
#define Bragi_MainViewController_h


#endif

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITextFieldDelegate>
@property (strong,nonatomic) UITextField  *phonenumber;
@property (strong,nonatomic) UIButton *callbut;

//@property (nonatomic, copy) NSString *phoneNumber;
//@property (nonatomic, assign) NSInteger callId;

@end
