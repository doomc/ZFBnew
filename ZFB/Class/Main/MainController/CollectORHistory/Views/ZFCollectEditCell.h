//
//  ZFCollectEditCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFCollectEditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_editView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;

@property (weak, nonatomic) IBOutlet UIButton *selecet_btn;


@end
