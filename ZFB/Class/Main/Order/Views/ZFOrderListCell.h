//
//  ZFOrderListCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZFOrderListCellDelegate <NSObject>

-(void)didclickPhotoPicker:(NSInteger )index images:(NSArray *)images;

@end

@interface ZFOrderListCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *order_collectionCell;
@property (weak, nonatomic) IBOutlet UILabel *lb_totalNum;
@property (strong, nonatomic) NSMutableArray * listArray;

@property (assign, nonatomic) id <ZFOrderListCellDelegate> delegate;

@end
