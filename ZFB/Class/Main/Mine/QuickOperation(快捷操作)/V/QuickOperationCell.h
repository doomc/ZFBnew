//
//  QuickOperationCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QuickOperationCellDelegate <NSObject>
@optional
//点击开店
-(void)didClickOpenStore;

//点击配送
-(void)didClickSendGoods;

//切换商户
-(void)didClickChangeID;

//我的评价
-(void)didClickMyevalution;

//我的动态
-(void)didClickmyDynamic;

@end

@interface QuickOperationCell : UITableViewCell
//已审核的View
@property (weak, nonatomic) IBOutlet UIView *checkedView;
//切换商户
@property (weak, nonatomic) IBOutlet UIView * changeIdView;
@property (weak, nonatomic) IBOutlet UILabel *lb_changeName;

//我的评价
@property (weak, nonatomic) IBOutlet UIView *myEvaluate;
//我的动态
@property (weak, nonatomic) IBOutlet UIView *myDynamic;



//未审核View
@property (weak, nonatomic) IBOutlet UIView *unCheckView;
//我要开店
@property (weak, nonatomic) IBOutlet UIView *iWillOpenStoreView;
//我要配送
@property (weak, nonatomic) IBOutlet UIView *iWillSendView;


@property (assign ,nonatomic) id <QuickOperationCellDelegate >delegate;

@end
