//
//  ZFShopCarCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"
#import "ShoppingCarModel.h"
#import <MGSwipeTableCell/MGSwipeTableCell.h>
@protocol ShoppingSelectedDelegate <NSObject>

-(void)ChangeGoodsNumberCell:(UITableViewCell *)cell Number:(NSInteger)num;


@end
@interface ZFShopCarCell : MGSwipeTableCell


@property (assign, nonatomic) id <ShoppingSelectedDelegate> selectDelegate;

@property (weak, nonatomic) IBOutlet UIImageView *img_shopCar;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_price;



@property (weak, nonatomic) IBOutlet UIButton *add_btn;

@property (weak, nonatomic) IBOutlet UIButton *reduce_btn;

//加减出的结果
@property (weak, nonatomic) IBOutlet UITextField *tf_result;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@property (strong ,nonatomic) ShoppingCarModel * shopModel;

@end
