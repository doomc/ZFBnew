//
//  SendMessageView.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SendMessageView.h"
#import "ZFContactCell.h"
@interface SendMessageView ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic , strong) NSArray *  titleArray;
@property (nonatomic , strong) NSArray *  detailTitleArray;
@property (nonatomic , strong) UITableView * tableView;

@end
@implementation SendMessageView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self creatUI];
        
    }
    return self;
}

-(void)creatUI{
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    self.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    self.layer.borderWidth = 0.5;
    
    _titleArray = @[@"收货人:",@"收货人电话:",@"收货地址:",@"配送费:",@"商家电话:",@"商家地址:",];
    _detailTitleArray = @[@"随便写的:",@"没有数据",@"没有数据",@"没有数据",@"没有数据:",@"没有数据",];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFContactCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self addSubview:self.tableView];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource= self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithWhite:0.845 alpha:1.000];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFContactCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lb_title.text = _titleArray[indexPath.row];
    cell.lb_detailTitle.text = _detailTitleArray[indexPath.row];
    [cell.lb_line removeFromSuperview];
    return cell;
}



@end
