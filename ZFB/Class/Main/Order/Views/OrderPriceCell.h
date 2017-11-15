//
//  OrderPriceCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OrderPriceCellDelegate <NSObject>

//查看明细
-(void)checkDetailAction:(UIButton*)sender;

@end
@interface OrderPriceCell : UITableViewCell
/**配送费 */
@property (weak, nonatomic) IBOutlet UILabel *lb_tipFree;
/**总共金额 */
@property (weak, nonatomic) IBOutlet UILabel *lb_priceTotal;
//查看明细
@property (weak, nonatomic) IBOutlet UIButton *checkDeitalBtn;

@property (assign, nonatomic) id <OrderPriceCellDelegate> delegate;


@end
