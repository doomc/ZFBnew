//
//  CollectionViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "CollectionCategoryModel.h"
#import "ZFCollectionViewCell.h"
@interface ZFCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *name;

@end

@implementation ZFCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.width - 4)];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageV];

        self.name = [[UILabel alloc] initWithFrame:CGRectMake(2, self.frame.size.width + 2, self.frame.size.width - 4, 20)];
        self.name.font = [UIFont systemFontOfSize:13];
        self.name.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = HEXCOLOR(0xfefefe);
        [self.contentView addSubview:self.name];
    }
    return self;
}

- (void)setGoodlist:(Nexttypelist *)goodlist
{
    _goodlist = goodlist;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:goodlist.iconUrl] placeholderImage:nil];
    self.name.text = goodlist.name;
}

@end
