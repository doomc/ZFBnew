//
//  MineShareAllIncomeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  总收入

#import "MineShareAllIncomeViewController.h"
#import "MineShareIncomeCell.h"
@interface MineShareAllIncomeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UITableView * tableView;
@property (strong, nonatomic)  UIButton * edit_btn;

@end

@implementation MineShareAllIncomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的共享";

    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineShareIncomeCell" bundle:nil] forCellReuseIdentifier:@"MineShareIncomeCellid"];
    
}

//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    NSString * saveStr = @"选择时间";
    _edit_btn = [[UIButton alloc]init];
    [_edit_btn setTitle:saveStr forState:UIControlStateNormal];
    _edit_btn.titleLabel.font=SYSTEMFONT(14);
    [_edit_btn setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
    _edit_btn.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width = size.width ;
    _edit_btn.frame =CGRectMake(0, 0, width+10, 22);
    [_edit_btn addTarget:self action:@selector(didClickEditing:) forControlEvents:UIControlEventTouchUpInside];
    return _edit_btn;
}

#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:UITableViewStylePlain
                      ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineShareIncomeCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"MineShareIncomeCellid" forIndexPath:indexPath];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 编辑/完成
-(void)didClickEditing:(UIButton *) editing
{
    NSLog(@"%@",editing);
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
