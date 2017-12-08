//
//  CheckSaleafterViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/5.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CheckSaleafterViewController.h"
#import "CheckModel.h"
#import "ZFOrderDetailCell.h"
#import "LoadPictureCell.h"
#import "ZFOrderDetailGoosContentCell.h"
#import "JZLPhotoBrowser.h"

@interface CheckSaleafterViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSString * _price;
    NSString * _goodsCount;
    NSString * _goodsName;
    NSString * _goodsImg;
}
@property (nonatomic , strong) NSMutableArray * listArray;
@property (nonatomic , strong) NSArray * titles;
@property (nonatomic , strong) NSArray * images;

@property (weak, nonatomic) IBOutlet UIButton *checkPass_btn;
@property (weak, nonatomic) IBOutlet UIButton *checkRefuse_btn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CheckSaleafterViewController
-(NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"售后审核";
    _titles = @[@"服务类型",@"退货原因",@"退货问题描述",@"退货方式"];
    [self initInerfaceView];

    [self salesAfterPostRequste];
    
}
-(void)initInerfaceView
{
    _checkPass_btn.layer.masksToBounds = YES;
    _checkPass_btn.layer.cornerRadius = 4;
    _checkRefuse_btn.layer.masksToBounds = YES;
    _checkRefuse_btn.layer.cornerRadius = 4;
    
    _tableView.tableFooterView = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
    
    [self.tableView  registerNib:[UINib nibWithNibName:@"ZFOrderDetailCell" bundle:nil] forCellReuseIdentifier:@"ZFOrderDetailCell"];
    [self.tableView  registerNib:[UINib nibWithNibName:@"LoadPictureCell" bundle:nil] forCellReuseIdentifier:@"LoadPictureCell"];
    [self.tableView  registerNib:[UINib nibWithNibName:@"ZFOrderDetailGoosContentCell" bundle:nil] forCellReuseIdentifier:@"ZFOrderDetailGoosContentCell"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return 4;
    }
    else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =  0;
    if (indexPath.section == 0) {
        height =  130;
    }else if (indexPath.section == 1)
    {
        height= 50;
    }
    else{
        if (_images.count > 0 ) {
            if (_images.count > 3) {
                height = 60 + (KScreenW - 30)/3*2;

            }else{
                height= 60 + (KScreenW - 30)/3;
            }
            
        }else{
            height = 0;
        }
    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZFOrderDetailGoosContentCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFOrderDetailGoosContentCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if (_listArray.count > 0 ) {
            [cell.img_orderDetailView sd_setImageWithURL:[NSURL URLWithString:_goodsImg] placeholderImage:nil];
            cell.lb_suk.text = @"";
            cell.lb_price.text = _price;
            cell.lb_count.text = _goodsCount;
            cell.lb_title.text = _goodsName;
        }

        return cell;
    }else if (indexPath.section == 1)
    {
        ZFOrderDetailCell * titleCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFOrderDetailCell" forIndexPath:indexPath];
        titleCell.lb_detailtitle.text = _titles[indexPath.row];
        titleCell.lb_detaileFootTitle.textColor = HEXCOLOR(0x8d8d8d);
        if (_listArray.count > 0 ) {
            titleCell.lb_detaileFootTitle.text =  _listArray[indexPath.row];
        }

        return titleCell;
    }else{
      
        LoadPictureCell * picCell  = [self.tableView dequeueReusableCellWithIdentifier:@"LoadPictureCell" forIndexPath:indexPath];
        if (_images.count > 0) {
            picCell.imagesUrl = _images;
            picCell.picBlock = ^(NSInteger index) {
                
                [self didCheckBigPic:index];
            };
            [picCell reloadData];
        }else{
            picCell.hidden = YES;

        }
        return picCell;
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];
}

#pragma mark - 进度查询列表     zfb/InterfaceServlet/afterSale/queryById
-(void)salesAfterPostRequste
{
    NSDictionary * param = @{
                             @"afterSaleId":_afterId,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/afterSale/queryById"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.listArray.count > 0 ) {
                [self.listArray removeAllObjects];
            }
            CheckModel * check  = [CheckModel mj_objectWithKeyValues:response];
            _images = [NSArray array];
            
            _price = [NSString stringWithFormat:@"¥%@",check.data.info.price];
            _goodsCount = [NSString stringWithFormat:@"x%ld",check.data.info.goodsCount];
            _goodsName = check.data.info.goodsName;
            _goodsImg = check.data.info.goodsPicture;
            _images = check.data.imgList;
            
            NSString* type = check.data.info.refundTypeName;//退款方式
            NSString* backReson =check.data.info.reason;//申请原因
            NSString* typeName = check.data.info.typeName;//服务类型
            NSString* description = check.data.info.problemDescr;//问题描述

            [self.listArray addObject:typeName];
            [self.listArray addObject:backReson];
            [self.listArray addObject:description];
            [self.listArray addObject:type];

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
#pragma mark -  商家审批结果  verifySaleAfter
-(void)salesAfterCheckPostRequste:(NSString *)status
{
    //状态:0:退货待审批 1:审批通过 2:审批未通过,3.待返回货物，4：服务完成
    NSDictionary * param = @{
                             @"afterSaleId":_afterId,
                             @"status":status,
                             @"storeRefuseReason":@"",
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/afterSale/verifySaleAfter"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self backAction];
                [SVProgressHUD dismiss];

            });
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma  mark- 审核通过
- (IBAction)passCheck:(id)sender {
    
    [self salesAfterCheckPostRequste:@"1"];
    
}

#pragma  mark- 审核拒绝
- (IBAction)refuseCheck:(id)sender {
    
    [self salesAfterCheckPostRequste:@"2"];

}
#pragma mark -点击查看大图
-(void)didCheckBigPic:(NSInteger)index
{
    [JZLPhotoBrowser showPhotoBrowserWithUrlArr:_images currentIndex:index originalImageViewArr:nil];
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
