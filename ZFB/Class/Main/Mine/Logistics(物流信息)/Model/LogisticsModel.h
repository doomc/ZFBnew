
//
//  LogisticsModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LogisticsData,LogisticsList;
@interface LogisticsModel : ResponseObject

@property (nonatomic, strong) LogisticsData * data;
@property (nonatomic, copy) NSString * resultCode;

@end
@interface LogisticsData : ResponseObject

@property (nonatomic, copy) NSString * expressNumber;
@property (nonatomic, copy) NSString * company;
@property (nonatomic, strong) NSArray<LogisticsList *> *list;

@end

@interface LogisticsList : ResponseObject
@property (nonatomic, assign) BOOL isfirstData;

@property (nonatomic, copy) NSString * time;

@property (nonatomic, copy) NSString * text;


@end
