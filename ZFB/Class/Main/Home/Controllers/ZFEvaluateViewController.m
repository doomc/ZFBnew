//
//  ZFEvaluateViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  self.title = @"评论";


#import "ZFEvaluateViewController.h"
#import "ZFAppraiseCell.h"
#import "ZFAppraiseSectionCell.h"
#import "AppraiseModel.h"


@interface ZFEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource,AppraiseSectionCellDelegate,ZFAppraiseCellDelegate>
{
    NSInteger _pageSize;//每页显示条数
    NSInteger _pageIndex;//当前页码;
    NSString * _commentNum;
    NSString * _goodCommentNum;
    NSString * _lackCommentNum;
    NSString * _imgCommentNum;
    NSString * _imgUrl_str;
    NSInteger  _starNum;
    
    //parma参数
    NSString * _goodsComment;
    NSString * _imgComment;
 
}
@property (nonatomic ,strong) UITableView* evaluate_tableView;
@property (nonatomic ,strong) NSMutableArray * appraiseListArray;


@end

@implementation ZFEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //默认一个页码 和 页数
    _pageSize = 8;
 
    [self initWithEvaluate_tableView];
    
    weakSelf(weakSelf);
    //上拉加载
    _evaluate_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _pageIndex ++ ;
        [weakSelf appriaseToPostRequestWithgoodsComment:@"" AndimgComment:@""];
        
    }];
    
    //下拉刷新
    _evaluate_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //需要将页码设置为1
        _pageIndex = 1;
        [weakSelf appriaseToPostRequestWithgoodsComment:@"" AndimgComment:@""];
    }];

    
    
}
-(NSMutableArray *)appraiseListArray{
    if (!_appraiseListArray) {
        _appraiseListArray = [NSMutableArray array];
    }
    return _appraiseListArray;
}

/**初始化evaluate_tableView*/
-(void)initWithEvaluate_tableView
{
    self.title = @"评论";
    
    self.evaluate_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH -64) style:UITableViewStylePlain];
    [self.view addSubview:_evaluate_tableView];
    
    self.evaluate_tableView.delegate = self;
    self.evaluate_tableView.dataSource = self;
    
    self.evaluate_tableView.estimatedRowHeight = 300.f;
    self.evaluate_tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.evaluate_tableView registerNib:[UINib nibWithNibName:@"ZFAppraiseCell" bundle:nil] forCellReuseIdentifier:@"ZFAppraiseCell"];
    
    [self.evaluate_tableView registerNib:[UINib nibWithNibName:@"ZFAppraiseSectionCell" bundle:nil]forCellReuseIdentifier:@"ZFAppraiseSectionCell"];
    
    
}


- (void)shouldReloadData{
    
    [self.evaluate_tableView reloadData];
}


#pragma mark - datasoruce  代理实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.appraiseListArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZFAppraiseSectionCell  * sectionCell = [tableView dequeueReusableCellWithIdentifier:@"ZFAppraiseSectionCell"];
    
    [sectionCell.all_btn setTitle:[NSString stringWithFormat:@"全部(%@)",_commentNum]
                         forState:UIControlStateNormal];
    [sectionCell.goodAppraise_btn setTitle:[NSString stringWithFormat:@"好评(%@)",_goodCommentNum]
                                  forState:UIControlStateNormal];
    [sectionCell.bad_btn setTitle:[NSString stringWithFormat:@"差评(%@)",_lackCommentNum]
                         forState:UIControlStateNormal];
    [sectionCell.haveImage_btn setTitle:[NSString stringWithFormat:@"有图(%@)",_imgCommentNum]
                               forState:UIControlStateNormal];
    sectionCell.delegate = self;
    
    return sectionCell;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFAppraiseCell *appraiseCell = [self.evaluate_tableView  dequeueReusableCellWithIdentifier:@"ZFAppraiseCell" forIndexPath:indexPath];
    appraiseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    appraiseCell.Adelegate = self;
    
    if (self.appraiseListArray.count > 0) {
        Findlistreviews * info = self.appraiseListArray[indexPath.row];
        appraiseCell.infoList = info;
    }
    return appraiseCell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section=%ld  ,row =%ld",indexPath.section , indexPath.row);
    
}
#pragma mark - 查看评价列表 AppraiseSectionCellDelegate
-(void)allbuttonSelect:(UIButton *)button
{
    NSLog(@"全部评价");
    [self appriaseToPostRequestWithgoodsComment:@"" AndimgComment:@""];
    
}
-(void)goodPrisebuttonSelect:(UIButton *)button
{
    NSLog(@"好评");
    [self appriaseToPostRequestWithgoodsComment:@"1" AndimgComment:@"2"];

}
-(void)badPrisebuttonSelect:(UIButton *)button
{
    NSLog(@"差评");
    [self appriaseToPostRequestWithgoodsComment:@"0" AndimgComment:@"2"];

}
-(void)haveImgbuttonSelect:(UIButton *)button
{
    NSLog(@"哟图");
    [self appriaseToPostRequestWithgoodsComment:@"" AndimgComment:@"1"];

}
#pragma mark - 评论的网络请求 getGoodsCommentInfo
-(void)appriaseToPostRequestWithgoodsComment:(NSString * )goodsComment AndimgComment:(NSString *)imgComment
{
    
    NSString * pageSize= [NSString stringWithFormat:@"%ld",_pageSize];
    NSString * pageIndex= [NSString stringWithFormat:@"%ld",_pageIndex];
 
    NSDictionary * parma = @{
                             @"goodsId":@"3", //_goodsId = 3 有数据
                             @"goodsComment":goodsComment,
                             @"imgComment":imgComment,
                             @"pageSize":pageSize,//每页显示条数
                             @"pageIndex":pageIndex,//当前页码
                             
                             };
    [MBProgressHUD showAutoMessage:@"加载中..."] ;
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsCommentInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            if (_pageIndex == 1) {
                
                if (self.appraiseListArray.count >0) {
                    
                    [self.appraiseListArray  removeAllObjects];
                }
            }
            AppraiseModel * appraise = [AppraiseModel mj_objectWithKeyValues:response];
            
            for (Findlistreviews * infoList in appraise.data.goodsCommentList.findListReviews) {
                
                [self.appraiseListArray addObject:infoList];
                
            }
            NSLog(@" ===============appraiseListArray ========== %@",  self.appraiseListArray);
            _commentNum = [NSString stringWithFormat:@"%ld",appraise.data.goodsCommentList.commentNum];   //全部评论数
            _goodCommentNum = [NSString stringWithFormat:@"%ld",appraise.data.goodsCommentList.goodCommentNum ];  //好评数
            _lackCommentNum = [NSString stringWithFormat:@"%ld",appraise.data.goodsCommentList.lackCommentNum ];  //差评数
            _imgCommentNum = [NSString stringWithFormat:@"%ld",appraise.data.goodsCommentList.imgCommentNum ];    //有图数
            
            [self shouldReloadData];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
        [self.evaluate_tableView.mj_header endRefreshing];
        [self.evaluate_tableView.mj_footer endRefreshing];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
 
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
  
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.evaluate_tableView.mj_header endRefreshing];
    [self.evaluate_tableView.mj_footer endRefreshing];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.evaluate_tableView.mj_header beginRefreshing];
    
}
@end
