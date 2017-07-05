//
//  ZFSaleAfterContentCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllOrderModel.h"
@protocol ZFSaleAfterContentCellDelegate <NSObject>

-(void)salesAfterDetailPage;


@end
@interface ZFSaleAfterContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *saleAfter_btn;
@property (weak, nonatomic) IBOutlet UIImageView *img_saleAfter;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_goodcount;

@property (nonatomic,assign) id <ZFSaleAfterContentCellDelegate> delegate;

@property (strong,nonatomic) Orderlist * list ;
@property (strong,nonatomic) Ordergoods * goods ;

@end
