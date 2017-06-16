//
//  FuncListTableViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuncListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView * funcCollectionView;

@property (strong,nonatomic)NSMutableArray * dataArray;//数据源
@property (strong,nonatomic)NSMutableArray * funcUrlArray;//功能列表url
@property (strong,nonatomic)NSMutableArray * funcNameArray;//功能name
@property (strong,nonatomic)NSMutableArray * funcpidArray;//功能id


@end
