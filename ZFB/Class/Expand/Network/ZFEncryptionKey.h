//
//  ZFEncryptionKey.h
//  ZFB
//
//  Created by 熊维东 on 2017/6/7.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFEncryptionKey : NSObject


-(NSString *)signStringWithParam:(NSDictionary *)param;

@end
