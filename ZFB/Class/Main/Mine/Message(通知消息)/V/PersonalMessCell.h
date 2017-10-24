//
//  PersonalMessCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/10/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonMessageModel.h"
@interface PersonalMessCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (nonatomic ,strong) PushMessageList * pushList;




@end
