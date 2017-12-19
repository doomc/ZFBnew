//
//  SearchTabView.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchTabView.h"
#import "ScreenCell.h"
@interface SearchTabView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSIndexPath * _currentIndexPath;
}
@property (nonatomic ,strong) UIView *coverView;//背景覆盖视图
@property (nonatomic ,strong) UITableView * tableView;

@end

@implementation SearchTabView


-(instancetype)initWithFrame:(CGRect)frame AndDataCount:(NSInteger)count
{
    if (self = [super initWithFrame:frame]) {
        self.count = count;
        [self creatUI];
    }
    return self;
}


-(void)creatUI{
    
    //生成一个蒙版
    _coverView = [[UIView alloc]initWithFrame:self.bounds];
    _coverView.backgroundColor = RGBA(0, 0, 0, 0.3);
//    _coverView.userInteractionEnabled = YES;
//    UITapGestureRecognizer * tap =[[ UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didCoverView)];
//    tap.delegate = self;
//    [_coverView addGestureRecognizer:tap];
    [self addSubview:_coverView];
    
    //蒙版上添加一个Tabview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 45*self.count) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
    [_tableView registerNib:[UINib nibWithNibName:@"ScreenCell" bundle:nil] forCellReuseIdentifier:@"ScreenCell"];
    [_coverView addSubview:_tableView];
  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScreenCell * cell  = [self.tableView dequeueReusableCellWithIdentifier:@"ScreenCell" forIndexPath:indexPath];
    [cell.selectImg setHidden:YES];
    cell.lb_name.text = _dataArray[indexPath.row];
    return cell;
 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentIndexPath = indexPath;
    NSInteger count = _currentIndexPath.row;
    ScreenCell * cell = (ScreenCell *)[tableView cellForRowAtIndexPath:_currentIndexPath];
    cell.lb_name.textColor = HEXCOLOR(0xf95a70);
    [cell.selectImg setHidden:NO];
    //0 降序 1升序
    if (self.indexBlock) {
        self.indexBlock(count);
        [self didCoverView];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScreenCell * cell = (ScreenCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.lb_name.textColor = HEXCOLOR(0x333333);
    [cell.selectImg setHidden:YES];
}

-(void)didCoverView
{
    [self removeFromSuperview];
}

@end
