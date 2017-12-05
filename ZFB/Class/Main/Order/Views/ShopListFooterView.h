//
//  ShopListFooterView.h
//  ZFB
//
//  Created by  展富宝  on 2017/12/5.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FootViewBlock)( NSString *tf_text);

@interface ShopListFooterView : UITableViewHeaderFooterView

@property (copy, nonatomic)  FootViewBlock  footerBlock;

@property (strong, nonatomic) UITextField *tf_message;

@property (assign, nonatomic)  NSInteger  indexSection;



@end
