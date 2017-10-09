/**
 @@create by 刘智援 2016-11-28
 
 @简书地址:    http://www.jianshu.com/users/0714484ea84f/latest_articles
 @Github地址: https://github.com/lyoniOS
 @return MXWechatPayHandler（微信调用工具类）
 */

#import <Foundation/Foundation.h>

@interface MXWechatPayHandler : NSObject

/**
 吊微信支付

 @param tradeType  交易类型
 @param orderNo 订单号
 @param totalFee 总金额
 @param payTitle 支付名称
 @param notifyUrl 回调地址
 */
+ (void)jumpToWxPayWithTradeType:(NSString *)tradeType AndOrderNo:(NSString *)orderNo AndTotalFee:(NSString *)totalFee AndPayTitle:(NSString *)payTitle AndNotifyUrl:(NSString *)notifyUrl;

@end
