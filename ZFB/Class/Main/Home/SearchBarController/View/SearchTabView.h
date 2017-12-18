//
//  SearchTabView.h
//  ZFB
//
//  Created by  展富宝  on 2017/12/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
 typedef void(^SelectedIndexBlock)(NSInteger index);
@interface SearchTabView : UIView

//传入一个数组 所有的排序由高到低
@property (nonatomic , strong) NSArray * dataArray;
@property (nonatomic , copy) SelectedIndexBlock indexBlock;

-(instancetype)initWithFrame:(CGRect)frame;


@end
