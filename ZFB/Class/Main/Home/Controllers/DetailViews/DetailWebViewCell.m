//
//  DetailWebViewCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/8/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailWebViewCell.h" 
@interface DetailWebViewCell ()<UIWebViewDelegate>

@property (nonatomic, strong) UILabel * labelhtml;

@end
@implementation DetailWebViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _labelhtml = [[UILabel alloc]init];
    [self.contentView addSubview:_labelhtml];
}

-(void)setHTMLString:(NSString *)HTMLString
{
    _HTMLString = HTMLString;
     
    NSAttributedString * attrStr1 = [[NSAttributedString alloc] initWithData:[HTMLString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    
    [attrStr1 enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrStr1.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[NSTextAttachment class]]) {
            NSTextAttachment * attachment = value;
            CGFloat height = attachment.bounds.size.height;
            CGFloat width = attachment.bounds.size.width;
            
            CGFloat newheiht = height*(KScreenW-30)/width;
            
            attachment.bounds = CGRectMake(0, 0, KScreenW-30, newheiht);
        }
    }];
    
    self.labelhtml.attributedText  = attrStr1;
    CGFloat webheight ;
    
    webheight  =  [self calculateMeaasgeHeightWithText:attrStr1 andWidth:KScreenW - 30 andFont:[UIFont systemFontOfSize:16]];
    
    self.labelhtml.frame = CGRectMake(15, 15, KScreenW - 30, webheight);
    self.labelhtml.numberOfLines = 0;
    
    [self.delegate getHeightForWebView:webheight];


}
- (CGFloat)calculateMeaasgeHeightWithText:(NSAttributedString *)string andWidth:(CGFloat)width andFont:(UIFont *)font {
    static UILabel *stringLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//生成一个同于计算文本高度的label
        stringLabel = [[UILabel alloc] init];
        stringLabel.numberOfLines = 0;
    });
    stringLabel.font = font;
    stringLabel.attributedText = string;
    return [stringLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
