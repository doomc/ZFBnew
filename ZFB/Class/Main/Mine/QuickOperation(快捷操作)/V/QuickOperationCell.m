//
//  QuickOperationCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "QuickOperationCell.h"
@interface QuickOperationCell ()<UIGestureRecognizerDelegate>

@end

@implementation QuickOperationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    self.checkedView.hidden = YES;
    
    
    //我要开店
    UITapGestureRecognizer * tapOpen = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openStore:)];
    tapOpen.delegate = self;
    self.iWillOpenStoreView.userInteractionEnabled = YES;
    [self.iWillOpenStoreView addGestureRecognizer:tapOpen];
    
    //我要开店
    UITapGestureRecognizer * tapSend = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendGoods:)];
    tapSend.delegate = self;
    self.iWillSendView.userInteractionEnabled = YES;
    [self.iWillSendView addGestureRecognizer:tapSend];

#pragma mark-  已审核
    //切换商户
    UITapGestureRecognizer * tapChange= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChange:)];
    tapChange.delegate = self;
    self.changeIdView.userInteractionEnabled = YES;
    [self.changeIdView addGestureRecognizer:tapChange];
    
    //切换商户
    UITapGestureRecognizer * tapEvalute = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvalute:)];
    tapEvalute.delegate = self;
    self.myEvaluate.userInteractionEnabled = YES;
    [self.myEvaluate addGestureRecognizer:tapEvalute];
    
    //我的动态
    UITapGestureRecognizer * tapDynamic= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDynamic:)];
    tapDynamic.delegate = self;
    self.myDynamic.userInteractionEnabled = YES;
    [self.myDynamic addGestureRecognizer:tapDynamic];
    
}



#pragma mark-  已审核
//切换到商户端 /配送端
-(void)tapChange:(UITapGestureRecognizer *)ges
{
    if ([self.delegate respondsToSelector:@selector(didClickChangeID)]) {
        [self.delegate didClickChangeID];
    }
}
//我的评价
-(void)tapEvalute:(UITapGestureRecognizer *)ges
{
    if ([self.delegate respondsToSelector:@selector(didClickMyevalution)]) {
        [self.delegate didClickMyevalution];
    }
}
//我的动态
-(void)tapDynamic:(UITapGestureRecognizer *)ges
{
    if ([self.delegate respondsToSelector:@selector(didClickmyDynamic)]) {
        [self.delegate didClickmyDynamic];
    }
}
#pragma mark-  未审核
//我要开店
-(void)openStore:(UITapGestureRecognizer *)ges
{
    if ([self.delegate respondsToSelector:@selector(didClickOpenStore)]) {
        [self.delegate didClickOpenStore];
    }
}
//我要配送
-(void)sendGoods:(UITapGestureRecognizer *)ges
{
    if ([self.delegate respondsToSelector:@selector(didClickSendGoods)]) {
        [self.delegate didClickSendGoods];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
