//
//  CQPlaceholderView.m
//  CommonPlaceholderView
//
//  Created by 蔡强 on 2017/5/15.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "CQPlaceholderView.h"

@implementation CQPlaceholderView

#pragma mark - 构造方法
/**
 构造方法
 
 @param frame 占位图的frame
 @param type 占位图的类型
 @param delegate 占位图的代理方
 @return 指定frame、类型和代理方的占位图
 */
- (instancetype)initWithFrame:(CGRect)frame type:(CQPlaceholderViewType)type delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        // 存值
        _type = type;
        _delegate = delegate;
        // UI搭建
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI搭建
/** UI搭建 */
- (void)setUpUI{
    self.backgroundColor = [UIColor whiteColor];
    UIFont *font = SYSTEMFONT(14);
    //------- 图片在正中间 -------//
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 75, self.frame.size.height / 2 - 75, 150, 150)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    
    //------- 说明label在图片下方 -------//
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, self.frame.size.width, 20)];
    descLabel.textColor = HEXCOLOR(0x8d8d8d);
    descLabel.font = font;
    [self addSubview:descLabel];
    descLabel.textAlignment = NSTextAlignmentCenter;
    
    //------- 按钮在说明label下方 -------//
//    UIButton *reloadButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 60, CGRectGetMaxY(descLabel.frame) + 5, 120, 25)];
//    [self addSubview:reloadButton];
//    reloadButton.titleLabel.font = font;
//    [reloadButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
//    [reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//
    //------- 根据type创建不同样式的UI -------//
    switch (_type) {
        case CQPlaceholderViewTypeNoNetwork: // 没网
        {
            imageView.image = [UIImage imageNamed:@"no_data"];
            descLabel.text = @"没网，不约";
         }
            break;
            
        case CQPlaceholderViewTypeNoOrder: // 没订单
        {
            imageView.image = [UIImage imageNamed:@"no_order"];
            descLabel.text = @"暂无订单";
        }
            break;
            
        case CQPlaceholderViewTypeNoGoods: // 没商品
        {
            imageView.image = [UIImage imageNamed:@"placeholder"];
            descLabel.text = @"没有商品";
        }
            break;
        case CQPlaceholderViewTypeNoComments: // 评论
        {
            imageView.image = [UIImage imageNamed:@"nomessage"];
            descLabel.text = @"没有评论";
        }
            break;
        case CQPlaceholderViewTypeNoCoupon: // 优惠券
        {
            imageView.image = [UIImage imageNamed:@"no_coupon"];
            descLabel.text = @"没有优惠券";
        }
            break;
        case CQPlaceholderViewTypeNoSearchData: // 没有搜索到
        {
            imageView.image = [UIImage imageNamed:@"no_data2"];
            descLabel.text = @"没有搜索内容";
        }
            break;

            
        default:
            break;
    }
}

#pragma mark - 重新加载按钮点击
/** 重新加载按钮点击 */
- (void)reloadButtonClicked:(UIButton *)sender{
    // 代理方执行方法
    if ([_delegate respondsToSelector:@selector(placeholderView:reloadButtonDidClick:)]) {
        [_delegate placeholderView:self reloadButtonDidClick:sender];
    }
    // 从父视图上移除
    [self removeFromSuperview];
}

@end
