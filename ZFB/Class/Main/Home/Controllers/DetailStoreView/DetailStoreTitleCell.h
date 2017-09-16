//
//  DetailStoreTitleCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/9/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DetailStoreTitleCellDelegate <NSObject>

//拨打电话
-(void)callingBack;


@end
@interface DetailStoreTitleCell : UITableViewCell

@property (assign ,nonatomic) id<DetailStoreTitleCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *lb_storeName;

@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@property (weak, nonatomic) IBOutlet UIImageView *callImageView;
@end
