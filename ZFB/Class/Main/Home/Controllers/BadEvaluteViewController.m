//
//  BadEvaluteViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BadEvaluteViewController.h"
#import "ZFAppraiseCell.h"
#import "AppraiseModel.h"
#import "XHStarRateView.h"
@interface BadEvaluteViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * _imgUrl_str;
    NSInteger  _starNum;
    
    //parma参数
    NSString * _goodsComment;
    NSString * _imgComment;
    NSInteger _totalCount;//总条数
}
@property (nonatomic ,strong) UITableView* evaluate_tableView;
@property (nonatomic ,strong) NSMutableArray * appraiseListArray;
@property (nonatomic ,strong) NSMutableArray * imgArray;

@end

@implementation BadEvaluteViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.  '
    
    [self setupRefresh];
    [self initWithEvaluate_tableView];
    [self appriaseToPostRequestWithgoodsComment:@"0" AndimgComment:@""];
    
}
#pragma mark -数据请求
-(void)headerRefresh {
    [super headerRefresh];
    [self appriaseToPostRequestWithgoodsComment:@"0" AndimgComment:@""];
    
}
-(void)footerRefresh {
    [super footerRefresh];
    [self appriaseToPostRequestWithgoodsComment:@"0" AndimgComment:@""];


}

-(NSMutableArray *)appraiseListArray{
    if (!_appraiseListArray) {
        _appraiseListArray = [NSMutableArray array];
    }
    return _appraiseListArray;
}

-(NSMutableArray *)imgArray{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}
/**初始化evaluate_tableView*/
-(void)initWithEvaluate_tableView
{
    
    self.evaluate_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KScreenW, KScreenH -64 - 44) style:UITableViewStylePlain];
    self.evaluate_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.evaluate_tableView.delegate = self;
    self.evaluate_tableView.dataSource = self;
    
    [self.view addSubview:self.evaluate_tableView];
    self.zfb_tableView = self.evaluate_tableView;
    
    [self.evaluate_tableView registerNib:[UINib nibWithNibName:@"ZFAppraiseCell" bundle:nil] forCellReuseIdentifier:@"ZFAppraiseCell"];
    [self.evaluate_tableView registerNib:[UINib nibWithNibName:@"ZFAppraiseSectionCell" bundle:nil]forCellReuseIdentifier:@"ZFAppraiseSectionCell"];
    
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"ZFAppraiseCell" configuration:^(id cell) {
        [self setupCell:cell AtIndexPath:indexPath];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFAppraiseCell *appraiseCell = [self.evaluate_tableView  dequeueReusableCellWithIdentifier:@"ZFAppraiseCell" forIndexPath:indexPath];
    [self setupCell:appraiseCell AtIndexPath:indexPath];
    return appraiseCell;
    
}
-(void)setupCell:(ZFAppraiseCell *)cell AtIndexPath :(NSIndexPath*)indexPath
{
    Findlistreviews * info = self.appraiseListArray[indexPath.row];
    cell.infoList = info;    
    //初始化五星好评控件info.goodsComment
    XHStarRateView * wdStarView = [[XHStarRateView alloc]initWithFrame:CGRectMake(KScreenW -  125-10, 10, 125, 25) numberOfStars:5 rateStyle:WholeStar isAnination:YES delegate:self WithtouchEnable:NO];
    wdStarView.currentScore = info.goodsComment;
    
    [cell addSubview:wdStarView];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section=%ld  ,row =%ld",indexPath.section , indexPath.row);
    
}

#pragma mark - 评论的网络请求 getGoodsCommentInfo
-(void)appriaseToPostRequestWithgoodsComment:(NSString * )goodsComment AndimgComment:(NSString *)imgComment
{
    NSDictionary * parma = @{
                             @"goodsId":_goodsId,
                             @"goodsComment":goodsComment,
                             @"imgComment":imgComment,
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsCommentInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            if (self.refreshType == RefreshTypeHeader) {
                
                if (self.appraiseListArray.count >0) {
                    
                    [self.appraiseListArray  removeAllObjects];
                }
            }
            if (self.imgArray.count > 0) {
                [self.imgArray removeAllObjects];
            }
            NSLog(@" 当前页数------ %ld",self.currentPage);
            if (_totalCount > 0 && _totalCount == self.appraiseListArray.count) {
                
                [self endRefresh];
                
            }else{
                AppraiseModel * appraise = [AppraiseModel mj_objectWithKeyValues:response];
                for (Findlistreviews * infoList in appraise.data.goodsCommentList.findListReviews) {
                    
                    [self.appraiseListArray addObject:infoList];
                    [self.imgArray  addObject: infoList.attachImgUrl];
                }
                NSLog(@" ===============appraiseListArray ========== %@",  self.appraiseListArray);
                _totalCount  = appraise.data.goodsCommentList.totalCount;
                
            }
            
            [SVProgressHUD dismiss];
            [self.evaluate_tableView reloadData];
        }
        
        [self endRefresh];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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
