//
//  DetailWebViewCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/8/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailWebViewCell.h" 
@interface DetailWebViewCell ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *wbView;
@end
@implementation DetailWebViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.wbView = [UIWebView new];
    [self.contentView addSubview:self.wbView];
    MPWeakSelf(self);
    [self.wbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.contentView);
    }];
    
    self.wbView.scrollView.bounces = NO;
    self.wbView.scrollView.showsHorizontalScrollIndicator = NO;
    self.wbView.scrollView.scrollEnabled = NO;
    self.wbView.delegate = self;

}

-(void)setHTMLString:(NSString *)HTMLString
{
    _HTMLString = HTMLString;
    NSLog(@"_HTMLString === %@",_HTMLString);
    [self.wbView loadHTMLString:_HTMLString baseURL:nil];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    //图片适应宽高
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=document.body.clientWidth;" //缩放系数</span>
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth);"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
    NSString *curHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];//缩放后的内容高度
    
    //这两行是么可有缩放的情况下内容高度
    UIScrollView *scrollView = (UIScrollView *)[[webView subviews] objectAtIndex:0];
    CGFloat webViewHeight = [scrollView contentSize].height;
    
    CGRect newFrame = webView.frame;
    newFrame.size.height = [curHeight floatValue];
    webView.frame = newFrame;
    NSLog(@"  里面的高度 %f",webViewHeight);
    [self.delegate getHeightForWebView:webViewHeight];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
