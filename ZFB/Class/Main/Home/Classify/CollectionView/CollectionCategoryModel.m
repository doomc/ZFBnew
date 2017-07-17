//
//  CategoryModel.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//    

#import "CollectionCategoryModel.h"

@implementation CollectionCategoryModel


 
@end
@implementation ClassData

+ (NSDictionary *)objectClassInArray{
    return @{@"nextTypeList" : [Nexttypelist class]};
}

@end


@implementation Nexttypelist
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.goodId = [value integerValue];
        
    }
}

@end


