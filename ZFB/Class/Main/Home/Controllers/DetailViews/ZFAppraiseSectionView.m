//
//  ZFAppraiseSectionView.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFAppraiseSectionView.h"

@implementation ZFAppraiseSectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIFont * font = [UIFont systemFontOfSize:12];

        self.all_btn.clipsToBounds = YES;
        NSString * allTitle  = @"全部(144)";
        self.all_btn.layer.cornerRadius = 4;
        [self.all_btn setTitle:allTitle forState:UIControlStateNormal];
        CGSize allSize = [allTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat allWidth  = allSize.width;
        self.all_btn.frame = CGRectMake(0, 0, allWidth +10, 30);
        
        self.goodAppraise_btn.clipsToBounds = YES;
        NSString * goodTitle  = @"好评(144)";
        self.goodAppraise_btn.layer.cornerRadius = 4;
        [self.goodAppraise_btn setTitle:allTitle forState:UIControlStateNormal];
        CGSize goodSize = [goodTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat goodWidth  = goodSize.width;
        self.goodAppraise_btn.frame = CGRectMake(0, 0, goodWidth +10, 30);
        
        self.bad_btn.clipsToBounds = YES;
        NSString * badTitle  = @"差评(50)";
        self.bad_btn.layer.cornerRadius = 4;
        [self.bad_btn setTitle:badTitle forState:UIControlStateNormal];
        CGSize badSize = [badTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat badWidth  = badSize.width;
        self.bad_btn.frame = CGRectMake(0, 0, badWidth +10, 30);
        
        self.haveImage_btn.clipsToBounds = YES;
        NSString * imgitle  = @"有图(23)";
        self.haveImage_btn.layer.cornerRadius = 4;
        [self.haveImage_btn setTitle:imgitle forState:UIControlStateNormal];
        CGSize imgSize = [imgitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
        CGFloat imgWidth  = imgSize.width;
        self.haveImage_btn.frame = CGRectMake(0, 0, imgWidth +10, 30);
        
        
    
        [self.all_btn addTarget:self action:@selector(AllAppraiseTarget:) forControlEvents:UIControlEventTouchUpInside];
        [self.goodAppraise_btn addTarget:self action:@selector(AllAppraiseTarget:) forControlEvents:UIControlEventTouchUpInside];
        [self.bad_btn addTarget:self action:@selector(AllAppraiseTarget:) forControlEvents:UIControlEventTouchUpInside];
        [self.haveImage_btn addTarget:self action:@selector(AllAppraiseTarget:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)AllAppraiseTarget:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(whichOneDidClickAppraise:)]) {
        
        [self.delegate whichOneDidClickAppraise:sender];
    }
  
    NSLog(@"评价 +++++++");
}
@end
