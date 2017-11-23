//
//  ScreenTypeView.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScreenTypeViewDelegete <NSObject>

//获取当前的条件
-(void)didClickIndex:(NSInteger)index ;

@end


@interface ScreenTypeView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

-(void)reloadData;

@property (assign ,nonatomic) id <ScreenTypeViewDelegete> delegate;

@property (nonatomic , strong) NSArray  * titles;


@end
