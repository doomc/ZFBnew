//
// 
//  ZFB
//
//  Created by  展富宝  on 2017/10/10.
//  Copyright © 2017年 com.zfb. All rights reserved.


#import <Foundation/Foundation.h>

typedef void(^PaySuccessBlock)(NSInteger paycode);

@interface WXApiManager : NSObject<WXApiDelegate>


+ (instancetype)sharedManager;

@property (nonatomic ,copy) PaySuccessBlock payBlock;

@end
