
//
//  ZFSettingAddressViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSettingAddressViewController.h"

@interface ZFSettingAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView * bgview;
@property (nonatomic,strong)UIButton * address_btn;

@end

@implementation ZFSettingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"地址管理";
 
   
    [self.view addSubview:self.tableView];
    [self.tableView setBackgroundView:self.bgview];
    

    
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
-(UIButton *)login_btn
{
    if (!_address_btn) {
        NSString * title = @"添加新的地址";
        _address_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _address_btn.frame = CGRectMake(40, KScreenH - 64 - 60 - 20, KScreenW - 40-40, 40);
        [_address_btn setBackgroundColor:HEXCOLOR(0xfe6d6a)];
        [_address_btn setTitle:title forState:UIControlStateNormal];
        _address_btn.layer.cornerRadius = 5;
        _address_btn.clipsToBounds = YES;
        _address_btn.titleLabel .font = SYSTEMFONT(14);
        [_address_btn addTarget:self action:@selector(addANewAddressTarget:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _address_btn;
    
}

-(UIView *)bgview
{
    if (!_bgview) {
        _bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64)];
        
        UIImageView * placeholder_img = [[UIImageView alloc]init];
        [placeholder_img setCenter:self.view.center];
        placeholder_img.frame = CGRectMake(KScreenW*0.5 - 100, 100, 100, 100);
        placeholder_img.image = [UIImage imageNamed:@"NOAddress"];
        [_bgview addSubview:placeholder_img];
        
        UILabel * lb_tag = [[UILabel alloc]initWithFrame:CGRectMake(KScreenW*0.5 -100, 200, 100, 22)];
        lb_tag.textColor = HEXCOLOR(0x7a7a7a);
        lb_tag.text =@"暂时没有地址~";
        lb_tag.font = SYSTEMFONT(14);
        NSLog(@"%@ =  lb_tag",lb_tag);
        
        [_bgview addSubview:lb_tag];
        
    }
    return _bgview;
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell ) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sectin = %ld,row = %ld",indexPath.section ,indexPath.row);
    
}

-(void)addANewAddressTarget:(UIButton *)sender
{
    NSLog(@"添加新的地址");
}



@end
