//
//  StoreCouponTableCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StoreCouponTableCellDelegate <NSObject>

-(void)didClickCouponlistIndex:(NSInteger)index andCouponId:(NSString *)couponId;

@end
@interface StoreCouponTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *couponCollectionView;

@property (strong, nonatomic) NSMutableArray * couponArray;

@property (assign, nonatomic) id <StoreCouponTableCellDelegate> delegate;

-(void)reload_CollectionView;

@end
