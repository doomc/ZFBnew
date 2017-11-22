//
//  AllGoodsSelectTypeCollectionCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  SelectTypeCollectionCellDelegate <NSObject>
@required

//选择类型
-(void)selectStoreType:(StoreScreenType)type flag :(NSInteger)flag;


@end
@interface AllGoodsSelectTypeCollectionCell : UICollectionViewCell

//综合
@property (weak, nonatomic) IBOutlet UIButton *comprehensive_btn;
//销量
@property (weak, nonatomic) IBOutlet UIButton *sales_btn;
//最细
@property (weak, nonatomic) IBOutlet UIButton *latest_btn;
//价格
@property (weak, nonatomic) IBOutlet UIButton *price_btn;

@property (assign, nonatomic) id  <SelectTypeCollectionCellDelegate> delegate;

@property (nonatomic, assign) StoreScreenType selectedType;

@property (nonatomic, assign) NSInteger flag;// 1  升序  2降序

@end
