//
//  LeftTableViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "LeftTableViewCell.h"

#define defaultColor RGBA(253, 212, 49, 1)

@interface LeftTableViewCell ()

@property (nonatomic, strong) UIView *yellowView;

@end

@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 40)];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont systemFontOfSize:14];
        self.name.textColor = RGBA(130, 130, 130, 1);
        self.name.highlightedTextColor = defaultColor;
        [self.contentView addSubview:self.name];

        self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 5, 50)];
        self.yellowView.backgroundColor = defaultColor;
        [self.contentView addSubview:self.yellowView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state

    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0 alpha:0.1];
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
}

@end
