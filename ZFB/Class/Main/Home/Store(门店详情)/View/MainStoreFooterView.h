//
//  MainStoreFooterView.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MainStoreFooterViewDelegate <NSObject>

@optional
 

//联系卖家
-(void)didClickContactStore;

//店铺信息
-(void)didClickStoreInfo;

//到店铺导航
-(void)didClickMapNavgation;

@end

@interface MainStoreFooterView : UIView

-(instancetype)initWithFooterViewFrame:(CGRect)frame;

@property (nonatomic , assign) id <MainStoreFooterViewDelegate> delegate;


@end
