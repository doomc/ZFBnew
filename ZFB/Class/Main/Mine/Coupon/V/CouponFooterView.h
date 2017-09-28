//
//  CouponFooterView.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponFooterViewDelegate <NSObject>

 ///取消删除-取消编辑状态
-(void)didClickCancle;

 ///批量删除
-(void)didClickDeleteSelectCouponCell;

 ///全选
-(void)didClickSelectAll:(UIButton *)sender;

@end
@interface CouponFooterView : UIView

-(instancetype)initWithCouponFooterViewFrame:(CGRect)frame;

@property (nonatomic , assign) id <CouponFooterViewDelegate> delegate;

//取消操作
@property (weak, nonatomic) IBOutlet UIButton *cancelEdit;

//批量删除
@property (weak, nonatomic) IBOutlet UIButton *deleteAll;

//全选
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;



@end
