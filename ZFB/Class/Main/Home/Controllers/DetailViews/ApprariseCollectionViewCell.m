//
//  ApprariseCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ApprariseCollectionViewCell.h"

@implementation ApprariseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setAppModel:(AppraiseModel *)appModel
{
    //  解析需要的数据
    self.img_CollectionView.image = appModel.image;
    
}
@end