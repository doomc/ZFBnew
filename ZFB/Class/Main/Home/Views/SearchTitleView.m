
//
//  SearchTitleView.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchTitleView.h"
@interface SearchTitleView ()

//外边框
@property (nonatomic , strong) UIView * boardView;

@end

@implementation SearchTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self titleViewUI];
    }
    return self;
}
-(UIView *)boardView
{
    _boardView = [[UIView alloc]initWithFrame:self.frame];
    _boardView.layer.masksToBounds = YES;
    _boardView.layer.cornerRadius = 4;
    _boardView.layer.borderWidth = 1;
    _boardView.layer.borderColor = HEXCOLOR(0x999999).CGColor;
    return _boardView;
}
-(void)titleViewUI
{
    [self addSubview:self.boardView];
    
    UIButton  * typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [typeBtn setTitle:@"商品" forState:UIControlStateNormal];
    [typeBtn setImage:[UIImage imageNamed:@"down3"] forState:UIControlStateNormal];
    [typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [typeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];

}


@end
