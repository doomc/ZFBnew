
//
//  SearchTitleView.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchTitleView.h"
@interface SearchTitleView ()<UITextFieldDelegate>

//外边框
@property (nonatomic , strong) UIView * boardView;

@end

@implementation SearchTitleView

-(instancetype)initWithTitleViewFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self titleViewUI];
    }
    return self;
}

-(void)titleViewUI
{
    UIFont * font = SYSTEMFONT(14);
    _boardView = [[UIView alloc]initWithFrame:self.frame];
    _boardView.layer.masksToBounds = YES;
    _boardView.layer.cornerRadius = 4;
    _boardView.layer.borderWidth = 1;
    _boardView.layer.borderColor = HEXCOLOR(0x999999).CGColor;
    [self addSubview:_boardView];
    
    _selectTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectTypeBtn.frame = CGRectMake(0, 0, 60, 36);
    _selectTypeBtn.titleLabel.font = SYSTEMFONT(12);
    [_selectTypeBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_selectTypeBtn setTitle:@"商品" forState:UIControlStateNormal];
    [_selectTypeBtn setImage:[UIImage imageNamed:@"down3"] forState:UIControlStateNormal];
    [_selectTypeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [_selectTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [_selectTypeBtn addTarget:self action:@selector(didselectedTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.boardView addSubview:_selectTypeBtn];
    
    _tf_search = [[UITextField alloc]initWithFrame:CGRectMake(50+10, 0, self.frame.size.width -40 -60, 36)];
    _tf_search.placeholder = @"搜索商品";
    _tf_search.delegate  = self;
    _tf_search.font = font;
    _tf_search.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.boardView addSubview:_tf_search];
    
    UIButton * searchBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(self.frame.size.width -40, 0, 36, 36);
    [searchBtn setImage:[UIImage imageNamed:@"search2"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(didSearchbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.boardView addSubview:searchBtn];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //跳转
}

-(void)didSearchbtn:(UIButton*)sender
{
    [_tf_search resignFirstResponder];
    NSLog(@"搜索");
    if ([self.delegate respondsToSelector:@selector(didSearch:)]) {
        [self.delegate didSearch:sender];
    }
}
-(void)didselectedTypeBtn:(UIButton *)sender
{
    [_tf_search resignFirstResponder];
    NSLog(@"选择类型");
    if ([self.delegate respondsToSelector:@selector(didSearchType:)]) {
        [self.delegate didSearchType:sender];
    }
}
@end
