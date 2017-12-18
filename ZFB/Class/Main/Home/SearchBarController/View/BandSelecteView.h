//
//  BandSelecteView.h
//  ZFB
//
//  Created by  展富宝  on 2017/12/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BandSelecteViewDelegate <NSObject>


/**
 获取到 对应的-品牌id 品牌名
 
 @param index 当前错标
 @param brandId 品牌id
 @param brandName 品牌name
 */
-(void)didSelectedIndex:(NSInteger )index brandId :(NSString *)brandId brandName :(NSString *)brandName;

//取消操作
-(void)didClickCancel;

//确定操作
-(void)didClickConfirm;

@end

@interface BandSelecteView : UIView


-(instancetype)initWithBandSelecteViewFrame:(CGRect)frame;

-(void)reload_CollctionView;

@property (assign ,nonatomic) id <BandSelecteViewDelegate> delegate;

@property (nonatomic , strong) NSMutableArray  * brandListArray;




@end
