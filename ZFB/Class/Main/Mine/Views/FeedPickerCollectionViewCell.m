//
//  FeedPickerCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FeedPickerCollectionViewCell.h"

@implementation FeedPickerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCurImageItem:(MPImageItemModel *)curImageItem
{
    _curImageItem=curImageItem;
    if (_curImageItem) {
        
//        RAC(self.imgView, image) = [RACObserve(self.curImageItem, thumbnailImage) takeUntil:self.rac_prepareForReuseSignal];
//        _deleteBtn.hidden = NO;
        self.addImgView.image = _curImageItem.thumbnailImage;
    }
    else
    {
//        _imgView.image = [UIImage imageNamed:@"btn_addPicture_BgImage"];
//        if (_deleteBtn) {
//            _deleteBtn.hidden = YES;
//        }
    }
}
@end
