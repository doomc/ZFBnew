//
//  StoreHomeCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreHomeCell : UITableViewCell

-(void)didClickwitchOneBuy:(NSIndexPath*)IndexPath;

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_salePrice;
@property (weak, nonatomic) IBOutlet UILabel *lb_storePrice;
@property (weak, nonatomic) IBOutlet UIButton *buyNow;

@end
