//
//  XHStarRateView.h
//  XHStarRateView
//
//  Created by xwd on 16/4/1.
//  Copyright © 2016年 xwd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XHStarRateView;

typedef void(^finishBlock)(CGFloat currentScore);

typedef NS_ENUM(NSInteger, RateStyle)
{
    WholeStar      = 0,//只能整星评论
    HalfStar       = 1,//允许半星评论
    IncompleteStar = 2//允许不完整星评论
};

@protocol XHStarRateViewDelegate <NSObject>

-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore;

@end

@interface XHStarRateView : UIView

@property (nonatomic,assign) BOOL                   isAnimation;//是否动画显示，默认NO
@property (nonatomic,assign) RateStyle              rateStyle;//评分样式    默认是WholeStar
@property (nonatomic, weak ) id<XHStarRateViewDelegate> delegate;
@property (nonatomic,assign) CGFloat                currentScore;// 当前评分：0-5  默认0
@property (nonatomic,assign) BOOL                   touchEnable;//可否点击 默认 yes
@property (nonatomic,copy) NSString *              islittleStar;//小星星 1 是小星星 0是大猩猩


-(instancetype)initWithFrame:(CGRect)frame;

-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate WithtouchEnable:(BOOL)touchEnable littleStar:(NSString *)littleStar;


-(instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish;

@end
