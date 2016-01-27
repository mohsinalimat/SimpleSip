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


@end