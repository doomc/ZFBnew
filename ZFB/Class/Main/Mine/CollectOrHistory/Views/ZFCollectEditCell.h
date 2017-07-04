//
//  ZFCollectEditCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCollectEditCell;
@protocol ZFCollectEditCellDelegate <NSObject>

- (void)goodsSelected:(ZFCollectEditCell *)cell isSelected:(BOOL)choosed;
// 点击全选 按钮回调

@end
@interface ZFCollectEditCell : UITableViewCell

@property (nonatomic,assign) id <ZFCollectEditCellDelegate> delegate;
 
@property (weak, nonatomic) IBOutlet UIImageView *img_editView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;

@property (weak, nonatomic) IBOutlet UIButton *selecet_btn;


@end
