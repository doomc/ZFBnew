//
//  ZFSettingHeadViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSettingHeadViewController.h"
#import "ZFSettingHeaderCell.h"
#import "ZFSettingRowCell.h"
#import "ZFSettingAddressViewController.h"
static NSString * settingheadid = @"ZFSettingHeaderCellid";
static NSString * settingRowid = @"ZFSettingRowCellid";

@interface ZFSettingHeadViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * _titleArr;
}
@property (nonatomic,strong)UITableView * tableView;


@end

@implementation ZFSettingHeadViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人资料";
    _titleArr  = @[@"昵称",@"性别",@"生日",@"地址管理"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFSettingHeaderCell" bundle:nil] forCellReuseIdentifier:settingheadid];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFSettingRowCell" bundle:nil] forCellReuseIdentifier:settingRowid];

    
    [self.view addSubview:self.tableView];
    
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    NSString * saveStr = @"保存";
    UIButton *right_button = [[UIButton alloc]init];
    [right_button setTitle:saveStr forState:UIControlStateNormal];
    right_button.titleLabel.font=SYSTEMFONT(14);
    [right_button setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
    right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width = size.width ;
    right_button.frame =CGRectMake(0, 0, width+10, 22);
    
    return right_button;
}
//设置右边事件
-(void)right_button_event:(UIButton*)sender{
    NSLog(@"保存")
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if (indexPath.section == 0) {
    
        ZFSettingHeaderCell * headCell = [self.tableView dequeueReusableCellWithIdentifier:settingheadid forIndexPath:indexPath];
        headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        headCell.lb_title.text =@"头像";
        cell =  headCell;

    }if (indexPath.section == 1 ) {
        ZFSettingRowCell * rowCell = [self.tableView dequeueReusableCellWithIdentifier:settingRowid forIndexPath:indexPath];
        rowCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        rowCell.lb_title.text = _titleArr[indexPath.row];
        cell = rowCell;
        
    }
    return cell;
 
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sectin = %ld,row = %ld",indexPath.section ,indexPath.row);
    
    if (indexPath.section == 0){
        if (indexPath.row == 0)
        {
            ZFSettingAddressViewController *addVC = [[ZFSettingAddressViewController alloc]init];
            [self.navigationController pushViewController:addVC animated:YES];
        }
    }
   
}


@end
