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

@interface ZFHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
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
    NSLog(@"清空")
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
    Cmgoodsinfo * info =self.listArray[indexPath.section];
    historyCell.lb_title.text = info.goodsName;
    historyCell.lb_price.text =[NSString stringWithFormat:@"¥%@",info.storePrice];
    [historyCell.img_collctView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",info.coverImgUrl]] placeholderImage:[UIImage imageNamed:@""]];
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


#pragma mark - 收藏列表 -getSkimFootprintsList
-(void)showhistoryListPOSTRequest
{
    
    [SVProgressHUD show];
    NSDictionary * parma = @{
                             @"svcName":@"getSkimFootprintsList",
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:zfb_url parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            if (self.listArray.count >0) {
                
                [self.listArray  removeAllObjects];
                
            }else{
                
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                
                HistoryFootModel * history = [HistoryFootModel mj_objectWithKeyValues:jsondic];
                for (Cmgoodsinfo * info in  history.cmScanFoolprintsList.cmGoodsInfo ) {
                    [self.listArray addObject:info];
                }
                NSLog(@" -  - - -- - - -- - -%@ - --- -- - - -- - -",self.listArray);
                
                [self.tableView reloadData];
 
                
                [SVProgressHUD dismiss];
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
    }];
    
}

-(NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray =[NSMutableArray array];
    }
    return _listArray;
}
@end
