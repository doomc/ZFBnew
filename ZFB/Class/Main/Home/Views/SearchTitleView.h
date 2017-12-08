//
//  SearchTitleView.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchTitleViewDelegate <NSObject>
@optional

//选择类型
-(void)didSearchType:(UIButton *)sender;

//搜索
-(void)didSearch:(UIButton *)sender;

@end
@interface SearchTitleView : UIView

@property (nonatomic , strong)  UITextField * tf_search ;
@property (nonatomic , strong)  UIButton * selectTypeBtn ;
@property (nonatomic , assign)  id <SearchTitleViewDelegate> delegate ;

-(instancetype)initWithTitleViewFrame:(CGRect)frame;

@end
