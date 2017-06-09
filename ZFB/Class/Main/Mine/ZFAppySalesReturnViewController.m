//
//  ZFAppySalesReturnViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  申请退货

#import "ZFAppySalesReturnViewController.h"
#import "ZFBackWaysViewController.h"

#import "ZFAppySalesReturnCell.h"//退货1
#import "ApplySalesNumCell.h"//申请数量cell
#import "ApplySalesAfterCommonCell.h"//服务类型，退款方式
#import "ApplySalesQuestionCell.h"//描述问题
#import "ZFApplyReasonCell.h"//申请 原因
#import "ApplySalesUploadCell.h"//上传

static NSString * identiferSalesReturnCell = @"ZFAppySalesReturnCellid";
static NSString * identiferNumCell = @"ApplySalesNumCellid";
static NSString * identiferCommonCell = @"ApplySalesAfterCommonCellid";
static NSString * identiferQuestionCell = @"ApplySalesQuestionCellid";
static NSString * identiferReasonCell = @"ZFApplyReasonCellid";
static NSString * identiferUploadCell = @"ApplySalesUploadCellid";

@interface ZFAppySalesReturnViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@end

@implementation ZFAppySalesReturnViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请退货";
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplySalesNumCell" bundle:nil] forCellReuseIdentifier:identiferNumCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplySalesAfterCommonCell" bundle:nil] forCellReuseIdentifier:identiferCommonCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplySalesQuestionCell" bundle:nil] forCellReuseIdentifier:identiferQuestionCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFApplyReasonCell" bundle:nil] forCellReuseIdentifier:identiferReasonCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFAppySalesReturnCell" bundle:nil] forCellReuseIdentifier:identiferSalesReturnCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplySalesUploadCell" bundle:nil] forCellReuseIdentifier:identiferUploadCell];

    
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStyleGrouped];
        _tableView.delegate =self ;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    else
    {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80;
        }else  if (indexPath.row == 1) {
            return 70;
        }
        else{
            return 40;
        }
    }
    if (indexPath.section == 1 || indexPath.section == 2    ) {
        
        return 70;
    }
    
   // height =200;
    height =  [tableView fd_heightForCellWithIdentifier:identiferUploadCell configuration:^(id cell) {
        
    }];
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
        if (indexPath.row == 0) {
            ZFAppySalesReturnCell * returnCell = [self.tableView dequeueReusableCellWithIdentifier:identiferSalesReturnCell forIndexPath:indexPath];
            return returnCell;
            
        }else if (indexPath.row == 1) {
            ApplySalesAfterCommonCell * returnCell = [self.tableView dequeueReusableCellWithIdentifier:identiferCommonCell forIndexPath:indexPath];
            return returnCell;
            
        }else{
            ZFApplyReasonCell * reasonCell  = [self.tableView dequeueReusableCellWithIdentifier:identiferReasonCell forIndexPath:indexPath];;
            return reasonCell;
        }
        
    }
    else if (indexPath.section == 1)
    {
        ApplySalesAfterCommonCell * returnCell = [self.tableView dequeueReusableCellWithIdentifier:identiferCommonCell forIndexPath:indexPath];
        return returnCell;
    }
    else if (indexPath.section == 2)
    {
        ApplySalesNumCell * numCell = [self.tableView dequeueReusableCellWithIdentifier:identiferNumCell forIndexPath:indexPath];
        return numCell;
    }
    else if (indexPath.section == 3)
    {
        ApplySalesQuestionCell * questionCell = [self.tableView dequeueReusableCellWithIdentifier:identiferQuestionCell forIndexPath:indexPath];
        return questionCell;
    }else{
        
        ApplySalesUploadCell * uploadCell = [self.tableView dequeueReusableCellWithIdentifier:identiferUploadCell forIndexPath:indexPath];
        return uploadCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld == section ，%ld == row",indexPath.section,indexPath.row);
    
    if (indexPath.section== 4) {
 

        ZFBackWaysViewController *bcVC =[[ ZFBackWaysViewController alloc]init];
        [self.navigationController pushViewController: bcVC animated:YES];
    }
}
-(void)enterNextPage
{
    NSLog(@"i下一步");
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
