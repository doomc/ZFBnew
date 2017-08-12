//
//  SalesAfterPopView.h
//  ZFB
//
//  Created by 熊维东 on 2017/7/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  售后申请popView

#import <UIKit/UIKit.h>


@protocol SalesAfterPopViewDelegate <NSObject> 
@optional
//移除popView
-(void)deletePopView;

-(void)getReasonString:(NSString *)reason;


@end
@interface SalesAfterPopView : UIView

@property (nonatomic,assign) id <SalesAfterPopViewDelegate> delegate;




@end
