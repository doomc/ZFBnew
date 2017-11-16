//
//  SkuFooterReusableView.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SkuFooterReusableViewDelegate <NSObject>

-(void)addCount:(NSInteger)count;

@end
@interface SkuFooterReusableView : UIView

@property (assign, nonatomic) id <SkuFooterReusableViewDelegate> countDelegate;

@property (weak, nonatomic) IBOutlet UIButton *addAction;

@property (weak, nonatomic) IBOutlet UIButton *reduceAction;

@property (weak, nonatomic) IBOutlet UILabel *lb_count;

@property (nonatomic ,assign) NSInteger minNum;//最小数


@end
