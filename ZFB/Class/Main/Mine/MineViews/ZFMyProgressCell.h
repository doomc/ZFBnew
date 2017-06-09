//
//  ZFMyProgressCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZFMyProgressCellDelegate <NSObject>

-(void)pushToSaleAfterview;

@end
@interface ZFMyProgressCell : UITableViewCell


/**
 退出
 */
@property (weak, nonatomic) IBOutlet UIButton *bacKgoods_btn;

@property (nonatomic,assign)id<ZFMyProgressCellDelegate>delegate;


@end
