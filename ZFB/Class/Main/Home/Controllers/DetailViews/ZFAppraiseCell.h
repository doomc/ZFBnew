//
//  ZFAppraiseCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppraiseModel.h"

@interface ZFAppraiseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet DWQRatingView *starView;

@property (weak, nonatomic) IBOutlet UIImageView *img_appraiseView;

@property (weak, nonatomic) IBOutlet UILabel *lb_nickName;

@property (weak, nonatomic) IBOutlet UILabel *lb_detailtext;

@property (weak, nonatomic) IBOutlet UILabel *lb_message;

@property (weak, nonatomic) IBOutlet UICollectionView *appriseCollectionView;

@property (copy ,nonatomic) NSString * imgurl;
 
@property (nonatomic ,strong) Findlistreviews * infoList ;

@property (nonatomic ,strong) NSMutableArray  * mutImgArray;



@end
