//
//  ShopCarSectionHeadViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/7.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShopCarSectionHeadViewCell.h"
@interface ShopCarSectionHeadViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *gotoStoreView;

- (IBAction)selectedAll:(id)sender;
- (IBAction)editedAll:(id)sender;

@end

@implementation ShopCarSectionHeadViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [_gotoStoreView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToStore)]];
}
- (void)goToStore{
    
}

//全选
- (IBAction)selectedAll:(UIButton*)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(selectOrEditGoods:)]) {
        [self.delegate selectOrEditGoods:sender];
    }

}
//编辑
- (IBAction)editedAll:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(selectOrEditGoods:)]) {
        [self.delegate selectOrEditGoods:sender];
    }
}


- (void)setSelectBtnState:(BOOL)state{
    _selectBtn.selected = state;
}
//设置全选按钮的状态
- (void)setHeaderViewAllSelectBtnState:(BOOL)headerViewAllSelectBtnState{
    _headerViewAllSelectBtnState = headerViewAllSelectBtnState;
    _selectBtn.selected = headerViewAllSelectBtnState;
}

//设置编辑按钮的状态
- (void)setHeaderViewEditBtnState:(BOOL)headerViewEditBtnState{
    _headerViewEditBtnState = headerViewEditBtnState;
    _editBtn.selected = headerViewEditBtnState;
}

@end
