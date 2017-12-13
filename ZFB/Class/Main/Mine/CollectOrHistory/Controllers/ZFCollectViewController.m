//
//  ZFCollectViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFCollectViewController.h"

#import "ZFCollectEditCell.h"
#import "ZFCollectBarView.h"
#import "ZFHistoryCell.h"
#import "CollectModel.h"
#import "MTSegmentedControl.h"
#import "XHStarRateView.h"
typedef NS_ENUM(NSUInteger, CollectType) {
    
    CollectTypeGoods,
    CollectTypeStores,
 
};
@interface ZFCollectViewController ()<UITableViewDelegate,UITableViewDataSource,ZFCollectBarViewDelegate,ZFCollectEditCellDelegate,CYLTableViewPlaceHolderDelegate, WeChatStylePlaceHolderDelegate,MTSegmentedControlDelegate>
{
    BOOL _isEdit;
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UIButton * edit_btn;
@property (nonatomic , strong) ZFCollectBarView *footView;
@property (nonatomic , strong) NSMutableArray *listArray;
@property (nonatomic , strong) NSMutableArray *tempCellArray;
//拿到商品id 和收藏id
@property (nonatomic , copy) NSString * collectId;
@property (nonatomic , copy) NSString * goodId;
//控制2中收藏
@property (strong, nonatomic) MTSegmentedControl *segumentView;
@property (assign, nonatomic) CollectType collectType;//收藏类型
@property (strong, nonatomic) WeChatStylePlaceHolder *weChatStylePlaceHolder;

@end

@implementation ZFCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品收藏";

    _isEdit = NO;//默认编辑状态为NO
    _collectType = CollectTypeGoods;//默认为商品收藏

    [self.view addSubview:self.tableView];
    self.zfb_tableView = self.tableView;

    self.view.backgroundColor = RGB(239, 239, 244);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFCollectEditCell" bundle:nil]
         forCellReuseIdentifier:@"ZFCollectEditCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFHistoryCell" bundle:nil] forCellReuseIdentifier:@"ZFHistoryCellid"];
    
    //默认请求门店
    [self showCollectListPOSTRequestCollectType:@"1"];
    
    [self setupPageView];
    
    [self setupRefresh];

}
-(void)viewWillAppear:(BOOL)animated{
    [self settingNavBarBgName:@"nav64_gray"];

}
-(void)footerRefresh{
    
    [super footerRefresh];
    switch (_collectType) {
        case CollectTypeGoods: //1商品 2门店
            [self showCollectListPOSTRequestCollectType:@"1"];

            break;
            
        case CollectTypeStores:
            [self showCollectListPOSTRequestCollectType:@"2"];

            break;
            
        default:
            break;
    }

}
-(void)headerRefresh
{
    [super headerRefresh];
    switch (_collectType) {
        case CollectTypeGoods: //1商品 2门店
            [self showCollectListPOSTRequestCollectType:@"1"];
            
            break;
            
        case CollectTypeStores:
            [self showCollectListPOSTRequestCollectType:@"2"];
            
            break;
            
        default:
            break;
    }
}
- (void)setupPageView {
 
    NSArray *titleArr   = @[@"商品收藏",@"门店收藏"];
    _segumentView       = [[MTSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 44)];
    [self.segumentView segmentedControl:titleArr Delegate:self];
    [self.view addSubview:_segumentView];
}

#pragma mark - <MTSegmentedControlDelegate>
- (void)segumentSelectionChange:(NSInteger)selection
{
    _collectType = selection ;
    [self.listArray removeAllObjects];
    self.currentPage = 1;
    switch (_collectType) {
        case CollectTypeGoods: //1商品 2门店
            [self showCollectListPOSTRequestCollectType:@"1"];
  
            break;
            
        case CollectTypeStores:
            [self showCollectListPOSTRequestCollectType:@"2"];
   
            break;
 
    }
    
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
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = nil;
    if (view == nil) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    }
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headview = nil;
    if (headview == nil) {
        headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    }
    return headview;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cmkeepgoodslist * list = self.listArray[indexPath.section];
    switch (_collectType) {
        case CollectTypeGoods:              //商品收藏列表
            if (_isEdit == NO)
            {

                ZFHistoryCell * normalCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFHistoryCellid" forIndexPath:indexPath];
                normalCell.goodslist = list;
                normalCell.lb_price.hidden = NO;
                [normalCell.starView removeFromSuperview];
                return normalCell;
                
            }else{
                
                ZFCollectEditCell *editCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFCollectEditCellid" forIndexPath:indexPath];
                editCell.collectID = list.cartItemId;//收藏id
                editCell.goodlist = list;
                editCell.delegate = self;
                editCell.lb_price.hidden = NO;
                [editCell.starView removeFromSuperview];

                return editCell;
            }
            break;
        case CollectTypeStores://  门店收藏列表
            
            if (_isEdit == NO)
            {
                ZFHistoryCell * normalCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFHistoryCellid" forIndexPath:indexPath];
                normalCell.lb_price.hidden = YES;
                normalCell.storeslist = list;
                
                //初始化五星好评控件info.goodsComment
                XHStarRateView * wdStarView = [[XHStarRateView alloc]initWithFrame:normalCell.starView.frame numberOfStars:5 rateStyle:WholeStar isAnination:YES delegate:self WithtouchEnable:NO littleStar:@"0"];//da星星
                wdStarView.currentScore = [list.starLevel integerValue];
     

                //初始化五星好评控件
                [normalCell addSubview:wdStarView];

                return normalCell;
            }else{
                
                ZFCollectEditCell *editCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFCollectEditCellid" forIndexPath:indexPath];

                editCell.lb_price.hidden = YES;
                editCell.collectID = list.cartItemId;//收藏id
                editCell.storeList = list;
                editCell.delegate = self;
                
                //初始化五星好评控件info.goodsComment
                XHStarRateView * wdStarView = [[XHStarRateView alloc]initWithFrame:editCell.starView.frame numberOfStars:5 rateStyle:WholeStar isAnination:YES delegate:self WithtouchEnable:NO littleStar:@"0"];//da星星
                wdStarView.currentScore = [list.starLevel integerValue];
      

                //初始化五星好评控件
                [editCell addSubview:wdStarView];
                
                return editCell;
            }

            break;
            
        default:
            break;

    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sectin = %ld,row = %ld",indexPath.section ,indexPath.row);
    
}


#pragma mark -  ZFCollectEditCellDelegate 选择代理
- (void)goodsSelected:(ZFCollectEditCell *)cell isSelected:(BOOL)choosed
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Cmkeepgoodslist * list = self.listArray[indexPath.section];
    
    list.isCollectSelected = !list.isCollectSelected;
    
    for (Cmkeepgoodslist *list in self.listArray) {
       
        if (list.isCollectSelected) {
          
            _goodId = [NSString stringWithFormat:@"%ld",list.goodId];

        }
    }
//    NSLog(@"============_collectID %@========\n%d",_collectID, list.isCollectSelected);
    [self.tableView reloadData];
    
    // 每次点击都要统计底部的按钮是否全选
    self.footView.allChoose_btn.selected = [self isAllProcductChoosed];
    
}

///全选
-(void)didClickSelectedAll:(UIButton*)sender
{
    sender.selected = !sender.selected;
    NSLog(@"全选");
    
    NSMutableArray * listArr = [NSMutableArray array];
    for (Cmkeepgoodslist *list in self.listArray) {
        
        list.isCollectSelected = sender.selected;
        
        NSString *cartItemId = [NSString stringWithFormat:@"%ld",list.cartItemId];
        
        [listArr addObject:cartItemId];
        
        NSString * str = [listArr componentsJoinedByString:@","];
        
        if (list.isCollectSelected == YES) {
            
            _collectId = str ;
        }
    }
    [self.tableView reloadData];

    self.footView.allChoose_btn.selected = [self isAllProcductChoosed];

}



#pragma mark - 判断是否全部选中了
- (BOOL)isAllProcductChoosed
{
    if ([self isEmptyArray:self.listArray] ) {
        return NO;
    }
    
    NSInteger count = 0;
    for (Cmkeepgoodslist * list in self.listArray) {
     
        if (list.isCollectSelected) {
            count ++;
        }
    }
    return (count == self.listArray.count);
}


#pragma mark - 删除之后一些列更新操作
- (void)updateInfomation
{
    // 会影响到对应的选择
    NSInteger count = 0;
    for (Cmkeepgoodslist * list in self.listArray) {
        
        if (list.isCollectSelected) {
            count ++;
        }
    }
    // 再次影响到全部选择按钮
    self.footView.allChoose_btn.selected = [self isAllProcductChoosed];
    [self.tableView reloadData];
    
}

#pragma mark -  ZFCollectBarViewDelegate 代理
///取消收藏
-(void)didClickCancelCollect:(ZFCollectEditCell *)cell
{
    NSLog(@"取消收藏");
    
    JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"确认取消收藏？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
  
        switch (_collectType) {
            case CollectTypeGoods:
            {
                if ([self isAllProcductChoosed] == YES) {
                    [self cancelCollectListPOSTRequest];//取消全部收藏
                }else{
                    [self cancalsingleGoodsCollectPOSTRequestCollectType:@"1"];//单个商品收藏
                }
                
                for (Cmkeepgoodslist * list in self.listArray)
                {
                    if (list.isCollectSelected)
                    {
                        [self.tempCellArray addObject:list];
                    }
                }
                [self.listArray removeObjectsInArray:self.tempCellArray];
            }
                break;
                
            case CollectTypeStores:
            {
                if ([self isAllProcductChoosed] == YES) {
                    [self cancelCollectListPOSTRequest];//取消全部收藏
                }else{
                    [self cancalsingleGoodsCollectPOSTRequestCollectType:@"2"];//单个商品收藏
                }
                
                for (Cmkeepgoodslist * list in self.listArray)
                {
                    if (list.isCollectSelected)
                    {
                        [self.tempCellArray addObject:list];
                    }
                }
                [self.listArray removeObjectsInArray:self.tempCellArray];
            }
                break;
            default:
                break;
        }
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark -  点击编辑
-(void)right_button_event:(UIButton*)sender{
    
    _edit_btn = sender;
    _edit_btn.selected = !_edit_btn.selected;
    
    if (_edit_btn.selected == YES) {
        [_edit_btn setTitle:@"完成" forState:UIControlStateNormal];
        _isEdit = YES;
        
        [self.view addSubview:self.footView];
        [self.tableView reloadData];
        NSLog(@"点击编辑");
    }else{
        sender.selected =NO;
        _isEdit = NO;
        [_edit_btn setTitle:@"编辑" forState:UIControlStateNormal];
        
        if (self.footView.superview) {
            [self.footView removeFromSuperview];
        }
        [self.tableView reloadData];
        NSLog(@"点击完成");
        
    }
}
-(NSMutableArray *)listArray
{
    if (!_listArray) {
        
        _listArray =[NSMutableArray array];
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
-(ZFCollectBarView *)footView
{
    if (!_footView) {
        _footView = [[NSBundle mainBundle]loadNibNamed:@"ZFCollectBarView" owner:self options:nil].lastObject;
        _footView.frame = CGRectMake(0, KScreenH-49-64, KScreenW, 49);
        _footView.delegate = self;
        
    }
    return _footView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, KScreenW, KScreenH - 49-44 -64) style:UITableViewStyleGrouped];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    NSString * saveStr = @"编辑";
    _edit_btn = [[UIButton alloc]init];
    [_edit_btn setTitle:saveStr forState:UIControlStateNormal];
    _edit_btn.titleLabel.font=SYSTEMFONT(14);
    [_edit_btn setTitleColor:HEXCOLOR(0x333333)  forState:UIControlStateNormal];
    _edit_btn.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width = size.width ;
    _edit_btn.frame =CGRectMake(0, 0, width+10, 22);
    
    return _edit_btn;
}

#pragma mark - 收藏列表 -getKeepGoodList
-(void)showCollectListPOSTRequestCollectType:(NSString *)collectType
{
 
    NSLog(@" user id = ==== %@",BBUserDefault.cmUserId)
    NSDictionary * parma = @{
                 
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             @"collectType":collectType,//1商品 2门店
                             @"latitude":BBUserDefault.latitude,
                             @"longitude":BBUserDefault.longitude,

                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getKeepGoodList"] params:parma success:^(id response) {
        
        if ([response[@"resultCode"]isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
              
                if (self.listArray.count > 0) {
                    
                    [self.listArray  removeAllObjects];
                }
            }
            CollectModel * collect = [CollectModel mj_objectWithKeyValues:response];
            
            for (Cmkeepgoodslist * list in collect.data.cmKeepGoodsList) {
                
                [self.listArray addObject:list];
            }
            [self.tableView reloadData];
            [_weChatStylePlaceHolder removeFromSuperview];
            NSLog(@" -  - - -- - - -- - -%@ - --- -- - - -- - -",_listArray);
            if([self isEmptyArray:self.listArray])
            {
                [self.tableView cyl_reloadData];
            }
        }
        [SVProgressHUD dismiss];
        [self endRefresh];

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];

    
}


#pragma mark - 取消全选收藏列表 -getKeepGoodDel
-(void)cancelCollectListPOSTRequest
{
    NSDictionary * parma = @{
                             @"cartItemId":_collectId,
                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getKeepGoodDel"] params:parma success:^(id response) {
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
        [self updateInfomation];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}

#pragma mark - 单个取消收藏列表 -cancalGoodsCollect
-(void)cancalsingleGoodsCollectPOSTRequestCollectType:(NSString *)collectType;
{
    NSDictionary * parma = @{
                             
                             @"goodId":_goodId,
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"collectType":collectType,//1商品 2门店
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/cancalGoodsCollect"] params:parma success:^(id response) {
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
        [self updateInfomation];
        
    } progress:^(NSProgress *progeress) {
    
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}

#pragma mark - CYLTableViewPlaceHolderDelegate Method
- (UIView *)makePlaceHolderView {
    
    UIView *weChatStyle = [self weChatStylePlaceHolder];
    return weChatStyle;
}
//暂无数据
- (UIView *)weChatStylePlaceHolder {
    
    _weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.tableView.frame];
    _weChatStylePlaceHolder.delegate = self;
    return _weChatStylePlaceHolder;
}
#pragma mark - WeChatStylePlaceHolderDelegate Method
- (void)emptyOverlayClicked:(id)sender { 
    
    switch (_collectType) {
        case CollectTypeGoods: //1商品 2门店
            [self showCollectListPOSTRequestCollectType:@"1"];
            
            break;
            
        case CollectTypeStores:
            [self showCollectListPOSTRequestCollectType:@"2"];
            
            break;
            
        default:
            break;
    }
    
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
