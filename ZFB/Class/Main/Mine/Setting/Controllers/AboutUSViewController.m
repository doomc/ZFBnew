//
//  AboutUSViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AboutUSViewController.h"
#import "AboutUSCell.h"
#import "ZFSettingCell.h"
@interface AboutUSViewController ()<UITableViewDataSource ,UITableViewDelegate>

@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) UIView * footerView;

@end

@implementation AboutUSViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64 ,KScreenW , KScreenH - 64 - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.tableHeaderView.height = 185;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AboutUSCell" bundle:nil] forCellReuseIdentifier:@"AboutUSCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFSettingCell" bundle:nil] forCellReuseIdentifier:@"ZFSettingCell"];
    self.tableView.tableHeaderView = [AboutUSCell new];
    [self initFooterView];
    self.view.backgroundColor = HEXCOLOR(0xF7F7F7);
}
-(void)initFooterView{
    
    NSString * text = @"重庆展付卫网络技术有限公司 版权所有 \n Chongqing Zavfwei Network Technology Co.,LTD";
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenH - 20, KScreenW, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = HEXCOLOR(0x8d8d8d);
    label.text = text;
    label.font = SYSTEMFONT(12);
    [self.view addSubview:label];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFSettingCell * settingCell = [ self.tableView dequeueReusableCellWithIdentifier:@"ZFSettingCell" forIndexPath:indexPath];
    
    settingCell.lb_title.text = @"功能介绍";

    return settingCell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
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
