//
//  ClassLeftListModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ClassLeftListModel.h"

@implementation ClassLeftListModel


@end
@implementation ClassListData

+ (NSDictionary *)objectClassInArray{
    return @{@"CmGoodsTypeList" : [CmgoodsClasstypelist class]};
}

@end


@implementation CmgoodsClasstypelist
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        
        self.typeId = [value integerValue];
    }
}

@end

