//
//  CommonClassTypeView.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommonClassTypeViewDelegate <NSObject>

//获取1级列表的id
-(void)didClassOnetypeId:(NSString *) typeId AndTitle:(NSString * )title;

//获取二级列表id
-(void)didClassTwotypeId:(NSString *) typeId AndTitle:(NSString * )title;

//关闭视图
-(void)removeFromtoSuperView;
//选择后的视图
-(void)selectedAfter;


@end

@interface CommonClassTypeView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

-(void)reloadCollctionView;

@property (assign ,nonatomic) id <CommonClassTypeViewDelegate> delegate;

@property (nonatomic , strong) NSMutableArray  * brandListArray;
@property (nonatomic , strong) NSMutableArray  * classListArray;

@property (nonatomic , assign) BOOL  isThemeType;//同外界



@end
