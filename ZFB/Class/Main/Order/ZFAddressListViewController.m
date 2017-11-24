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

@property (nonatomic,copy) NSString * postAddressId;

@end

@implementation ZFAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"选择收货地址";
 
    
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-49 - 64) style:UITableViewStyleGrouped];
    self.mytableView.delegate= self;
    self.mytableView.dataSource = self;
    self.mytableView.backgroundColor = HEXCOLOR(0xf7f7f7);
    [self.view addSubview:self.mytableView];
    
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFAddOfListCell" bundle:nil] forCellReuseIdentifier:@"ZFAddOfListCellid"];
    
    [self customFooterView];
    
    
}
-(void)customFooterView
{
 
    UIView *  footerView = [[UIView alloc]initWithFrame:CGRectMake(0 , KScreenH -49 -64, KScreenW, 69)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIFont * font  =[UIFont systemFontOfSize:14];
    [self.view addSubview:footerView];

    NSString * str = @"增加地址";
    UIButton * status =  [UIButton  buttonWithType:UIButtonTypeCustom];
    status.layer.cornerRadius = 4;
    status.clipsToBounds = YES;
    status.titleLabel.font = font;
    [status setTitle:str forState:UIControlStateNormal];
    status.backgroundColor = HEXCOLOR(0xf95a70);
    [status setTitleColor: HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [status addTarget:self action:@selector(didclickAdd:) forControlEvents:UIControlEventTouchUpInside];
    status.frame =CGRectMake(15, 5, KScreenW - 30, 40);
    [footerView addSubview:status];
    
    UILabel *lineUP =[[UILabel alloc]initWithFrame:CGRectMake(0,0, KScreenW, 0.5)];
    lineUP.backgroundColor = HEXCOLOR(0xdedede);
    [footerView addSubview:lineUP];
    
    
}

#pragma mark  - 添加收货地址
-(void)didclickAdd:(UIButton*)add
{
    NSLog(@"添加地址");
    
    EditAddressViewController * editVC = [[EditAddressViewController alloc]init];
    editVC.postAddressId = @"";
    [self.navigationController pushViewController:editVC animated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = nil;
    if (!headView ) {
        headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 10)];
    }
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footView = nil;
    if (!footView ) {
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 0.001)];
    }
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat actualHeight = [tableView fd_heightForCellWithIdentifier:@"ZFAddOfListCellid" cacheByIndexPath:indexPath configuration:^(ZFAddOfListCell *cell) {
//
//        [self configCell:cell indexPath:indexPath];
//
//    }];
//    return actualHeight >= 114 ? actualHeight : 92;

    return 114;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFAddOfListCell * addCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFAddOfListCellid" forIndexPath:indexPath];
    
    addCell.indexPath = indexPath;
    addCell.delegate = self;
    
    [self configCell:addCell indexPath:indexPath];

    
    return addCell;
}

//组装cell 方便返回的高度
- (void)configCell:(ZFAddOfListCell *)cell indexPath:(NSIndexPath *)indexPath
{
    Useraddresslist * info = self.listArray[indexPath.section];
    cell.list = info;
    
    if ( cell.defaultFlag == 1) {
        //设置默认
        cell.selectedButton.selected = YES;
    }else{
        //隐藏默认按钮
        cell.selectedButton.selected = NO;
    }
    

}
//当前选中的状态 暂时没有用到
-(void)selecteStatus :(BOOL)isSelected
{
    //更改了状态的回调数据
    [self.mytableView reloadData];
    
}
#pragma mark - AddressCellDelegate
///删除操作
-(void)deleteAddress:(NSIndexPath *)indexPath
//-(void)deleteAction :(ZFAddOfListCell *)cell
{
    
//    [self.tempCellArray removeAllObjects];
//    [self.tempCellArray addObject:cell];
    
    JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"确认删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        Useraddresslist * info = self.listArray[indexPath.row];
        [self deleteInfoPostRequstWithpostAddressId:[NSString stringWithFormat:@"%ld",info.postAddressId]];
        
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
        
        Useraddresslist * info = self.listArray[indexPath.row];
        
        NSLog(@"info=====postAddressId %ld",info.postAddressId);
        VC.defaultFlag =  [NSString stringWithFormat:@"%ld",info.defaultFlag];  //是否默认
        VC.postAddressId =  [NSString stringWithFormat:@"%ld",info.postAddressId];//收货地址ID
       
        [self.mytableView reloadData];
    }
    
    [self.navigationController pushViewController:VC animated:NO];

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Useraddresslist * info = self.listArray[indexPath.section];

    NSLog(@"%ld- %ld",indexPath.section,indexPath.row);

    [self backAction];
    if (_orderBackBlock) {
        NSString * possId = [NSString stringWithFormat:@"%ld",info.postAddressId];
        _orderBackBlock(info.contactUserName, info.postAddress, info.contactMobilePhone,possId);
  
    }
}

#pragma mark -    收货地址列表getCmUserAdderss
-(void)getuserInfoMessagePostRequst
{
     NSDictionary * parma = @{
                             
                              @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmUserAdderss",zfb_baseUrl] params:parma success:^(id response) {
       
        NSString * code = [NSString stringWithFormat:@"%@", response[@"resultCode"]];
        if  ([code isEqualToString:@"0"])
        {
            if (self.listArray.count > 0) {
                [self.listArray removeAllObjects];
            }
            AddressListModel * list = [AddressListModel mj_objectWithKeyValues:response];
            
            for (Useraddresslist * addresslist in list.addressList.userAddressList) {
                
                [self.listArray addObject:addresslist];
            }
            [self.mytableView reloadData];
            [SVProgressHUD dismiss];

        }else{
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];

        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
 
    
}

#pragma mark -    删除收货地址列表getDelUserAddressInfo
-(void)deleteInfoPostRequstWithpostAddressId :(NSString *)postAddressId
{
    NSDictionary * parma = @{
                             @"postAddressId":postAddressId,
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getDelUserAddressInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] intValue ]== 0) {
          
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            [self getuserInfoMessagePostRequst];
            
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}

 
-(void)viewWillAppear:(BOOL)animated{

    [self getuserInfoMessagePostRequst];

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
