//
//  ZFCollectEditCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFCollectEditCell.h"

@implementation ZFCollectEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.img_editView.clipsToBounds = YES;
    self.img_editView.layer.borderWidth = 0.5;
    self.img_editView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;


    if ([self.delegate  respondsToSelector:@selector(deleteCell:)]) {
       
        [self.delegate deleteCell:self ];
    }
}

-(void)setGoodlist:(Cmkeepgoodslist *)goodlist
{
    _goodlist = goodlist;
 
    _collectID = _goodlist.cartItemId;
    _goodsID = [NSString stringWithFormat:@"%ld",_goodlist.goodId];
    self.lb_price.text = [NSString stringWithFormat:@"¥%.2f", _goodlist.storePrice];
    self.lb_title.text = [NSString stringWithFormat:@"%@", _goodlist.goodName];
    [self.img_editView sd_setImageWithURL:[NSURL URLWithString:_goodlist.coverImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.selecet_btn.selected = _goodlist.isCollectSelected;
}

-(void)setStoreList:(Cmkeepgoodslist *)storeList{
    _storeList = storeList;
    _collectID = storeList.cartItemId;
    _storeID = [NSString stringWithFormat:@"%ld",storeList.goodId];
    self.lb_title.text = [NSString stringWithFormat:@"%@", storeList.storeName];
    [self.img_editView sd_setImageWithURL:[NSURL URLWithString:storeList.coverImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.selecet_btn.selected = storeList.isCollectSelected;
    
    //初始化五星好评控件
    self.starView.needIntValue = NO;//是否整数显示，默认整数显示
    self.starView.canTouch     = NO;//是否可以点击，默认为NO
    CGFloat number           = [storeList.starLevel floatValue];
    self.starView.scoreNum     = [NSNumber numberWithFloat:number ];//星星显示个数
    self.starView.normalColorChain(RGBA(244, 244, 244, 1));
    self.starView.highlightColorChian(HEXCOLOR(0xfe6d6a));
    
    
}

// 商品选择的按钮回调
- (IBAction)clickSelected:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsSelected:isSelected:)])
    {  
        [self.delegate goodsSelected :self isSelected:sender.selected];
        
    }
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
