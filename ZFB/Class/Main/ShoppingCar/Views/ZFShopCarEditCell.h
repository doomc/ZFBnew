//
//  ZFShopCarEditCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ShopCarEditDelegate <NSObject>

@optional
-(void)ChangeGoodsNumberShopCarEditCell:(UITableViewCell *)cell Number:(NSInteger)num;

-(void)SelectedConfirmCell:(UITableViewCell *)cell;
-(void)SelectedCancelCell:(UITableViewCell *)cell;
-(void)DeleteTheGoodsCell:(UITableViewCell *)cell;

@end
@interface ZFShopCarEditCell : UITableViewCell 

@property (assign, nonatomic) id <ShopCarEditDelegate> shopEditDelegate;

@property (weak, nonatomic) IBOutlet UIImageView *img_shopCar;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;


@property (weak, nonatomic) IBOutlet UILabel *lb_price;


@property (weak, nonatomic) IBOutlet UIButton *add_btn;

@property (weak, nonatomic) IBOutlet UIButton *reduce_btn;

//加减出的结果
@property (weak, nonatomic) IBOutlet UITextField *tf_result;

@property (weak, nonatomic) IBOutlet UIButton *deldete_btn;

@end
