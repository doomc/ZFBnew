//
//  ZFSaleAfterSearchCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SaleAfterSearchCellDelegate <NSObject>


///点击搜索
-(void)didClickSearchButtonSearchText:(NSString *)searchText;


@end
@interface ZFSaleAfterSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgViewCorner;

@property (weak, nonatomic) IBOutlet UITextField *tf_search;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (assign , nonatomic) id <SaleAfterSearchCellDelegate>delegate;

@end
