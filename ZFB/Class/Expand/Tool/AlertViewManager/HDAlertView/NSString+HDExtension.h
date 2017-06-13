//
//  NSString+HDExtension.h
//  PortableTreasure
//
//  Created by HeDong on 15/5/10.
//  Copyright © 2015年 hedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDMacro.h"

@interface NSString (HDExtension)

#pragma mark - 文本计算方法
/**
 *  计算文字大小
 *
 *  @param font 字体
 *  @param size 计算范围的大小
 *  @param mode 段落样式
 *
 *  @return 计算出来的大小
 */
- (CGSize)hd_sizeWithSystemFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode;

/**
 计算字符串高度
 
 @param font 字体
 @param size 限制大小
 @param mode 计算的换行模型
 @param numberOfLine 限制计算高度的行数
 @return 返回计算大小
 */
- (CGSize)hd_sizeWithSystemFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode numberOfLine:(NSInteger)numberOfLine;

/**
 *  计算文字大小
 *
 *  @param font 字体
 *  @param size 计算范围的大小
 *
 *  @return 计算出来的大小
 */
- (CGSize)hd_sizeWithSystemFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 *  计算文字大小
 *
 *  @param text 文字
 *  @param font 字体
 *  @param size 计算范围的大小
 *
 *  @return 计算出来的大小
 */
+ (CGSize)hd_sizeWithText:(NSString *)text systemFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 计算粗体文字大小

 @param font 字体
 @param size 计算范围的大小
 @param mode 计算的换行模型
 @return 计算出来的大小
 */
- (CGSize)hd_sizeWithBoldFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode;

/**
 计算粗体文字大小

 @param font 字体
 @param size 计算范围的大小
 @return 计算出来的大小
 */
- (CGSize)hd_sizeWithBoldFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 计算粗体文字大小

 @param font 字体
 @param size 计算范围的大小
 @param mode 计算的换行模型
 @param numberOfLine 限制计算高度的行数
 @return 计算出来的大小
 */
- (CGSize)hd_sizeWithBoldFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode numberOfLine:(NSInteger)numberOfLine;


#pragma mark - 富文本相关
/**
 转变成富文本
 
 @param lineSpacing 行间距
 @param kern 文字间的间距
 @param lineBreakMode 换行方式
 @param alignment 文字对齐格式
 @return 转变后的富文本
 */
- (NSAttributedString *)hd_conversionToAttributedStringWithLineSpeace:(CGFloat)lineSpacing kern:(CGFloat)kern lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;

/**
 计算富文本字体大小
 
 @param lineSpeace 行间距
 @param kern 文字间的间距
 @param font 字体
 @param size 计算范围
 @param lineBreakMode 换行方式
 @param alignment 文字对齐格式
 @return 计算后的字体大小
 */
- (CGSize)hd_sizeWithAttributedStringLineSpeace:(CGFloat)lineSpeace kern:(CGFloat)kern font:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;

/**
 计算富文本字体大小
 
 @param lineSpeace 行间距
 @param kern 文字间的间距
 @param font 字体
 @param size 计算范围
 @param lineBreakMode 换行方式
 @param alignment 文字对齐格式
 @param numberOfLine 限制计算行数
 @return 计算后的字体大小
 */
- (CGSize)hd_sizeWithAttributedStringLineSpeace:(CGFloat)lineSpeace kern:(CGFloat)kern font:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment numberOfLine:(NSInteger)numberOfLine;

/**
 是否是一行高度
 
 @param lineSpeace 行间距
 @param kern 文字间的间距
 @param font 字体
 @param size 计算范围
 @param lineBreakMode 换行方式
 @param alignment 文字对齐格式
 @return 返回YES代表1行, NO代表多行
 */
- (BOOL)hd_numberOfLineWithLineSpeace:(CGFloat)lineSpeace kern:(CGFloat)kern font:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;

#pragma mark - 设备相关
/**
 *  设备版本
 */
+ (instancetype)hd_deviceVersion;

/**
 *  设备类型(用于区分iPhone屏幕大小)
 */
HD_EXTERN NSString *const iPhone6_6s_7;
HD_EXTERN NSString *const iPhone6_6s_7Plus;

+ (instancetype)hd_deviceType;





@end
