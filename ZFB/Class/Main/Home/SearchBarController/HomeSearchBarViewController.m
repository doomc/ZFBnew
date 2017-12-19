//
//  HomeSearchBarViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/7/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "HomeSearchBarViewController.h"
//#import "HomeSearchResultViewController.h"
#import "SearchResultCollectionViewController.h"

//view
#import "YBPopupMenu.h"

//cell
#import "MKJTagViewTableViewCell.h"
#import "SearchHistoryCell.h"
//model
#import "SearchLanelModel.h"
#import "SearchTitleView.h"

static NSString * identyfy = @"MKJTagViewTableViewCell";
static NSString * identyhy = @"SearchHistoryCell";

@interface HomeSearchBarViewController ()<UITableViewDelegate,UITableViewDataSource,SearchTitleViewDelegate,YBPopupMenuDelegate,SearchHistoryCellDelegate>
{
    NSString * _searchText;//搜索关键字
    NSString * _tagId;//搜索关键字
    NSInteger _selectedType;//选择类型 0 为商品,1为店铺
    
}
@property (nonatomic, strong) SearchTitleView *titleView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray  *tagList;//标签
@property (nonatomic, strong) NSMutableArray  *tagIdArr;//标签id
@property (nonatomic ,strong) UIButton * searchButton;//搜索
//@property (nonatomic ,strong) UIView   * titleView;

@property (nonatomic ,strong) NSMutableArray *historyArray;
@end

@implementation HomeSearchBarViewController
#pragma mark - tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
-(NSMutableArray *)tagList
{
    if (!_tagList) {
        _tagList = [NSMutableArray array];
    }
    return _tagList;
}
-(NSMutableArray *)tagIdArr
{
    if (!_tagIdArr) {
        _tagIdArr = [NSMutableArray array];
    }
    return _tagIdArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getGoodsLanelPOSTRequest];
    
    [self InitInterface];
    
    
}

- (void)InitInterface{
    
    //nib
    [self.tableView registerNib:[UINib nibWithNibName:identyhy bundle:nil] forCellReuseIdentifier:identyhy];
    [self.tableView registerNib:[UINib nibWithNibName:identyfy bundle:nil] forCellReuseIdentifier:identyfy];
    [self.view addSubview:_tableView];
    
    //创建titleView
    _titleView = [[SearchTitleView alloc]initWithTitleViewFrame:CGRectMake(0, 0, KScreenW - 100, 36) andLeadingWidth:60];
    _titleView.delegate = self;
     self.navigationItem.titleView = _titleView;
    
    _selectedType = 0;//默认为商品
}
-(UIButton *)set_leftButton
{
    //返回
    UIButton *left_button = [UIButton buttonWithType:UIButtonTypeCustom];
    left_button.frame =CGRectMake(0, 0,22,22);
    [left_button setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button addTarget:self action:@selector(dismissCurrentPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc]initWithCustomView: left_button];
    self.navigationItem.leftBarButtonItems = @[leftItem1];
    return left_button;
}
-(UIButton *)set_rightButton
{
    //搜索
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    _searchButton.frame = CGRectMake(5, 7, 40, 30);
    _searchButton.titleLabel.font = SYSTEMFONT(14);
    [_searchButton addTarget:self action:@selector(didSearch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView: _searchButton];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    return _searchButton;
}
//选择类型
-(void)didSearchType:(UIButton *)sender
{
    [self selectTypeAction:sender];
}

//搜索
-(void)didSearch:(UIButton *)sender
{
    if (_searchText.length > 0 ) {
        //关键字 save 到本地
        NSMutableArray * tempArr = [NSMutableArray array];
        if (self.historyArray) {
            
            tempArr = [self.historyArray mutableCopy];
        }
        [tempArr addObject:_searchText];
        BBUserDefault.searchHistoryArray = tempArr;//存到本地
        //push操作
        SearchResultCollectionViewController * reslutVC = [[SearchResultCollectionViewController alloc] init];
        if (_selectedType == 0) {
            reslutVC.searchType  = 0;//商品搜索
        }
        else {
            reslutVC.searchType  = 1;//门店搜索
        }
        reslutVC.searchText = @"";
        reslutVC.labelId = @"";
        [self.navigationController pushViewController:reslutVC animated:NO];
    }else{
        //push操作
        SearchResultCollectionViewController * reslutVC = [[SearchResultCollectionViewController alloc] init];
        if (_selectedType == 0) {
            reslutVC.searchType  = 0;//商品搜索
        }
        else {
            reslutVC.searchType  = 1;//门店搜索
        }
        reslutVC.searchText = @"";
        reslutVC.labelId = @"";
        [self.navigationController pushViewController:reslutVC animated:NO];
        
    }
}
//编辑
-(void)didChangeText:(NSString *)text
{
    _searchText = text;
    NSLog(@"text = %@",text);
}




#pragma mark -  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (_selectedType == 0) {//商品
            return [tableView fd_heightForCellWithIdentifier:identyfy configuration:^(id cell) {
                [self configCell:cell indexpath:indexPath];
            }];
        }else{
            return 0;
        }

    }
    return 50;
}
//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.historyArray.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if (_selectedType == 0) {//商品
        if (section ==  0) {
           
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel * hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW, 40)];
            hotLabel.text = @"热门搜索";
            hotLabel.font = SYSTEMFONT(14);
            hotLabel.textColor = HEXCOLOR(0x333333);
            [view addSubview:hotLabel];
            return  view;
            
        }else{
            if (self.historyArray.count > 0) {
                UIView * headView =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
                UILabel* lb_title = [[ UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW, 40)];
                lb_title.text = @"搜索历史";
                lb_title.font = [UIFont systemFontOfSize:14];
                lb_title.textColor = HEXCOLOR(0x363636);
                [headView addSubview:lb_title];
                view = headView;
            }
        }
    }else{//选择门店 隐藏热门搜索
        if (section ==  0) {
            return  view;
        }else{
            if (self.historyArray.count > 0) {
                UIView * headView =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
                UILabel* lb_title = [[ UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW, 40)];
                lb_title.text = @"搜索历史";
                lb_title.font = [UIFont systemFontOfSize:14];
                lb_title.textColor = HEXCOLOR(0x363636);
                [headView addSubview:lb_title];
                view = headView;
            }
        }
    }

    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.0001 ;
    if (_selectedType == 0) {//商品
        if (section == 0 ) {
            if (self.tagList.count > 0) {
                height = 40;
            }else{
                height = 0;
            }
        }else{
            if (self.historyArray.count > 0) {
                height = 40;
            }else{
                height = 0;
            }
        }
    }else{//门店
        if (section == 0 ) {
            height = 0;
           
        }else{
            if (self.historyArray.count > 0) {
                height = 40;
            }else{
                height = 0;
            }
        }
    }
    return height;
  
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = nil;
    
    if (section == 0) {
        return view;
    }
    else{
        UIButton * footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        footBtn.frame = CGRectMake(0, 0, KScreenW, 40);
        [footBtn setTitle:@"清空历史记录~" forState:UIControlStateNormal];
        footBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [footBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [footBtn addTarget:self action:@selector(clearingAllhistoryData) forControlEvents:UIControlEventTouchUpInside];
        view = footBtn;
        
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.historyArray.count > 0) {
        if (section == 0) {
            return 0.001;
        }
        return 44;
    }
    return 0;
}
#pragma mark -  UITableViewDelegate
//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        MKJTagViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identyfy forIndexPath:indexPath];
        if (_selectedType == 0) {
            cell.hidden = NO;
            [self configCell:cell indexpath:indexPath];
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }else{
        
        SearchHistoryCell *historyCell = [self.tableView dequeueReusableCellWithIdentifier:identyhy forIndexPath:indexPath];
        historyCell.delegate = self;
        historyCell.row = indexPath.row;
        historyCell.lb_historyName.text = self.historyArray[indexPath.row];
        return historyCell;
    }
}

- (void)configCell:(MKJTagViewTableViewCell *)cell indexpath:(NSIndexPath *)indexpath
{
    [cell.tagView removeAllTags];
    cell.tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
    cell.tagView.padding = UIEdgeInsetsMake(15, 10, 10, 15);
    cell.tagView.lineSpacing = 10;
    cell.tagView.interitemSpacing = 20;
    cell.tagView.singleLine = NO;
    // 给出两个字段，如果给的是0，那么就是变化的,如果给的不是0，那么就是固定的
    //        cell.tagView.regularWidth = 80;
    //        cell.tagView.regularHeight = 30;
    
    NSArray * arr = [NSArray arrayWithArray:self.tagList];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SKTag *tag = [[SKTag alloc] initWithText:arr[idx]];
        
        tag.font = [UIFont systemFontOfSize:14];
        tag.textColor = HEXCOLOR(0x333333);
        tag.bgColor = HEXCOLOR(0xf7f7f7);
        tag.cornerRadius = 4;
        tag.enable = YES;
        tag.padding = UIEdgeInsetsMake(5, 10, 5, 10);
        [cell.tagView addTag:tag];
    }];
    //
    cell.tagView.didTapTagAtIndex = ^(NSUInteger index)
    {
        _searchText =  self.tagList[index];
        _tagId  =  self.tagIdArr[index];

        SearchResultCollectionViewController * reslutVC = [[SearchResultCollectionViewController alloc] init];
        if (_selectedType == 0) {
            reslutVC.searchType  = 0;//商品搜索
        }
        else {
            reslutVC.searchType  = 1;//门店搜索
        }
        reslutVC.labelId = _tagId;
        reslutVC.searchText = _searchText;

        [self.navigationController pushViewController:reslutVC animated:NO];
        NSLog(@"点击了%ld  === %@ =====%@id ",index,_searchText,_tagId);
 
        [self.historyArray addObject:_searchText];
        BBUserDefault.searchHistoryArray = self.historyArray;//存到本地
    };
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld  ---- %ld",indexPath.section ,indexPath.row);
    
    NSString * searchText = self.historyArray[indexPath.row];
    if (indexPath.section == 1) {
 
        SearchResultCollectionViewController * reslutVC = [[SearchResultCollectionViewController alloc] init];
        if (_selectedType == 0) {
            reslutVC.searchType  = 0;//商品搜索
        }else {
            reslutVC.searchType  = 1;//门店搜索
        }
        reslutVC.searchText = searchText;
        reslutVC.labelId = _tagId;
        [self.navigationController pushViewController:reslutVC animated:NO];
        
    }
    
}





#pragma mark -  选择搜索类型
-(void)selectTypeAction :(UIButton *)sender
{
    [YBPopupMenu showRelyOnView:sender titles:TITLES  icons:nil menuWidth:70 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionBottom;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.offset = 10;
        popupMenu.type = YBPopupMenuTypeDark;
    }];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSLog(@"点击了 %@ 选项",TITLES[index]);
    _selectedType = index;
    [_titleView.selectTypeBtn setTitle:TITLES[index] forState:UIControlStateNormal];
    [self.tableView reloadData];
}


#pragma mark  - getGoodsLanel用于查找商品-商品标签
-(void)getGoodsLanelPOSTRequest
{
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsLanel",zfb_baseUrl] params:nil success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            SearchLanelModel * searchLanel = [SearchLanelModel mj_objectWithKeyValues:response];
            for (Cmgoodslanel * lanel in searchLanel.data.cmGoodsLanel) {
                
                [self.tagList addObject:lanel.labelName];
                [self.tagIdArr addObject:lanel.labelId];
            }
            [self.tableView reloadData];
        }
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
    }];
}

//重新从本地获取历史记录
-(void)reloadHistory
{
    for (NSString * title in  BBUserDefault.searchHistoryArray) {
      
        [self.historyArray addObject: title];
    }
    [self.tableView reloadData];
}

-(NSMutableArray *)historyArray{
    if (!_historyArray) {
        
        _historyArray = [NSMutableArray array];
    }
    return _historyArray;
}
//刷新历史记录
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self settingNavBarBgName:@"nav64_gray"];

    if (self.historyArray.count > 0) {

        [self.historyArray removeAllObjects];
    }
    [self reloadHistory];

}
#pragma mark - 删除单个数据
-(void)deleteSingleDataRow:(NSUInteger)row
{
    [self.historyArray removeObjectAtIndex:row];
    [self.tableView reloadData];
}
//清空历史记录
-(void)clearingAllhistoryData
{
    NSLog(@"%@",self.historyArray);
    if (self.historyArray.count > 0) {
        BBUserDefault.searchHistoryArray = nil;
        [self.historyArray removeAllObjects];
        [self.tableView reloadData];
    }
}
-(void)dismissCurrentPage
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    NSLog(@"返回上一页");
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
