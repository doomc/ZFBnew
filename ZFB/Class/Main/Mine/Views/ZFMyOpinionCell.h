//
//  ZFMyOpinionCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserFeedbackModel.h"

@protocol ZFMyOpinionCellDelegate <NSObject>

-(void)didclickPhotoPicker:(NSInteger )index images:(NSArray *)images;

@end

@interface ZFMyOpinionCell : UITableViewCell

@property (assign, nonatomic) id <ZFMyOpinionCellDelegate>delegate;

//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedcollectViewLayoutheight;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_status;

@property (weak, nonatomic) IBOutlet UICollectionView *feedCollectionView;

@property (strong, nonatomic) NSArray * imagerray;

@property (strong,nonatomic) Feedbacklist* feedList;


@end
