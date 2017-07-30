//
//  BusinessServicPopView.h
//  ZFB
//
//  Created by 熊维东 on 2017/7/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BusinessServicPopViewDelegate <NSObject>

-(void)sendTitle:(NSString *)title businessServicType:(BusinessServicType)type;


@end
@interface BusinessServicPopView : UIView


-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;

@property (nonatomic, strong) NSArray *titleArray;


@property (nonatomic, assign) id<BusinessServicPopViewDelegate> delegate;


@end
