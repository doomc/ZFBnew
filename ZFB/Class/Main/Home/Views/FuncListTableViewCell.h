//
//  FuncListTableViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FuncListTableViewCell;
@protocol FuncListTableViewCellDeleagte  <NSObject>

-(void)seleteItemGoodsTypeId: (NSString *)goodsTypeId withIndexrow:(NSInteger )indexPathRow;


@end
@interface FuncListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView * funcCollectionView;

@property (strong,nonatomic) NSMutableArray * dataArray;//数据源

@property (assign,nonatomic) id <FuncListTableViewCellDeleagte> funcDelegate;

-(void)reloadColltionView;


@end
