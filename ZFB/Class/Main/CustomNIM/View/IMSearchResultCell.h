//
//  IMSearchResultCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMSearchResultCellDelegate <NSObject>

-(void)addFridendWithIndexPathRow :(NSInteger )indexPathRow;

@end
@interface IMSearchResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *lb_nickName;
@property (weak, nonatomic) IBOutlet UILabel *lb_sign;

@property (nonatomic ,assign) NSInteger rowIndex;

@property (nonatomic ,assign) id <IMSearchResultCellDelegate> delegate;




@end
