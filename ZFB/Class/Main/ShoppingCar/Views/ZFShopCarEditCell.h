//
//  ZFShopCarEditCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"
@protocol  ShopCarEditDelegate <NSObject>

@optional
-(void)ChangeGoodsNumberShopCarEditCell:(UITableViewCell *)cell Number:(NSInteger)num;

-(void)SelectedConfirmCell:(UITableViewCell *)cell;
-(void)SelectedCancelCell:(UITableViewCell *)cell;
-(void)DeleteTheGoodsCell:(UITableViewCell *)cell;

@end
@interface ZFShopCarEditCell : UITableViewCell<PPNumberButtonDelegate>

@property (assign, nonatomic) id <ShopCarEditDelegate> shopEditDelegate;

@property (weak, nonatomic) IBOutlet UIImageView *img_shopCar;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_price;

@property (weak, nonatomic) IBOutlet PPNumberButton *ppNumberView;

@property (weak, nonatomic) IBOutlet UIButton *deldete_btn;

@end
