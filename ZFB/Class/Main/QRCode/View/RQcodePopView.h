//
//  RQcodePopView.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  选择支付方式

#import <UIKit/UIKit.h>

@protocol RQcodePopViewDelegate <NSObject>



@end
@interface RQcodePopView : UIView

@property (nonatomic , assign) id <RQcodePopViewDelegate> delegate;


@end
