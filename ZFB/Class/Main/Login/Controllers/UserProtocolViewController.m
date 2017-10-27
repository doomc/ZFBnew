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
    self.title = @"用户协议";
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -64)];
    [self.view addSubview:scrollView];
    
    
    YYLabel *contentL = [[YYLabel alloc] init];
    contentL.numberOfLines = 0;
    contentL.preferredMaxLayoutWidth = KScreenW -30;
    NSString * mutString = @"《展富宝会员服务协议》\n本协议是您与重庆展付卫网络技术有限公司之间的法律协议。重庆展付卫网络技术有限公司根据以下服务条款为您提供服务。\n一、服务说明\n会员了解并同意，重庆展付卫网络技术有限公司可向会员提供的服务可能受当时技术、资源和权利条件所限而有所变化，具体服务内容以及相应价格和条件应以重庆展付卫网络技术有限公司实际提供时为准。对于任何会员信息或个人化设定之时效、删除、传递错误、未予储存或其它任何问题，重庆展付卫网络技术有限公司均不承担任何责任。重庆展付卫网络技术有限公司有权不经事先通知为维修保养、升级或其它目的暂停本服务的全部或任何部分，并无需承担任何责任。\n二、遵守法律\n会员同意遵守中华人民共和国相关法律法规的所有规定，并对以任何方式使用会员的密码和会员的账号使用本服务的任何行为及其结果承担全部责任。如会员的行为违反国家法律和法规的任何规定，有可能构成犯罪的，将被追究刑事责任，并由会员承担全部法律责任。同时如果重庆展付卫网络技术有限公司有理由认为会员的任何行为，包括但不限于会员的任何言论和其它行为违反或可能违反国家法律和法规的任何规定，重庆展付卫网络技术有限公司可在任何时候不经任何事先通知而直接终止向会员提供服务。\n三、用户的注册义务\n1）用户同意所有展富宝会员协议条款并完成注册程序，才能成为展富宝平台的会员。\n2）用户以使用WIFI网络为目的进行WIFI接入时，视为用户同意本协议，自动成为展富宝平台的会员。\n3）用户点击同意本协议的，即视为用户确认自己具有享受展富宝平台相关服务、下单购物等相应的权利能力和行为能力，能够独立承担法律责任。\n4）用户应依本服务注册提示填写正确的注册信息，并确保今后更新的资料的有效性和合法性。若用户提供任何违法、不道德或重庆展付卫网络技术有限公司认为不适合展示的资料；或者重庆展付卫网络技术有限公司有理由怀疑用户的资料属于程序或恶意操作，重庆展付卫网络技术有限公司有权暂停或终止用户的账号，并拒绝用户于现在和未来使用本服务之全部或任何部分。重庆展付卫网络技术有限公司无须对任何用户的任何登记资料承担任何责任，包括但不限于鉴别、核实任何登记资料的真实性、正确性、完整性、适用性及/或是否为最新资料的责任。\n四、会员账号、密码及安全\n完成本服务的注册程序并成功注册之后，会员可登录到会员在重庆展付卫网络技术有限公司注册的账号（下称'账号'）。保护会员的账号安全，是会员的责任。会员应对所有使用会员的密码及账号的活动负完全的责任。会员同意：\n1）会员的重庆展付卫网络技术有限公司账号遭到未获授权的使用，或者发生其它任何安全问题时，会员将立即通知重庆展付卫网络技术有限公司；\n2）当您登录互联网时，您应完全自行负责采取或实施您认为合适的安全手段保护您的隐私或个人信息及财产。对于您的隐私或个人信息及财产因您使用无线上网服务而发生的损失、破坏或遭非法侵入或使用，如果会员未保管好自己的账号和密码，因此而产生的任何损失或损害，重庆展付卫网络技术有限公司无法也不承担任何责任；\n3）每个会员都要对其账号中的所有行为和事件负全责。如果会员未保管好自己的账号和密码而对会员、重庆展付卫网络技术有限公司或第三方造成的损害，会员将负全部责任。\n五、重庆展付卫网络技术有限公司隐私权政策\n尊重会员个人隐私是重庆展付卫网络技术有限公司的一项基本政策。重庆展付卫网络技术有限公司通常不会监控或拦截会员在使用本服务时传送的数据，包括但不限于未经合法会员授权时公开、编辑或透露其注册资料及保存在本站中的非公开内容，除非有法律许可要求或重庆展付卫网络技术有限公司或本服务的其他提供商可能为执法目的或根据司法或其它政府部门的指令或要求就披露该等会员信息提供协助或重庆展付卫网络技术有限公司在诚信的基础上认为透露这些信息在以下四种情况是必要的：\n1) 遵守有关法律规定，遵从本服务程序。 \n2) 保持维护本站的商标所有权。\n3) 在紧急情况下竭力维护会员个人和社会大众的隐私安全。\n4) 符合其他相关的要求。";
    
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
