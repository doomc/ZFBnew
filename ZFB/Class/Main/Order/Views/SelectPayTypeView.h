//
//  SelectPayTypeView.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectPayTypeViewDelegate <NSObject>

@required
/**
 选择支付类型

 @param index  1 在线支付，0 门店支付
 */
-(void)didClickWithIndex:(NSInteger)index;


/**
 关闭视图
 */
-(void)didClickClosePayTypeView;


@end
@interface SelectPayTypeView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,assign) id <SelectPayTypeViewDelegate> PayTypeDelegate;





@end
