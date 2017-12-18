//
//  SearchStoreTypeView.h
//  ZFB
//
//  Created by  展富宝  on 2017/12/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchStoreTypeViewDelegate <NSObject>

@required
//搜索门店
-(void)selectStoreSearchType:(StoreSearchType)searchType ;

@end
@interface SearchStoreTypeView : UIView

@property (assign , nonatomic) id <SearchStoreTypeViewDelegate> delegate;
@property (assign , nonatomic) StoreSearchType searchType;//门店选择类型

@property (weak, nonatomic) IBOutlet UIButton *brandBtn;
@property (weak, nonatomic) IBOutlet UIButton *distenceBtn;


-(instancetype)initWithSearchStoreViewFrame:(CGRect)frame;


@end
