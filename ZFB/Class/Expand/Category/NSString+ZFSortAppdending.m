//
//  NSString+ZFSortAppdending.m
//  ZFB
//
//  Created by 熊维东 on 2017/6/6.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "NSString+ZFSortAppdending.h"

@implementation NSString (ZFSortAppdending)

+(NSString *)stringSortNumberStringAscendingWithString:(NSString *)string {
    
    if (string.length > 0) {
        NSMutableArray *numStrArray = [NSMutableArray array];
        for (int i = 0; i < string.length; i++) {
            NSString *numStr = [string substringWithRange:NSMakeRange(i, 1)];
            //        NSLog(@"===========numStr==========%@", numStr);
            
            [numStrArray addObject:numStr];
        }
        [numStrArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        NSString *resultString = @"";
        for (NSString *str in numStrArray) {
            resultString = [resultString stringByAppendingString:str];
        }
        
        return resultString;
    }else {
        
        return  string;
    }
}
@end
