//
//  AppraiseModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AppraiseModel.h"

@implementation AppraiseModel

 
@end


@implementation CommentData

@end


@implementation Goodscommentlist

+ (NSDictionary *)objectClassInArray{
    return @{@"findListReviews" : [Findlistreviews class]};
}



@end


@implementation Findlistreviews

-(NSArray *)evaluteImages {
    
    NSArray *imgs = [NSArray array];
    if (![self.reviewsImgUrl isEqualToString:@""]) {
        
        imgs = [self.reviewsImgUrl componentsSeparatedByString:@","];
    }
    return imgs;

}
@end


