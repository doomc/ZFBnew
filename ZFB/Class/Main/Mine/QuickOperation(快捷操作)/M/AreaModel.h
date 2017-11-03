//
//  AreaModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/3.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AreaData;
@interface AreaModel : NSObject

@property (nonatomic ,strong) NSArray <AreaData *>* data;

@end

@interface AreaData : NSObject

@property (nonatomic ,copy) NSString * code;
@property (nonatomic ,copy) NSString * areaId;
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,copy) NSString * provincecode;


@end
