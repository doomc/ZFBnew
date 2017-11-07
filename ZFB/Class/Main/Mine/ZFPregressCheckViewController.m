//
//  ZFPregressCheckViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFPregressCheckViewController.h"
#import "ZFPregressCheckCell.h"
#import "ZFPregressCheckCell2.h"

#import "CheckModel.h"

@interface ZFPregressCheckViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * _status;
    NSString * _serviceNum;
    NSString * _createTime;
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
 
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFPregressCheckCell2" bundle:nil] forCellReuseIdentifier:@"ZFPregressCheckCellid2"];
 }

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH) style:UITableViewStyleGrouped];
        _tableView.delegate =self ;
        _tableView.dataSource = self;
 

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
    }
    else
    {
        return self.listArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =  0;
    if (indexPath.section == 0) {
     
        height  = 92;
        
    }else{
        height = 76;
        
//        height = [tableView fd_heightForCellWithIdentifier:@"ZFPregressCheckCellid2" cacheByIndexPath:indexPath configuration:^(ZFPregressCheckCell2 * cell) {
//            
//            [self configCell:cell withIndexPath:indexPath];
//          }];
        
    }

    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.001;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        ZFPregressCheckCell * CheckCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFPregressCheckCellid" forIndexPath:indexPath];
        
        CheckCell.lb_status.text = [NSString stringWithFormat:@"当前状态:%@",_status];
        CheckCell.lb_applyTime.text = [NSString stringWithFormat:@"申请时间:%@",_createTime];
        CheckCell.lb_serviceNum.text = [NSString stringWithFormat:@"服务单号:%@",_serviceNum];
        
        return CheckCell;

    }else{
       
        ZFPregressCheckCell2 * CheckCell2 = [self.tableView dequeueReusableCellWithIdentifier:@"ZFPregressCheckCellid2" forIndexPath:indexPath];
        [self configCell:CheckCell2 withIndexPath:indexPath];
        return CheckCell2;
  
    }

}

-(void)configCell:(ZFPregressCheckCell2 *)Cell withIndexPath :(NSIndexPath*)indexPath
{
    CheckList  * list = self.listArray[indexPath.row];
    Cell.list = list;
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
            
            for (CheckList * list in check.data.list) {
                
                [self.listArray addObject:list];
            }
            
            NSLog(@" arr = ==== %@",self.listArray);
            [self.tableView reloadData];

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
