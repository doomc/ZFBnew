//
//  ZFAppraiseCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppraiseModel.h"

@protocol ZFAppraiseCellDelegate <NSObject>

-(void)didclickPhotoPicker:(NSInteger )index images:(NSArray *)images;

@end

@interface ZFAppraiseCell : UITableViewCell

@property (assign, nonatomic) id <ZFAppraiseCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UIImageView *img_appraiseView;

@property (weak, nonatomic) IBOutlet UILabel *lb_nickName;

@property (weak, nonatomic) IBOutlet UILabel *lb_detailtext;

@property (weak, nonatomic) IBOutlet UILabel *lb_message;

@property (weak, nonatomic) IBOutlet UICollectionView *appriseCollectionView;

@property (copy ,nonatomic) NSString * imgurl;
 
@property (nonatomic ,strong) Findlistreviews * infoList ;

@property (nonatomic ,strong) NSArray  * mutImgArray;



@end
