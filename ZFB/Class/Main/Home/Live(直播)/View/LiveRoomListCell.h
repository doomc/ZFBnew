//
//  LiveRoomListCell.h
//  ZFB
//
//  Created by  展富宝  on 2018/1/3.
//  Copyright © 2018年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveRoomListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *roomImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *lb_nickName;
@property (weak, nonatomic) IBOutlet UILabel *lb_addess;
@property (weak, nonatomic) IBOutlet UILabel *lb_audience;//观众人数
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lb_layoutHeight;

@end
