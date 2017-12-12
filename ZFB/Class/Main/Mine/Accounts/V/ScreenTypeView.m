

//
//  ScreenTypeView.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ScreenTypeView.h"
#import "MKJTagViewTableViewCell.h"

static NSString * identifier = @"MKJTagViewTableViewCell";

@interface ScreenTypeView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView  * tableView;
@property (nonatomic , strong) NSArray  * tagList;

@end

@implementation ScreenTypeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatUI];
        self.backgroundColor = [UIColor whiteColor];
        _titles = @[@"全部",@"转账",@"退款",@"充值 ",@"订单",@"提现",@"佣金"];
        
    }
    return self;
}


-(void)creatUI{
 
    _tableView = [[UITableView alloc] initWithFrame:self.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];

    [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];

}

#pragma mark -  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView fd_heightForCellWithIdentifier:identifier configuration:^(id cell) {
        
        [self configCell:cell indexpath:indexPath];
    }];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
        if (view == nil) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel * hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW, 40)];
            hotLabel.text = @"按分类选择";
            hotLabel.font = SYSTEMFONT(14);
            hotLabel.textColor = HEXCOLOR(0x333333);
            [view addSubview:hotLabel];
            return  view;
        }
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = nil;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;

}
#pragma mark -  UITableViewDelegate
//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MKJTagViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configCell:cell indexpath:indexPath];
    return cell;
}

- (void)configCell:(MKJTagViewTableViewCell *)cell indexpath:(NSIndexPath *)indexpath
{
    [cell.tagView removeAllTags];
    cell.tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
    cell.tagView.padding = UIEdgeInsetsMake(15, 20, 10, 15);
    cell.tagView.lineSpacing = 10;
    cell.tagView.interitemSpacing = 20;
    cell.tagView.singleLine = NO;
    // 给出两个字段，如果给的是0，那么就是变化的,如果给的不是0，那么就是固定的
    //        cell.tagView.regularWidth = 80;
    //        cell.tagView.regularHeight = 30;
    
    NSArray * arr = [NSArray arrayWithArray:_titles];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SKTag *tag = [[SKTag alloc] initWithText:arr[idx]];
        
        tag.font = [UIFont systemFontOfSize:14];
        tag.textColor = HEXCOLOR(0x333333);
        tag.bgColor = HEXCOLOR(0xf7f7f7);
        tag.cornerRadius = 4;
        tag.enable = YES;
        tag.padding = UIEdgeInsetsMake(5, 10, 5, 10);
        [cell.tagView addTag:tag];
    }];
    //
    cell.tagView.didTapTagAtIndex = ^(NSUInteger index)
    {
        NSLog(@" 点击了第 ------ %ld",index);
        if ([self.delegate respondsToSelector:@selector(didClickIndex:)]) {
            [self.delegate didClickIndex:index];
        }
    };
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld  ---- %ld",indexPath.section ,indexPath.row);
}

-(void)reloadData
{
    [self.tableView reloadData];
}
@end
