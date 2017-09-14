//
//  SelectPayTypeView.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SelectPayTypeView.h"
#import "SelectPayTypeCell.h"
@implementation SelectPayTypeView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerNib:[UINib nibWithNibName:@"SelectPayTypeCell" bundle:nil] forCellReuseIdentifier:@"SelectPayTypeCell"];
    }
    return self;
}


-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = nil;
    if (headView == nil) {
        
        headView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, KScreenW, 20)];
        headView.backgroundColor = RGBA(244, 244, 244, 1);
        
        UILabel * title = [[UILabel alloc]init];
        title.text  = @"支付方式";
        title.font = [UIFont systemFontOfSize:16];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor darkGrayColor];
        [headView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headView);
            make.top.equalTo(headView).with.offset(12);
        }];
        
        UIButton * close_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [close_btn setImage:[UIImage imageNamed:@"compose_delete"] forState:UIControlStateNormal];
        [close_btn addTarget:self action:@selector(didClickClosed:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:close_btn];
        
        [close_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headView).with.offset(-15);
            make.top.equalTo(headView).with.offset(6);
            make.size.mas_offset(CGSizeMake(32, 32));
        }];

    }
    return headView;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectPayTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SelectPayTypeCell" forIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld ==== row",indexPath.row);
    if ([self.PayTypeDelegate respondsToSelector:@selector(didClickWithIndex:)]) {
        [self.PayTypeDelegate didClickWithIndex:indexPath.row];
    }
}


#pragma mark - 关闭方法 抛出代理
-(void)didClickClosed:(UIButton *)sender
{
    if ([self.PayTypeDelegate respondsToSelector:@selector(didClickClosePayTypeView)]) {
        [self.PayTypeDelegate didClickClosePayTypeView];
    }
}


@end
