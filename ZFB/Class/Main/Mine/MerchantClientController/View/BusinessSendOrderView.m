//
//  BusinessSendOrderView.m
//  ZFB
//
//  Created by 熊维东 on 2017/7/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  自定义派单

#import "BusinessSendOrderView.h"
#import "BusinessSendoOrderCell.h"
#import "DeliveryModel.h"
@interface BusinessSendOrderView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UIView * headerView;
@property (nonatomic , strong) UIView * footerView;

@property (nonatomic , strong) UILabel * lb_SendArea;
@property (nonatomic , strong) UIButton * headcloseButton;

@property (nonatomic , strong) UIButton * footcancelButton;
@property (nonatomic , strong) UIButton * footcloseButton;


@property (nonatomic , strong) UITableView * alertTableView;

@end
@implementation BusinessSendOrderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
        self.layer.cornerRadius = 4;
        [self initUI];
    }
    return self;
}

-(void)initUI{
 
    [self addSubview:self.alertTableView];//创建tableview
    [self addSubview:self.footerView];

    self.alertTableView.tableHeaderView = self.headerView;
    self.alertTableView.tableHeaderView.height =  40;
    
    //nib
    [self.alertTableView registerNib:[UINib nibWithNibName:@"BusinessSendoOrderCell" bundle:nil] forCellReuseIdentifier:@"BusinessSendoOrderCell"];
}
//数据源
-(NSMutableArray *)deliveryArray
{
    if (!_deliveryArray) {
        _deliveryArray= [NSMutableArray array];
    }
    return _deliveryArray;
}
-(UITableView *)alertTableView
{
    if (!_alertTableView) {
        _alertTableView =[[ UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40) style:UITableViewStylePlain];
        _alertTableView.delegate = self;
        _alertTableView.dataSource =self;
        _alertTableView.separatorStyle = UITableViewScrollPositionNone;
    }
    return _alertTableView;
}
/**
 *  headerView
 *
 *  @return headerView
 */
-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        [_headerView addSubview:self.lb_SendArea];
        [_headerView addSubview:self.headcloseButton];
        
    }
    return _headerView;
}
-(UILabel *)lb_SendArea{
    if (!_lb_SendArea) {
        _lb_SendArea = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, self.frame.size.width - 15- 60, 30)];
//        _lb_SendArea.text = @"派送区域：渝北区-冉家坝";
        _lb_SendArea.font = [UIFont systemFontOfSize: 15];
        _lb_SendArea.textColor = HEXCOLOR(0x363636);
        
    }
    return _lb_SendArea;
}
-(UIButton *)headcloseButton
{
    if (!_headcloseButton) {
        _headcloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headcloseButton.frame = CGRectMake(self.frame.size.width -10 - 30, 10, 20, 20);
        [_headcloseButton setImage:[UIImage imageNamed:@"delete_sku"] forState:UIControlStateNormal];
        [_headcloseButton addTarget:self action:@selector(closePopViewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headcloseButton;
}
/**
 *  footerview的视图
 *
 *  @return footerview
 */
-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
        [_footerView addSubview:self.footcloseButton];
        [_footerView addSubview:self.footcancelButton];
        _footerView.backgroundColor = HEXCOLOR(0xffcccc);
    }
    return _footerView;
}
-(UIButton *)footcancelButton
{
    if (!_footcancelButton) {
        _footcancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _footcancelButton.frame = CGRectMake(0, 1,self.frame.size.width/2-1 , 39);
        [_footcancelButton setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal ];
        [_footcancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _footcancelButton.backgroundColor = HEXCOLOR(0xffffff);
        [_footcancelButton  setTitle:@"取消" forState:UIControlStateNormal];
        [_footcancelButton addTarget:self action:@selector(closePopViewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footcancelButton;
}
-(UIButton *)footcloseButton
{
    if (!_footcloseButton) {
        _footcloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footcloseButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _footcloseButton.frame = CGRectMake(self.frame.size.width/2, 1,self.frame.size.width/2 , 39);
        [_footcloseButton setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal ];
        _footcloseButton.backgroundColor = HEXCOLOR(0xffffff);
        [_footcloseButton  setTitle:@"确定" forState:UIControlStateNormal];
        [_footcloseButton addTarget:self action:@selector(closePopViewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footcloseButton;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource;
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Deliverylist * list = self.deliveryArray[indexPath.row];
    
    BusinessSendoOrderCell * cell = [self.alertTableView dequeueReusableCellWithIdentifier:@"BusinessSendoOrderCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lb_SendArea.text =[NSString stringWithFormat:@"派送区域:%@",list.deliveryArea];
    cell.listmodel = list;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld ---- %ld",indexPath.section,indexPath.row);

    //选择就直接消失？
    //[self removeFromSuperview];

    //需要配送员信息，姓名电话什么的
    Deliverylist * list = self.deliveryArray[indexPath.row];

    if ([self.delegate respondsToSelector:@selector(didClickPushdeliveryId:deliveryName:deliveryPhone:Index:)]) {
        [self.delegate didClickPushdeliveryId:[NSString stringWithFormat:@"%ld",list.deliveryId]  deliveryName:list.deliveryName deliveryPhone:list.deliveryPhone  Index:indexPath.row];
    }

}

 

-(void)closePopViewAction:(UIButton * )sender
{
    NSLog(@"方法 ----");
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"取消隐藏");
}


@end