//
//  StoreListModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "HomeStoreListModel.h"

@implementation HomeStoreListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
//+ (NSDictionary *)objectClassInArray
//{
//        return @{
//                 @"statuses" : [StoreListModel class],
//                 @"cmStoreList" : [cmStoreList class]
//                 };
//}
//
//+ (Class)objectClassInArray:(NSString *)propertyName
//{
//     if ([propertyName isEqualToString:@"cmStoreList"]) {
//         
//         return [cmStoreList class];
//   
//     } else if ([propertyName isEqualToString:@"ads"]) {
//         
//         return [cmStoreList class];
//     }
// 
//    return nil;
// 
//}


// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
//+ (NSDictionary *)replacedKeyFromPropertyName{
//    return @{
//             @"ID" : @"id",
//             @"desc" : @"desciption",
//             @"oldName" : @"name.oldName",
//             @"nowName" : @"name.newName",
//             @"nameChangedTime" : @"name.info.nameChangedTime",
//             @"bag" : @"other.bag"
//             };
//}


@end
