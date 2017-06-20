//
//  ZFAppraiseSectionView.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  AppraiseSectionViewDelegate <NSObject>

@optional

-(void)whichOneDidClickAppraise:(UIButton *)sender;

@end
@interface ZFAppraiseSectionView : UIView

@property (assign, nonatomic) id <AppraiseSectionViewDelegate> delegate ;

@property (weak, nonatomic) IBOutlet UIButton *all_btn;

@property (weak, nonatomic) IBOutlet UIButton *goodAppraise_btn;

@property (weak, nonatomic) IBOutlet UIButton *bad_btn;

@property (weak, nonatomic) IBOutlet UIButton *haveImage_btn;

@end
