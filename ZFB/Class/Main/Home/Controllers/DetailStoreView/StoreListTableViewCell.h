//
//  StoreListTableViewCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/9/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StoreListTableViewCellDelegate <NSObject>

@required
/**
 点击每个Item的点击事件

 @param goodId 商品id
 @param indexItem 当前下标
 */
-(void)didClickCollectionCellGoodId:(NSString *)goodId withIndexItem:(NSInteger )indexItem;

@end

@interface StoreListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UICollectionView *storeListCollectionView;

@property (strong , nonatomic) NSMutableArray * storeListArray;

@property (assign , nonatomic) id <StoreListTableViewCellDelegate> collectionDelegate;

@property (assign , nonatomic) NSInteger indexItem;

 
-(void)reloadCollectionView;


@end
