//
//  ZFSendPopView.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZFSendPopViewDelegate <NSObject>


-(void)sendTitle:(NSString *)title SendServiceType:(SendServicType)type;

@end
@interface ZFSendPopView : UIView

@property(assign,nonatomic)id <ZFSendPopViewDelegate>delegate;


-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;



@end
