//
//  SearchTypeView.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchTypeViewDelegate <NSObject>

@required

-(void)selectGoodsSearchType:(GoodsSearchType)searchType ;

@end
@interface SearchTypeView : UIView

@property (assign , nonatomic) id <SearchTypeViewDelegate> delegate;
@property (assign , nonatomic) GoodsSearchType searchType;//商品选择类型

@property (weak, nonatomic) IBOutlet UIButton *brandBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *salesBtn;

-(instancetype)initWithSearchTypeViewFrame:(CGRect)frame;


@end
