//
//  ZFCollectBarView.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCollectEditCell;

@protocol ZFCollectBarViewDelegate <NSObject>

-(void)didClickCancelCollect:(ZFCollectEditCell *)cell;
/**
 *  全选
 *
 *  @param sender  sender
 */
-(void)didClickSelectedAll:(UIButton*)sender;


@end
@interface ZFCollectBarView : UIView

@property (assign ,nonatomic)id <ZFCollectBarViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *allChoose_btn;

@property (weak, nonatomic) IBOutlet UIButton *cancelCollect_btn;

@property (strong,nonatomic) NSIndexPath *indexPath;


@end
