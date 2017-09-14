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
#pragma mark - UITableViewDelegate
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  44+40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = nil;
    
    if (headerView == nil) {
        
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 84)];
        headerView.backgroundColor = RGBA(244, 244, 244, 1);

        UILabel * title = [[UILabel alloc]init];
        title.text  = @"领取优惠券";
        title.font = [UIFont systemFontOfSize:16];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor darkGrayColor];
        [headerView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView);
            make.top.equalTo(headerView).with.offset(12);
        }];

        
        //线
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, KScreenW, 0.5)];
        line.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:line];
        
        UIButton * close = [UIButton buttonWithType:UIButtonTypeCustom];
        [close setImage:[UIImage imageNamed:@"compose_delete"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(didClickClosed:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:close];
        
        [close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerView).with.offset(-15);
            make.top.equalTo(headerView).with.offset(6);
            make.size.mas_offset(CGSizeMake(32, 32));
        }];
        
        UILabel * tag = [[UILabel alloc]initWithFrame:CGRectMake(15, 54, KScreenW, 20)];
        tag.text  = @"可领优惠券";
        tag.font = [UIFont systemFontOfSize:15];
        tag.textAlignment = NSTextAlignmentLeft;
        tag.textColor = [UIColor darkGrayColor];
        [headerView addSubview:tag];
        
    }
    return headerView;
}
#pragma mark - UITableViewDataSource
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCellid" forIndexPath:indexPath];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"内容 _couponeMessage =%@  , row = %ld ",_couponeMessage,indexPath.row);
    
    if ([self.popDelegate respondsToSelector:@selector(selectCouponWithIndex:withResult:)]) {
        [self.popDelegate selectCouponWithIndex:indexPath.row withResult:_couponeMessage];
    }
}


#pragma mark - 关闭方法 抛出代理
-(void)didClickClosed:(UIButton *)sender
{
    if ([self.popDelegate respondsToSelector:@selector(didClickCloseCouponView)]) {
        [self.popDelegate didClickCloseCouponView];
    }
}
 



@end
