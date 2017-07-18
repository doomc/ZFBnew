//
//  FeedPickerCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FeedPickerCollectionViewCell.h"
#import <ReactiveCocoa.h>

@implementation FeedPickerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_delete_button addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setCurImageItem:(MPImageItemModel *)curImageItem
{
    _curImageItem=curImageItem;
    if (_curImageItem) {
        
        RAC(self.addImgView, image) = [RACObserve(self.curImageItem, thumbnailImage) takeUntil:self.rac_prepareForReuseSignal];
        _delete_button.hidden = NO;
        self.addImgView.image = _curImageItem.thumbnailImage;
    }
    else
    {
        _addImgView.image = [UIImage imageNamed:@"plus"];
        if (_delete_button) {
            _delete_button.hidden = YES;
        }
    }
}
-(void)deleteImage {
    
    if (_deleteImageBlock) {
        _deleteImageBlock(_curImageItem);
    }
}
@end
