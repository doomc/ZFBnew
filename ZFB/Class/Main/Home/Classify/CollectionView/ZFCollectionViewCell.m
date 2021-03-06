//
//  CollectionViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//

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
        
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(((KScreenW - 80) /3.0 )/2.0 - 30
                                                                    , 5, 50,50)];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageV];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(2,10+50, self.frame.size.width - 4, 20)];
        self.name.font = [UIFont systemFontOfSize:12];
        self.name.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = HEXCOLOR(0xfefefe);
        [self.contentView addSubview:self.name];

    }
    return self;
}

- (void)setGoodlist:(Nexttypelist *)goodlist
{
    _goodlist = goodlist;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:goodlist.iconUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];
    self.name.text = goodlist.name;
}

@end
