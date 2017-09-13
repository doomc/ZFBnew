//
//  CouponTableView.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CouponTableView.h"
#import "CouponCell.h"

@implementation CouponTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{

    [self registerNib:[UINib nibWithNibName:@"CouponCell" bundle:nil] forCellReuseIdentifier:@"CouponCellid"];
    self.backgroundColor = RGBA(244, 244, 244, 1);
    
}
#pragma mark - UITableViewDataSource

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
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = nil;
    
    if (headerView == nil) {
        
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 44)];
        headerView.backgroundColor = [UIColor cyanColor];
        
        UILabel * title = [[UILabel alloc]init];
        title.text  = @"领取优惠券";
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor darkGrayColor];
        [headerView addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView);
            make.centerY.equalTo(headerView);
        }];
        
        UIButton * close = [UIButton buttonWithType:UIButtonTypeCustom];
        [close setImage:[UIImage imageNamed:@"closeRed"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(didClickClosed:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:close];
        
        [close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerView).with.offset(-15);
            make.top.equalTo(headerView).with.offset(6);
            make.size.mas_offset(CGSizeMake(32, 32));
        }];
        
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  44;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCellid" forIndexPath:indexPath];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld ==== row",indexPath.row);
}


#pragma mark - 关闭方法 抛出代理
-(void)didClickClosed:(UIButton *)sender
{
    if ([self.popDelegate respondsToSelector:@selector(didClickCloseCouponView)]) {
        [self.popDelegate didClickCloseCouponView];
    }
}
 



@end
