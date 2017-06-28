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
    
    self.img_headview.clipsToBounds = YES;
    self.img_headview.layer.cornerRadius = 40;
 
    self.img_headview.layer.borderWidth = 0.5;
    self.img_headview.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
 
    [self.img_headview setImage:[UIImage  circleImage:@"11.png"]];
    [self.img_headview.image circleImage];
    
    
    

    //点击头像
    UITapGestureRecognizer * img_headviewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickimgheadviewGestureRecognizer:)];
    img_headviewtap.delegate = self;
    img_headviewtap.numberOfTapsRequired = 1;
    img_headviewtap.numberOfTouchesRequired =1;
    [self.img_headview addGestureRecognizer:img_headviewtap];
    self.img_headview.userInteractionEnabled =YES;
    

    [self.btn_login addTarget:self action:@selector(btn_loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btn_regist addTarget:self action:@selector(btn_registAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)btn_loginAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickLoginAction:)]) {
    
        [self.delegate didClickLoginAction:sender];
    }

}
-(void)btn_registAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickRegisterAction:)]) {
        
        [self.delegate didClickRegisterAction:sender];
    }
}
-(void)didClickimgheadviewGestureRecognizer:(UITapGestureRecognizer *)tap{
    //点击头像
    if ([self.delegate respondsToSelector:@selector(didClickHeadImageViewAction:)]) {
        [self.delegate didClickHeadImageViewAction:tap];
    }
}


- (IBAction)didClickCollectAction:(id)sender {
    
    //收藏手势
    if ([self.delegate respondsToSelector:@selector(didClickCollectAction:)]) {
        [self.delegate didClickCollectAction:sender];
    }
    

}
- (IBAction)didClickHistorytAction:(id)sender {
    
    //浏览足记
    if ([self.delegate respondsToSelector:@selector(didClickHistorytAction:)]) {
        [self.delegate didClickHistorytAction:sender];
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
