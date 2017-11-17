//
//  SalesAfterPopView.m
//  ZFB
//
//  Created by 熊维东 on 2017/7/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  自定义派单

#import "SalesAfterPopView.h"
#import "BusinessSendoOrderCell.h"

@interface SalesAfterPopView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger  indexpathRow;
    NSString  * whichOneReason;
}
@property (nonatomic , strong) UIView * headerView;
@property (nonatomic , strong) UILabel * lb_reason;
@property (nonatomic , strong) UIButton * headcloseButton;
@property (nonatomic , strong) UITableView * alertTableView;
@property (nonatomic , strong) NSArray * reasonArray;


@end
@implementation SalesAfterPopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4;
        [self initUI];
    }
    return self;
}

-(void)initUI{
 
    _reasonArray = @[@"三天无理由退货",@"质量问题",@"商品与描述不符",@"买家发错货",@"发票问题",@"其他"];
    [self addSubview:self.alertTableView];//创建tableview

    self.alertTableView.tableHeaderView = self.headerView;
    self.alertTableView.tableHeaderView.height =  40;
    
    //nib
    [self.alertTableView registerNib:[UINib nibWithNibName:@"BusinessSendoOrderCell" bundle:nil] forCellReuseIdentifier:@"BusinessSendoOrderCell"];
}

-(UITableView *)alertTableView
{
    if (!_alertTableView) {
        _alertTableView =[[ UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
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
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, self.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_headerView addSubview:line];
        [_headerView addSubview:self.lb_reason];
        [_headerView addSubview:self.headcloseButton];
        
    }
    return _headerView;
}
-(UILabel *)lb_reason{
    if (!_lb_reason) {
        _lb_reason = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.frame.size.width -30, 40)];
        _lb_reason.text = @"申请原因";
        _lb_reason.textAlignment = NSTextAlignmentCenter;
        _lb_reason.font = [UIFont systemFontOfSize: 15];
        _lb_reason.textColor = HEXCOLOR(0x363636);
        
    }
    return _lb_reason;
}
-(UIButton *)headcloseButton
{
    if (!_headcloseButton) {
        _headcloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headcloseButton.frame = CGRectMake(self.frame.size.width -10 - 30, 10, 20, 20);
        [_headcloseButton setImage:[UIImage imageNamed:@"delete_black"] forState:UIControlStateNormal];
        [_headcloseButton bringSubviewToFront:self.lb_reason];
        [_headcloseButton addTarget:self action:@selector(closePopViewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headcloseButton;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource;
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _reasonArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessSendoOrderCell * cell = [self.alertTableView dequeueReusableCellWithIdentifier:@"BusinessSendoOrderCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lb_name.text = _reasonArray[indexPath.row];
    cell.lb_distence.text = @"";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld ---- %ld",indexPath.section,indexPath.row);
        
    whichOneReason = _reasonArray[indexPath.row];

    //选择就直接消失？
    
    if ([self.delegate respondsToSelector:@selector(getReasonString:)]) {
        [self.delegate getReasonString:whichOneReason];
    }

}

-(void)closePopViewAction:(UIButton * )sender
{
    NSLog(@"删除 取消操作 ----");
    if ([self.delegate respondsToSelector:@selector(deletePopView)]) {
        [self.delegate deletePopView];
    }
 
}



@end
