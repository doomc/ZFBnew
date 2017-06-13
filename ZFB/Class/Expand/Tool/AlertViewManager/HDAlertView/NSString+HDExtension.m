//
//  NSString+HDExtension.m
//  PortableTreasure
//
//  Created by HeDong on 15/5/10.
//  Copyright © 2015年 hedong. All rights reserved.
//

#import "NSString+HDExtension.h"
#import "sys/utsname.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (HDExtension)


#pragma mark - 路径方法
+ (instancetype)hd_pathForDocuments {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (instancetype)hd_filePathAtDocumentsWithFileName:(NSString *)fileName {
    return  [[self hd_pathForDocuments] stringByAppendingPathComponent:fileName];
}

+ (instancetype)hd_pathForCaches {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (instancetype)hd_filePathAtCachesWithFileName:(NSString *)fileName {
    return [[self hd_pathForCaches] stringByAppendingPathComponent:fileName];
}

+ (instancetype)hd_pathForMainBundle {
    return [NSBundle mainBundle].bundlePath;
}

+ (instancetype)hd_filePathAtMainBundleWithFileName:(NSString *)fileName {
    return [[self hd_pathForMainBundle] stringByAppendingPathComponent:fileName];
}

+ (instancetype)hd_pathForTemp {
    return NSTemporaryDirectory();
}

+ (instancetype)hd_filePathAtTempWithFileName:(NSString *)fileName {
    return [[self hd_pathForTemp] stringByAppendingPathComponent:fileName];
}

+ (instancetype)hd_pathForPreferences {
    return [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (instancetype)hd_filePathAtPreferencesWithFileName:(NSString *)fileName {
    return [[self hd_pathForPreferences] stringByAppendingPathComponent:fileName];
}

+ (instancetype)hd_pathForSystemFile:(NSSearchPathDirectory)directory {
    return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) lastObject];
}

+ (instancetype)hd_filePathForSystemFile:(NSSearchPathDirectory)directory withFileName:(NSString *)fileName {
    return [[self hd_pathForSystemFile:directory] stringByAppendingPathComponent:fileName];
}


#pragma mark - 文本计算方法
- (CGSize)hd_sizeWithSystemFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = mode;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle};
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
}

- (CGSize)hd_sizeWithSystemFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode numberOfLine:(NSInteger)numberOfLine {
    CGSize maxSize = [self hd_sizeWithSystemFont:font constrainedToSize:size lineBreakMode:mode];
    CGFloat oneLineHeight = [self hd_sizeWithSystemFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingTail].height; // 某些情况, 不到计算的一行主动换行了, NSLineBreakByTruncatingTail计算出来的不是真实一行, 这时候请使用你项目字体最大的高来计算 (控制参数size)
    CGFloat height = 0;
    CGFloat limitHeight = oneLineHeight * numberOfLine;
    
    if (maxSize.height > limitHeight) {
        height = limitHeight;
    } else {
        height = maxSize.height;
    }
    
    return CGSizeMake(maxSize.width, height);
}

- (CGSize)hd_sizeWithSystemFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self hd_sizeWithSystemFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

+ (CGSize)hd_sizeWithText:(NSString *)text systemFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [text hd_sizeWithSystemFont:font constrainedToSize:size];
}

- (CGSize)hd_sizeWithBoldFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = mode;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraphStyle};

    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
}

- (CGSize)hd_sizeWithBoldFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self hd_sizeWithBoldFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)hd_sizeWithBoldFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode numberOfLine:(NSInteger)numberOfLine {
    CGSize maxSize = [self hd_sizeWithBoldFont:font constrainedToSize:size lineBreakMode:mode];
    CGFloat oneLineHeight = [self hd_sizeWithBoldFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingTail].height; // 某些情况, 不到计算的一行主动换行了, NSLineBreakByTruncatingTail计算出来的不是真实一行, 这时候请使用你项目字体最大的高来计算 (控制参数size)
    CGFloat height = 0;
    CGFloat limitHeight = oneLineHeight * numberOfLine;
    
    if (maxSize.height > limitHeight) {
        height = limitHeight;
    } else {
        height = maxSize.height;
    }
    
    return CGSizeMake(maxSize.width, height);
}


#pragma mark - 富文本相关
- (NSAttributedString *)hd_conversionToAttributedStringWithLineSpeace:(CGFloat)lineSpacing kern:(CGFloat)kern lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle,
                                 NSKernAttributeName:@(kern)};
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    
    return attributedString;
}

- (CGSize)hd_sizeWithAttributedStringLineSpeace:(CGFloat)lineSpeace kern:(CGFloat)kern font:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment {
    if (font == nil) {
        HDAssert(!HDObjectIsEmpty(font), @"font不能为空");
        return CGSizeMake(0, 0);
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpeace;
    paraStyle.lineBreakMode = lineBreakMode;
    paraStyle.alignment = alignment;
    
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@(kern)};
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
}

- (CGSize)hd_sizeWithAttributedStringLineSpeace:(CGFloat)lineSpeace kern:(CGFloat)kern font:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment numberOfLine:(NSInteger)numberOfLine {
    CGSize maxSize = [self hd_sizeWithAttributedStringLineSpeace:lineSpeace kern:kern font:font size:size lineBreakMode:lineBreakMode alignment:alignment];
    CGFloat oneLineHeight = [self hd_sizeWithAttributedStringLineSpeace:lineSpeace kern:kern font:font size:size lineBreakMode:NSLineBreakByTruncatingTail alignment:alignment].height;
    CGFloat height = 0;
    CGFloat limitHeight = oneLineHeight * numberOfLine;
    
    if (maxSize.height > limitHeight) {
        height = limitHeight;
    } else {
        height = maxSize.height;
    }
    
    return CGSizeMake(maxSize.width, height);
}

- (BOOL)hd_numberOfLineWithLineSpeace:(CGFloat)lineSpeace kern:(CGFloat)kern font:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment {
    CGFloat oneHeight = [self hd_sizeWithAttributedStringLineSpeace:lineSpeace kern:kern font:font size:size lineBreakMode:NSLineBreakByTruncatingTail alignment:alignment].height; // 某些情况, 不到计算的一行主动换行了, NSLineBreakByTruncatingTail计算出来的不是真实一行, 这时候请使用你项目字体最大的高来计算 (控制参数size)
    CGFloat maxHeight = [self hd_sizeWithAttributedStringLineSpeace:lineSpeace kern:kern font:font size:size lineBreakMode:lineBreakMode alignment:alignment].height;
    
    if (maxHeight > oneHeight) {
        return NO;
    }
    
    return YES;
}


#pragma mark - 设备相关
NSString *const iPhone6_6s_7 = @"iPhone6_6s_7";
NSString *const iPhone6_6s_7Plus = @"iPhone6_6s_7Plus";

+ (instancetype)hd_deviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    // iPhone
    if ([deviceString isEqualToString:@"iPhone7,1"])    return iPhone6_6s_7Plus;
    if ([deviceString isEqualToString:@"iPhone7,2"])    return iPhone6_6s_7;
    if ([deviceString isEqualToString:@"iPhone8,1"])    return iPhone6_6s_7;
    if ([deviceString isEqualToString:@"iPhone8,2"])    return iPhone6_6s_7Plus;
    if ([deviceString isEqualToString:@"iPhone9,1"])    return iPhone6_6s_7;
    if ([deviceString isEqualToString:@"iPhone9,2"])    return iPhone6_6s_7Plus;
    if ([deviceString isEqualToString:@"iPhone9,3"])    return iPhone6_6s_7;
    if ([deviceString isEqualToString:@"iPhone9,4"])    return iPhone6_6s_7Plus;
    
    return deviceString;
}





@end
