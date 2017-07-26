//
//  SearchLanelModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchData,Cmgoodslanel;
@interface SearchLanelModel : NSObject

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) SearchData *data;

@end
@interface SearchData : NSObject

@property (nonatomic, strong) NSArray<Cmgoodslanel *> *cmGoodsLanel;

@end

@interface Cmgoodslanel : NSObject

@property (nonatomic, assign) NSInteger labelId;

@property (nonatomic, assign) NSInteger orderNum;

@property (nonatomic, copy) NSString *labelName;

@end

