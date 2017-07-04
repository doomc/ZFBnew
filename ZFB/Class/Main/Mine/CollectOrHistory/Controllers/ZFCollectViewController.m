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
@interface ZFCollectViewController ()<UITableViewDelegate,UITableViewDataSource,ZFCollectBarViewDelegate,ZFCollectEditCellDelegate>
{
   BOOL _isEdit;

}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UIButton * edit_btn;
@property (nonatomic , strong) ZFCollectBarView *footView;
@property (nonatomic , strong) NSMutableArray *listArray;


@end

@implementation ZFCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    _isEdit = NO;//默认编辑状态为NO
    
    self.title = @"商品收藏";
    [self.view addSubview:self.tableView];

    self.view.backgroundColor = RGB(239, 239, 244);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFCollectEditCell" bundle:nil]
        forCellReuseIdentifier:@"ZFCollectEditCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFHistoryCell" bundle:nil] forCellReuseIdentifier:@"ZFHistoryCellid"];

    [self showCollectListPOSTRequest];
    
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
    if (_isEdit == NO)
    {
     
        ZFHistoryCell * normalCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFHistoryCellid" forIndexPath:indexPath];
        normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cmkeepgoodslist * list = self.listArray[indexPath.section];
        normalCell.lb_price.text = [NSString stringWithFormat:@"¥%@", list.storePrice];
        normalCell.lb_title.text = [NSString stringWithFormat:@"%@", list.goodsName];
        [normalCell.img_collctView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",list.coverImgUrl]] placeholderImage:[UIImage imageNamed:@""]];
        
        return normalCell;
    }else{
        
        ZFCollectEditCell *editCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFCollectEditCellid" forIndexPath:indexPath];
        editCell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cmkeepgoodslist * list = self.listArray[indexPath.section];
        editCell.lb_price.text = [NSString stringWithFormat:@"¥%@", list.storePrice];
        editCell.lb_title.text = [NSString stringWithFormat:@"%@", list.goodsName];
        [editCell.img_editView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",list.coverImgUrl]] placeholderImage:[UIImage imageNamed:@""]];
        editCell.delegate = self;
        
        return editCell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sectin = %ld,row = %ld",indexPath.section ,indexPath.row);
    
}


#pragma mark - 收藏列表 -getKeepGoodList
-(void)showCollectListPOSTRequest
{
    
    [SVProgressHUD show];
    NSDictionary * parma = @{
                             @"svcName":@"getKeepGoodList",
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
              
                CollectModel * collect = [CollectModel mj_objectWithKeyValues:jsondic];
                for (Cmkeepgoodslist * list in collect.cmKeepGoodsList) {
                    
                    [self.listArray addObject:list];
                }
                NSLog(@" -  - - -- - - -- - -%@ - --- -- - - -- - -",_listArray);
                [self.tableView reloadData];
                
                [SVProgressHUD dismiss];
            }
            [SVProgressHUD dismiss];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
    }];
    
}
#pragma mark -  ZFCollectEditCellDelegate 选择代理
- (void)goodsSelected:(ZFCollectEditCell *)cell isSelected:(BOOL)choosed
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Cmkeepgoodslist * list = self.listArray[indexPath.section];
    list.isCollectSelected = !list.isCollectSelected;

    [self.tableView reloadData];

    // 每次点击都要统计底部的按钮是否全选
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
///判断是不是空数组
- (BOOL)isEmptyArray:(NSArray *)array
{
    return (array.count ==0 || array == nil);
}


#pragma mark -  ZFCollectBarViewDelegate 代理
///取消收藏
-(void)didClickCancelCollect:(UIButton*)sender
{
    NSLog(@"取消收藏");
}
///全选
-(void)didClickSelectedAll:(UIButton*)sender
{
    sender.selected = !sender.selected;
    NSLog(@"全选");
    
    for (Cmkeepgoodslist *list in self.listArray) {
     
        list.isCollectSelected = sender.selected;
 
    }
    [self.tableView reloadData];

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
-(ZFCollectBarView *)footView
{
    if (!_footView) {
        _footView = [[NSBundle mainBundle]loadNibNamed:@"ZFCollectBarView" owner:self options:nil].lastObject;
        _footView.frame = CGRectMake(0, KScreenH-49, KScreenW, 49);
        _footView.delegate = self;
        
    }
    return _footView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64 - 49) style:UITableViewStyleGrouped];
        _tableView.delegate =self;
        _tableView.dataSource = self;
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
    [_edit_btn setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
    _edit_btn.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width = size.width ;
    _edit_btn.frame =CGRectMake(0, 0, width+10, 22);
    
    return _edit_btn;
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
