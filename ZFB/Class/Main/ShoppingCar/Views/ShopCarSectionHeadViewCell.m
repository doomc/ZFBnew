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
//进入店
- (void)goToStore{
    NSLog(@"进入店铺");
}
-(void)setStorelist:(Shoppcartlist *)storelist
{
    _storelist = storelist;
    self.storeName.text = storelist.storeName;
    
}

- (void)setSelectBtnTag:(NSInteger)selectBtnTag{
    if (_selectBtn.tag == selectBtnTag) {
        
    }else{
        _selectBtnTag = selectBtnTag;
        _selectBtn.tag = selectBtnTag;
    }
    _selectBtnTag = selectBtnTag;
    _selectBtn.tag = selectBtnTag;
}

- (void)setEditBtnTag:(NSInteger)editBtnTag{
    if (_editBtn.tag == editBtnTag) {
        
    }else{
        _editBtnTag = editBtnTag;
        _editBtn.tag = editBtnTag;
    }
    
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


#pragma mark  - 头部视图事件
// 点击section头部选择按钮回调
- (IBAction)chooseSectionSelected:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopStoreSelected:)]) {
        
        [self.delegate shopStoreSelected:self.sectionIndex];
    }
}
// 进入店铺
- (IBAction)enterStoreAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterStoreIndex:)]) {
        
        [self.delegate enterStoreIndex:self.sectionIndex];
    }
}

// 头部编辑按钮回调
- (IBAction)clickEditing:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopCarEditingSelected:)]) {
        [self.delegate shopCarEditingSelected:self.sectionIndex];
    }
}

//设置选择状态
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
