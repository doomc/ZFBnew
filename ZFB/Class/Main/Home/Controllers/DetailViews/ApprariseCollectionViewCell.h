//
//  ApprariseCollectionViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppraiseModel.h" 
@protocol ApprariseCollectionViewCellDelegate <NSObject>

@end
@interface ApprariseCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_CollectionView;

@property(nonatomic,strong)AppraiseModel * appModel ;

@property (nonatomic,assign) id <ApprariseCollectionViewCellDelegate>delegate;


@end
