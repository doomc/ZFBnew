//
//  ZFAppraiseSectionCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppraiseSectionCellDelegate <NSObject>

-(void)allbuttonSelect:(UIButton *)button;
-(void)goodPrisebuttonSelect:(UIButton *)button;
-(void)badPrisebuttonSelect:(UIButton *)button;
-(void)haveImgbuttonSelect:(UIButton *)button;


@end
@interface ZFAppraiseSectionCell : UITableViewCell

@property (nonatomic, strong)  id <AppraiseSectionCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *all_btn;

@property (weak, nonatomic) IBOutlet UIButton *goodAppraise_btn;

@property (weak, nonatomic) IBOutlet UIButton *bad_btn;

@property (weak, nonatomic) IBOutlet UIButton *haveImage_btn;

@end
