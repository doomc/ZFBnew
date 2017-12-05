//
//  ZFPregressCheckViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFPregressCheckViewController.h"
#import "ZFPregressCheckCell.h"
#import "LogisticsProgressCell.h"

#import "CheckModel.h"

@interface ZFPregressCheckViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * _status;
    NSString * _serviceNum;
    NSString * _createTime;
    NSString * _reason;
}
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * listArray;

@end

@implementation ZFPregressCheckViewController

-(NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请退货";
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFPregressCheckCell" bundle:nil] forCellReuseIdentifier:@"ZFPregressCheckCellid"];
 
    [self.tableView registerNib:[UINib nibWithNibName:@"LogisticsProgressCell" bundle:nil] forCellReuseIdentifier:@"LogisticsProgressCell"];
 }

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH) style:UITableViewStylePlain];
        _tableView.delegate =self ;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    if (section == 0) {
        return 1;
    }else{
        return self.listArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =  0;
    if (indexPath.section == 0) {
        height  = 150 +40;
    }else{
        height = [tableView fd_heightForCellWithIdentifier:@"LogisticsProgressCell" cacheByIndexPath:indexPath configuration:^(LogisticsProgressCell * cell) {
            
            [self configCell:cell withIndexPath:indexPath];
          }];
        
    }

    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        ZFPregressCheckCell * CheckCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFPregressCheckCellid" forIndexPath:indexPath];
        
        CheckCell.lb_status.text = [NSString stringWithFormat:@"当前状态:%@",_status];
        CheckCell.lb_applyTime.text = [NSString stringWithFormat:@"申请时间:%@",_createTime];
        CheckCell.lb_serviceNum.text = [NSString stringWithFormat:@"服务单号:%@",_serviceNum];
        CheckCell.lb_reason.text = [NSString stringWithFormat:@"申请原因:%@",_reason];

        return CheckCell;

    }else{
       
        LogisticsProgressCell * logCell = [self.tableView dequeueReusableCellWithIdentifier:@"LogisticsProgressCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            logCell.line_up.hidden = YES;
            [logCell.status_btn setImage:[UIImage imageNamed:@"speed2"] forState:UIControlStateNormal];
            logCell.lb_date.textColor = HEXCOLOR(0xf95a70);
            logCell.lb_infoMessage.textColor = HEXCOLOR(0xf95a70);
            
        }else if (indexPath.row == self.listArray.count - 1) {
            logCell.line_down.hidden = YES;
        }else {
            logCell.line_down.hidden = NO;
            logCell.line_up.hidden = NO;
        }
        [self configCell:logCell withIndexPath:indexPath];
        return logCell;
  
    }

}

-(void)configCell:(LogisticsProgressCell *)Cell withIndexPath :(NSIndexPath*)indexPath
{
    CheckList  * list = self.listArray[indexPath.row];
    Cell.checklist = list;
    Cell.fd_isTemplateLayoutCell = YES;
 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld == section ，%ld == row",indexPath.section,indexPath.row);
 
}


#pragma mark - 进度查询列表     zfb/InterfaceServlet/afterSale/queryById
-(void)salesAfterPostRequste
{
    NSDictionary * param = @{

                             @"afterSaleId":_afterSaleId,
                             
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/afterSale/queryById"] params:param success:^(id response) {
 
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.listArray.count > 0 ) {
                [self.listArray removeAllObjects];
            }
            CheckModel * check  = [CheckModel mj_objectWithKeyValues:response];
            _status =  check.data.info.status;
            _serviceNum = check.data.info.serviceNum;
            _createTime = check.data.info.createTime;
            _reason = check.data.info.reason;
            for (CheckList * list in check.data.list) {
                [self.listArray addObject:list];
            }
            [self.tableView reloadData];
            NSLog(@" arr = ==== %@",self.listArray);

        }
        [SVProgressHUD dismiss];

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self salesAfterPostRequste];
}
@end
