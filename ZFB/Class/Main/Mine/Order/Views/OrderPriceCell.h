//
//  OrderPriceCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPriceCell : UITableViewCell
/**配送费 */
@property (weak, nonatomic) IBOutlet UILabel *lb_tipFree;
/**总共金额 */
@property (weak, nonatomic) IBOutlet UILabel *lb_priceTotal;


@end
