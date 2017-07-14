//
//  HotSearchCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "HotSearchCollectionViewCell.h"
#define itemHeight 30
@implementation HotSearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.hotTitle.layer.cornerRadius = 2;
    self.hotTitle.clipsToBounds = YES;
    
 
}

#pragma mark — 实现自适应文字宽度的关键步骤:item的layoutAttributes
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    CGRect frame = [self.hotTitle.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX + 20, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.hotTitle.font,NSFontAttributeName, nil] context:nil];
    
    frame.size.height = itemHeight;
    attributes.frame = frame;
    
    // 如果你cell上的子控件不是用约束来创建的,那么这边必须也要去修改cell上控件的frame才行
    // self.textLabel.frame = CGRectMake(0, 0, attributes.frame.size.width, 30);
    
    return attributes;
}

@end
