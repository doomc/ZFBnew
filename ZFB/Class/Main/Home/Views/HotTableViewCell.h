//
//  HotCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HotTableViewCellDelegate <NSObject>

-(void)pushToDetailVCWithGoodsID :(NSString *) goodsId;

@end
@interface HotTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (assign, nonatomic) id <HotTableViewCellDelegate> delegate;
@property (weak  , nonatomic) IBOutlet UICollectionView *HotcollectionView;
@property (strong, nonatomic )NSMutableArray * hotArray;//热卖



@end
