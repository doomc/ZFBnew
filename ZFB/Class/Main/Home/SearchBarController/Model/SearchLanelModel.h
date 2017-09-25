//
//  SearchLanelModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchData,Cmgoodslanel;
@interface SearchLanelModel : ResponseObject

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) SearchData *data;

@end
@interface SearchData : ResponseObject

@property (nonatomic, strong) NSArray<Cmgoodslanel *> *cmGoodsLanel;

@end

@interface Cmgoodslanel : ResponseObject

@property (nonatomic, copy) NSString * labelId;

@property (nonatomic, copy) NSString * orderNum;

@property (nonatomic, copy) NSString * labelName;

@end

