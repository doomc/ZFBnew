//
//  ZFAddressListViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  收货地址列表

#import "ZFAddressListViewController.h"
#import "EditAddressViewController.h"
#import "ZFAddOfListCell.h"
#import "AddressListModel.h"
@interface ZFAddressListViewController ()<UITableViewDataSource,UITableViewDelegate,AddressCellDelegate>

@property (nonatomic,strong) UITableView * mytableView;
@property (nonatomic,strong) NSMutableArray * listArray;
@property (nonatomic,strong) NSMutableArray * tempCellArray;
@end

@implementation ZFAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"选择收货地址";

    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64-49) style:UITableViewStylePlain];
    self.mytableView.delegate= self;
    self.mytableView.dataSource = self;
    [self.view addSubview:self.mytableView];
    
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFAddOfListCell" bundle:nil] forCellReuseIdentifier:@"ZFAddOfListCellid"];
    
    [self customFooterView];
    
    [self savedInfoMessagePostRequst];
    
}
-(void)customFooterView
{
 
    UIView *  footerView = [[UIView alloc]initWithFrame:CGRectMake(0 , KScreenH -49, KScreenW, 69)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIFont * font  =[UIFont systemFontOfSize:14];
    [self.view addSubview:footerView];

    NSString * str = @"增加地址";
    UIButton * status =  [UIButton  buttonWithType:UIButtonTypeCustom];
    status.layer.cornerRadius = 4;
    status.clipsToBounds = YES;
    status.titleLabel.font = font;
    [status setTitle:str forState:UIControlStateNormal];
    status.backgroundColor = HEXCOLOR(0xfe6d6a);
    [status setTitleColor: HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [status addTarget:self action:@selector(didclickAdd:) forControlEvents:UIControlEventTouchUpInside];
    status.frame =CGRectMake(15, 5, KScreenW - 30, 40);
    [footerView addSubview:status];
    
    UILabel *lineUP =[[UILabel alloc]initWithFrame:CGRectMake(0,0, KScreenW, 0.5)];
    lineUP.backgroundColor = HEXCOLOR(0xdedede);
    [footerView addSubview:lineUP];
    
    
}
-(void)didclickAdd:(UIButton*)add
{
    NSLog(@"添加地址");
    EditAddressViewController * editVC = [[EditAddressViewController alloc]init];
    
    [self.navigationController pushViewController:editVC animated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat actualHeight = [tableView fd_heightForCellWithIdentifier:@"ZFAddOfListCellid" cacheByIndexPath:indexPath configuration:^(ZFAddOfListCell *cell) {
        
        [self configCell:cell indexPath:indexPath];
        
    }];
    return actualHeight >= 100 ? actualHeight : 92;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFAddOfListCell * addCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFAddOfListCellid" forIndexPath:indexPath];
    addCell.selectionStyle  = UITableViewCellSelectionStyleNone;
    [self configCell:addCell indexPath:indexPath];
   
    addCell.indexPath = indexPath;
    addCell.delegate = self;
    
    return addCell;
}
//组装cell 方便返回的高度
- (void)configCell:(ZFAddOfListCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Cmuserinfo * info = self.listArray[indexPath.row];
    cell.lb_detailArress.text = info.postAddress;
    cell.lb_nameAndphoneNum.text =[NSString stringWithFormat:@"%@  %@",info.contactUserName,info.contactMobilePhone];
   
    if ([info.defaultFlag isEqualToString:@"1"]) {
        //设置默认
        cell.defaultButton.hidden = NO;
    }else{
        //隐藏默认按钮
        cell.defaultButton.hidden = YES;

    }
}
#pragma mark - AddressCellDelegate
///删除操作
-(void)deleteAction :(ZFAddOfListCell *)cell{
    
    [self.tempCellArray removeAllObjects];
    [self.tempCellArray addObject:cell];
    
    JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"确认删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSIndexPath *indexpath = [self.mytableView indexPathForCell:self.tempCellArray.firstObject];
        Cmuserinfo * info = self.listArray[indexpath.row];
    
        if (self.listArray.count == 1) {
            [self.listArray removeObject:info];
        }
     
        [self updateInfomation];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    [self presentViewController:alertVC animated:YES completion:nil];

}
///编辑操作
-(void)editAction:(NSIndexPath * )indexPath
{
    EditAddressViewController  * VC= [[EditAddressViewController alloc]init];
    if (self.listArray.count > 0 ) {
        
        Cmuserinfo * info = self.listArray[indexPath.row];
        NSLog(@"info=====postAddressId %@",info.postAddressId);
        VC.defaultFlag =   info.defaultFlag;  //是否默认
        VC.postAddressId =  info.postAddressId;//收货地址ID
        [self.mytableView reloadData];
    }
    
    [self.navigationController pushViewController:VC animated:NO];

}
//更新数据
- (void)updateInfomation
{
    //删除对应的model 再请求服务器

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning  ========== 问题！！！ indexPath 获取不到

    ZFAddOfListCell  *cell = (ZFAddOfListCell *) [self.mytableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%ld- %ld",indexPath.section,indexPath.row);

    cell.selected = !cell.selected;
    
    if (cell.selected) {
        
        cell.selectedButton.selected = YES;
        
    }else{
        
        cell.selectedButton.selected = NO;
    }
    
}

#pragma mark -   保存用户信息getCmUserAdderss
-(void)savedInfoMessagePostRequst
{
     NSDictionary * parma = @{
                             
                             @"svcName":@"getCmUserAdderss",
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [SVProgressHUD show];
    
    [PPNetworkHelper POST:zfb_url parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            if (self.listArray.count >0) {
                
                [self.listArray removeAllObjects];
            }
            NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
            NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];

            AddressListModel * list = [AddressListModel mj_objectWithKeyValues:jsondic];
            for (Cmuserinfo * info in list.cmUserInfo) {
 
                [self.listArray addObject:info];
            }
            NSLog(@"%@ ==== listArray",self.listArray);
            
            [self.mytableView reloadData];
            [SVProgressHUD dismiss];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
    }];
    
    
}
-(NSMutableArray *)listArray
{
    if (!_listArray ) {
        _listArray =[NSMutableArray  array];
    }
    return _listArray;
}

- (NSMutableArray *)tempCellArray
{
    if (_tempCellArray == nil) {
        _tempCellArray = [[NSMutableArray alloc] init];
    }
    return _tempCellArray;
}
@end
