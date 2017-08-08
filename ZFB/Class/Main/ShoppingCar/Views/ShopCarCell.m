//
//  ShopCarCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShopCarCell.h"
@interface ShopCarCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *changeCountField;
@property (weak, nonatomic) IBOutlet UIButton *reducBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsPro;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnRight;

- (IBAction)selectGoodsBtnClick:(id)sender;
- (IBAction)deleteShopGoodBtnClick:(id)sender;

@end
@implementation ShopCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.shopImageView.clipsToBounds = YES;
    self.shopImageView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    self.shopImageView.layer.borderWidth = 0.5;
    
    _changeCountField.delegate = self;
}

-(void)setGoodslist:(ShopGoodslist *)goodslist
{
    _goodslist = goodslist;
    _shopNameLabel.text = goodslist.goodsName;
    _shopPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",goodslist.storePrice];
    //规格需要自己从json数组中取出
    _goodsPro.text = [NSString stringWithFormat:@"%@",goodslist.goodsName];
    //数量
    _changeCountField.text = [NSString stringWithFormat:@"%ld",goodslist.goodsCount];
    
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:goodslist.coverImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    
}
// 改变商品数量 1 减少  2 增加
- (IBAction)changeShopNumClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            if ([_changeCountField.text intValue] == 1) {
                
                _reducBtn.userInteractionEnabled = NO;
            }else{
                _changeCountField.text = [NSString stringWithFormat:@"%d",[_changeCountField.text intValue] - 1];
            }
            
        }
            break;
        case 2:
        {
            //没有库存计算
 
            _changeCountField.text = [NSString stringWithFormat:@"%d",[_changeCountField.text intValue] + 1];
        }
            break;
 
    }
    
    _goodslist.goodsCount = [_changeCountField.text integerValue];
    
    if ([self.delegate respondsToSelector:@selector(changeShopCount:)]) {
        [self.delegate changeShopCount:sender];
    }
}
//选中商品按钮
- (IBAction)selectGoodsBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(cellSelectBtnClick:)]) {
        [self.delegate cellSelectBtnClick:sender];
    }
}
//删除商品按钮
- (IBAction)deleteShopGoodBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(deleteShopGoodTouch:)]) {
        [self.delegate deleteShopGoodTouch:sender];
    }
}
#pragma mark -- UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(tableViewScroll:)]) {
        [self.delegate tableViewScroll:textField];
    }
}
- (void)textFieldDidChange:(UITextField *)textField{

    _goodslist.goodsCount = [textField.text integerValue];
}

//设置选择按钮的状态
- (void)setShopCellSelectBtnState:(BOOL)shopCellSelectBtnState{
    _shopCellSelectBtnState = shopCellSelectBtnState;
    _selectBtn.selected = shopCellSelectBtnState;
}

//设置编辑状态
- (void)setShopCellEditState:(BOOL)shopCellEditState{
    _shopCellEditState = shopCellEditState;
    _addBtn.hidden = !shopCellEditState;
    _changeCountField.hidden = !shopCellEditState;
    _reducBtn.hidden = !shopCellEditState;
}

//设置删除按钮的位置和编辑状态
- (void)setShopCellDeleteBtnState:(BOOL)shopCellDeleteBtnState{
    _shopCellDeleteBtnState = shopCellDeleteBtnState;
    if (shopCellDeleteBtnState == YES) {
        [UIView animateWithDuration:0.3f animations:^{
            _deleteBtnRight.constant = 50;
            _deleteBtn.hidden = NO;
            [_deleteBtn layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3f animations:^{
            _deleteBtnRight.constant = 0;
            _deleteBtn.hidden = YES;
            [_deleteBtn layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

//返回商品价格
- (NSInteger)getShopPrice{
    NSString *priceString = [_shopPriceLabel.text substringFromIndex:1];
    return [priceString integerValue];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
