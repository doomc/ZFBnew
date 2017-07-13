//
//  ZFEncryptionKey.h
//  ZFB
//
//  Created by 熊维东 on 2017/6/7.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Block) (NSDictionary * signParam, NSDictionary * param);

//加密规则
@interface ZFEncryptionKey : NSObject

@property (nonatomic,copy) Block block;
@property (nonatomic,copy) NSString  * MD5_key;




//- (NSString *)signStringWithParam:(NSDictionary *)param;

- (NSDictionary *)signStringWithParamdic:(NSDictionary *)param;
- (NSDictionary *)signStringWithParamdic:(NSDictionary *)param andMD5Key:(NSString* )MD5key;

@end
