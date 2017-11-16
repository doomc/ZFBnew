//
//  BuyCountCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BuyCountCellDelegate <NSObject>

-(void)addCount:(NSInteger)count;

@end

@interface BuyCountCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (assign, nonatomic)  NSInteger num;
@property (assign, nonatomic) id <BuyCountCellDelegate> delegate;

@end
