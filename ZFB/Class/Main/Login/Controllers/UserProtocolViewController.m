//
//  UserProtocolViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "UserProtocolViewController.h"
#import "YYText.h"

@interface UserProtocolViewController ()



@end

@implementation UserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _navTitle;
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -64)];
    [self.view addSubview:scrollView];
    
    
    YYLabel *contentL = [[YYLabel alloc] init];
    contentL.numberOfLines = 0;
    contentL.preferredMaxLayoutWidth = KScreenW -30;
    NSString * mutString =  _mutContent;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:mutString];
    [text yy_setFont:[UIFont systemFontOfSize:14] range:text.yy_rangeOfAll];//字体
    text.yy_lineSpacing = 10;//行间距
    
    //用label的attributedText属性来使用富文本
    contentL.attributedText = text;
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, MAXFLOAT);
    
    //计算文本尺寸
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:text];
    contentL.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    contentL.width = maxSize.width;
    contentL.height = introHeight + 50;
    
    contentL.frame = CGRectMake(15, 20, KScreenW -30, contentL.height +50 );
    [scrollView addSubview:contentL];
     // 隐藏水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize =  contentL.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
