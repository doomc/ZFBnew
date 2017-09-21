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

#import "MTSegmentedControl.h"

typedef NS_ENUM(NSUInteger, EvaluateType) {
    EvaluateTypeAllDefault,
    EvaluateTypeGood,
    EvaluateTypeBad,
    EvaluateTypeHavePicture,
};
@interface ZFEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource,MTSegmentedControlDelegate>
{

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
@property (strong, nonatomic) MTSegmentedControl *segumentView;
@property (assign, nonatomic) EvaluateType  evaluateType;


@end

@implementation ZFEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithEvaluate_tableView];
    [self appriaseToPostRequestWithgoodsComment:@"" AndimgComment:@""];
    //设置title
    [self setupPageView];
    [self setupRefresh];

    
}
#pragma mark -数据请求
-(void)headerRefresh {
    [super headerRefresh];
    switch (_evaluateType) {
        case EvaluateTypeAllDefault://全部
            
            [self appriaseToPostRequestWithgoodsComment:@"" AndimgComment:@""];

            break;
        case EvaluateTypeGood://好评
            [self appriaseToPostRequestWithgoodsComment:@"1" AndimgComment:@"2"];

            
            break;
        case EvaluateTypeBad://差评
            [self appriaseToPostRequestWithgoodsComment:@"0" AndimgComment:@"2"];

            
            break;
        case EvaluateTypeHavePicture://有图
            [self appriaseToPostRequestWithgoodsComment:@"" AndimgComment:@"1"];

            
            break;
        default:
            break;
    }
    
}
-(void)footerRefresh {
    [super footerRefresh];
    switch (_evaluateType) {
        case EvaluateTypeAllDefault://全部
            
            [self appriaseToPostRequestWithgoodsComment:@"" AndimgComment:@""];
            
            break;
        case EvaluateTypeGood://好评
            [self appriaseToPostRequestWithgoodsComment:@"1" AndimgComment:@"2"];
            
            
            break;
        case EvaluateTypeBad://差评
            [self appriaseToPostRequestWithgoodsComment:@"0" AndimgComment:@"2"];
            
            
            break;
        case EvaluateTypeHavePicture://有图
            [self appriaseToPostRequestWithgoodsComment:@"" AndimgComment:@"1"];
            
            
            break;
        default:
            break;
    }
}

- (void)setupPageView {

    NSArray *titleArr   = @[@"xxx",@"sss",@"aa",@"dd"];
//    NSArray *titleArr   = @[_commentNum,_goodCommentNum,_lackCommentNum,_imgCommentNum];
    _segumentView       = [[MTSegmentedControl alloc]initWithFrame:CGRectMake(0, 64, KScreenW, 44)];
    [self.segumentView segmentedControl:titleArr Delegate:self];
    [self.view addSubview:_segumentView];
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
    
    self.evaluate_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+44, KScreenW, KScreenH -64 - 44) style:UITableViewStylePlain];
    self.evaluate_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.evaluate_tableView.delegate = self;
    self.evaluate_tableView.dataSource = self;
    
    self.zfb_tableView = self.evaluate_tableView;
    [self.view addSubview:self.evaluate_tableView];

    
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
    if (self.appraiseListArray.count > 0) {
        
        //初始化五星好评控件
        cell.starView.needIntValue = YES;   //是否整数显示，默认整数显示
        cell.starView.canTouch = NO;//是否可以点击，默认为NO
        NSNumber *number = [NSNumber numberWithInteger:info.goodsComment];
        cell.starView.scoreNum = number;//星星显示个数
        cell.starView.normalColorChain(HEXCOLOR(0xdedede));
        cell.starView.highlightColorChian(HEXCOLOR(0xfe6d6a));
        
    }

//    switch (_evaluateType) {
//        case EvaluateTypeAllDefault://全部
//            
//            break;
//        case EvaluateTypeGood://好评
//            
//            break;
//        case EvaluateTypeBad://差评
//            
//            break;
//        case EvaluateTypeHavePicture://有图
//            
//            break;
//        default:
//            break;
//    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section=%ld  ,row =%ld",indexPath.section , indexPath.row);
    
}
#pragma mark - 查看评价列表 AppraiseSectionCellDelegate

#pragma mark - <MTSegmentedControlDelegate>
- (void)segumentSelectionChange:(NSInteger)selection
{
    _evaluateType = selection ;
    
    switch (_evaluateType) {
        case EvaluateTypeAllDefault://全部
            
            [self appriaseToPostRequestWithgoodsComment:@"" AndimgComment:@""];
            
            break;
        case EvaluateTypeGood://好评
            [self appriaseToPostRequestWithgoodsComment:@"1" AndimgComment:@"2"];
            
            break;
        case EvaluateTypeBad://差评
            [self appriaseToPostRequestWithgoodsComment:@"0" AndimgComment:@"2"];
            
            break;
        case EvaluateTypeHavePicture://有图
            [self appriaseToPostRequestWithgoodsComment:@"" AndimgComment:@"1"];
            
            break;
        default:
            break;
    }
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
            AppraiseModel * appraise = [AppraiseModel mj_objectWithKeyValues:response];
            
            for (Findlistreviews * infoList in appraise.data.goodsCommentList.findListReviews) {
                
                [self.appraiseListArray addObject:infoList];
                
            }
            NSLog(@" ===============appraiseListArray ========== %@",  self.appraiseListArray);
            _commentNum = [NSString stringWithFormat:@"全部(%ld)",appraise.data.goodsCommentList.commentNum];   //全部评论数
            _goodCommentNum = [NSString stringWithFormat:@"好评(%ld)",appraise.data.goodsCommentList.goodCommentNum ];  //好评数
            _lackCommentNum = [NSString stringWithFormat:@"差评(%ld)",appraise.data.goodsCommentList.lackCommentNum ];  //差评数
            _imgCommentNum = [NSString stringWithFormat:@"有图(%ld)",appraise.data.goodsCommentList.imgCommentNum ];    //有图数
         
            [SVProgressHUD dismiss];
            [self.evaluate_tableView reloadData];
        }
        


//        [self setupPageView];
        
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
@end
