//
//  BankProtocolViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BankProtocolViewController.h"
#import "YYText.h"

@interface BankProtocolViewController ()

@end

@implementation BankProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"展富宝代发服务协议";
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH - 64)];
    [self.view addSubview:scrollView];
    
    
    YYLabel *contentL = [[YYLabel alloc] init];
    contentL.numberOfLines = 0;
    contentL.preferredMaxLayoutWidth = KScreenW -30;
    NSString * mutString = @"《展富宝代发服务协议》\n 代发服务协议（以下简称'本协议'）是重庆展付卫网络技术有限公司（以下简称'展付卫'）与希望通过展付卫提供的代发服务（以下简称'本服务'）为所提供余额提现的用户(以下简称'用户'或'您')就代发服务的使用等相关事宜所订立的有效协议。您通过网络页面或手机客户端界面点击或以其他方式同意/确认本协议，即表示您与展付卫已达成协议并同意接受本协议的全部内容。\n您的点击同意/确认行为即表示您授权委托展付卫代您与您所持银行卡发卡行签署代发协议，同时允许展付卫对公账户向您绑定的银行卡中进行转账操作。\n您应保证您在使用本服务时是合法、有效的，且您应保证将本服务用于合法或本协议约定的目的。您保证对您使用本服务所发出的指令的真实性和有效性负责。若您违反前述保证从而给展付卫发卡行或持卡人造成损失的，您应负责赔偿并承担全部法律责任。\n您存在下列情形之一的，展付卫有权立即终止您使用相关服务而无需承担任何责任：（1）您违反法律法规政策等规定的；（2）您违反本协议约定的；（3）您违反展付卫发布的使用本服务所必须遵守的协议、规则等相关规定的；（4）展付卫认为向您提供本服务存在风险的。\n所有使用本服务而必须遵守的协议、附件和规则等均构成本协议不可分割的组成部分，与本协议具有同等法律效力。就本协议所引起的任何争议和纠纷，均应由双方友好协商解决；如协商不成的，您和展付卫均有权向快钱所在地人民法院提起诉讼。\n您同意，展付卫有权对本协议内容进行相应修改或变更，并通过在展付卫网站公布的形式进行通知，修改或变更后的协议内容在展付卫网站公布即有效代替原来的协议，您须定期关注、注意展付卫网站并定期审阅本协议及其变更内容。若您不同意展付卫对本协议所作的任何修改或变更，您应立即停止使用本服务。若您在本协议内容公布变更后仍继续使用本服务，则表示您已充分阅读、理解、同意并接受修改或变更后的协议内容，也将遵循修改或变更后的协议内容使用本服务。";
   
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
