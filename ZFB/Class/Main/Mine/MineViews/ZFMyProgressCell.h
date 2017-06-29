//
//  ZFMyProgressCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZFMyProgressCellDelegate <NSObject>

///待付款
-(void)didClickWaitForPayAction:(UIButton *)button;
///已配送
-(void)didClickSendedAction:(UIButton *)button;
///待评价
-(void)didClickWaitForEvaluateAction:(UIButton *)button;
///退货
-(void)didClickBacKgoodsAction:(UIButton *)button;

@end
@interface ZFMyProgressCell : UITableViewCell

@property (nonatomic,assign) id<ZFMyProgressCellDelegate>delegate;


@end
