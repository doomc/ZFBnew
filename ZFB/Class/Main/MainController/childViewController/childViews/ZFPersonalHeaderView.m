//
//  ZFPersonalHeaderView.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFPersonalHeaderView.h"

@interface ZFPersonalHeaderView ()<UIGestureRecognizerDelegate>


@end
@implementation ZFPersonalHeaderView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.img_headview.layer.cornerRadius = 40;

    //点击头像
    UITapGestureRecognizer * img_headviewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickimg_headviewGestureRecognizer:)];
    img_headviewtap.delegate = self;
    img_headviewtap.numberOfTapsRequired = 1;
    img_headviewtap.numberOfTouchesRequired =1;
    [self.collectTagView addGestureRecognizer:img_headviewtap];
    
    //收藏手势
    UITapGestureRecognizer * tapSingle1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickCollectActionGestureRecognizer:)];
    tapSingle1.delegate = self;
    tapSingle1.numberOfTapsRequired = 1;
    tapSingle1.numberOfTouchesRequired =1;
    
    [self.collectTagView addGestureRecognizer:tapSingle1];
    
    //浏览足记
    UITapGestureRecognizer * tapSingle2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickHistorytActionGestureRecognizer:)];
    tapSingle2.delegate = self;
    tapSingle2.numberOfTouchesRequired =1;
    tapSingle2.numberOfTapsRequired = 1;
    [self.collectTagView addGestureRecognizer:tapSingle2];
    

}

-(void)didClickimg_headviewGestureRecognizer:(UITapGestureRecognizer*)tap{
    
    if ([self.delegate respondsToSelector:@selector(didClickHeadImageViewAction)]) {
        [self.delegate didClickHeadImageViewAction];
    }
}

-(void)didClickCollectActionGestureRecognizer:(UITapGestureRecognizer *)tap
{
    //收藏手势
    if ([self.delegate respondsToSelector:@selector(didClickCollectAction)]) {
        [self.delegate didClickCollectAction];
    }
   
}

-(void)didClickHistorytActionGestureRecognizer:(UITapGestureRecognizer *)tap
{
    //浏览足记
    if ([self.delegate respondsToSelector:@selector(didClickHistorytAction)]) {
        [self.delegate didClickHistorytAction];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
