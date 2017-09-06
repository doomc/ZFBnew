//
//  ZFHistoryViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFHistoryViewController.h"
#import "ZFHistoryCell.h"
#import "HistoryFootModel.h"

@interface ZFHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,CYLTableViewPlaceHolderDelegate, WeChatStylePlaceHolderDelegate>
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * listArray;

@end

@implementation ZFHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"浏览足记";

    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFHistoryCell" bundle:nil] forCellReuseIdentifier:@"ZFHistoryCellid"];
    [self showhistoryListPOSTRequest];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64 ) style:UITableViewStyleGrouped];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    NSString * saveStr = @"清空";
    UIButton *right_button = [[UIButton alloc]init];
    [right_button setTitle:saveStr forState:UIControlStateNormal];
    right_button.titleLabel.font=SYSTEMFONT(14);
    [right_button setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
    right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width = size.width ;
    right_button.frame =CGRectMake(0, 0, width+10, 22);
    
    return right_button;
}
//设置右边事件
-(void)right_button_event:(UIButton*)sender{
    
    NSLog(@"清空");
    [self.listArray removeAllObjects];
    [self deletFootRemovePOSTRequest];
    [self.tableView reloadData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
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
    ZFHistoryCell * historyCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFHistoryCellid" forIndexPath:indexPath] ;
    Cmscanfoolprintslist * info =self.listArray[indexPath.section];
    historyCell.scanfool = info;

    
    return historyCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sectin = %ld,row = %ld",indexPath.section ,indexPath.row);
    
}

-(void)addANewAddressTarget:(UIButton *)sender
{
    NSLog(@"添加新的地址");
}


#pragma mark - 足记列表 -getSkimFootprintsList
-(void)showhistoryListPOSTRequest
{
    
 
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getSkimFootprintsList"] params:parma success:^(id response) {
        
        if ([response[@"resultCode"]isEqualToString:@"0"]) {
            
            if (self.listArray.count >0) {
                
                [self.listArray  removeAllObjects];
                
            }else{
                
                HistoryFootModel * history = [HistoryFootModel mj_objectWithKeyValues:response];
                for (Cmscanfoolprintslist * info in  history.data.cmScanFoolprintsList ) {
               
                    [self.listArray addObject:info];
                }
            NSLog(@" -  - - -- - - -- - -%@ - --- -- - - -- - -",self.listArray);
            }
            
            [self.tableView reloadData];
            
            if ([self isEmptyArray:self.listArray]) {
             
                [self.tableView cyl_reloadData];
            }
        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
       
}

#pragma mark - 清空历史足迹 -getSkimFootRemove

-(void)deletFootRemovePOSTRequest
{
    
    
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"id":@"",
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getSkimFootRemove"] params:parma success:^(id response) {
        
        if ([response[@"resultCode"]isEqualToString:@"0"]) {
            
            [self.view makeToast:@"清空成功" duration:2 position:@"center"];
            [self.tableView reloadData];

            }
        }
        
        progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}



-(NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray =[NSMutableArray array];
    }
    return _listArray;
}


#pragma mark - CYLTableViewPlaceHolderDelegate Method
- (UIView *)makePlaceHolderView {

    UIView *weChatStyle = [self weChatStylePlaceHolder];
    return weChatStyle;
}
//暂无数据
- (UIView *)weChatStylePlaceHolder {
    
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.tableView.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}
#pragma mark - WeChatStylePlaceHolderDelegate Method
- (void)emptyOverlayClicked:(id)sender {
    
    [self showhistoryListPOSTRequest];
    
}

@end
