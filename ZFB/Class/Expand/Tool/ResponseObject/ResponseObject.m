//
//  ResponseObject.m
//  iOSTJUserSide
//
//  Created by 林经纬 on 2017/5/18.
//  Copyright © 2017年 林经纬. All rights reserved.
//

#import "ResponseObject.h"

@implementation ResponseObject

-(instancetype)init {
    if (self = [super init]) {
        
        [self mfs_propertyNamesUntilClass:[NSObject class] class:[self class] usingBlock:^(NSString *propertyName, NSString *propertyType) {
            if ([propertyType isKindOfClass:[NSString class]]) {
                [self setValue:@"" forKey:propertyName];
            }
        }];
    }
    return self;
}
#pragma mark - 对象的属性列表
- (NSArray *)mfs_propertyNamesUntilClass:(Class)sCls class:(Class)class_ usingBlock:(void (^)(NSString *propertyName, NSString *propertyType))block
{
    Class cls = [class_ class];
    NSMutableArray *mArray = [NSMutableArray array];
    while ((cls != [NSObject class]) && (cls != [sCls superclass])) {
        unsigned propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
        for ( int i = 0 ; i < propertyCount ; i++ ) {
            objc_property_t property = properties[i];
            const char *propertyAttributes = property_getAttributes(property);
            BOOL isReadWrite = (strstr(propertyAttributes, ",V") != NULL);
            if (isReadWrite) {
                NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
                if (propertyName) [mArray addObject:propertyName];
                NSString *propertyType = nil;
                char *propertyAttributeValue = property_copyAttributeValue(property, "T");
                if ((propertyAttributeValue != NULL) && (propertyAttributeValue[0] == '@') && (strlen(propertyAttributeValue) >= 3)) {
                    char *cString = strndup(propertyAttributeValue+2, strlen(propertyAttributeValue)-3);
                    propertyType = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
                    free(cString);
                }
                free(propertyAttributeValue);
                if (block) block(propertyName, propertyType);
            }
        }
        cls = [cls superclass];
        free(properties);
    }
    return mArray;
}
@end
