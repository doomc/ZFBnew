//
//  ZFEvaluateViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  self.title = @"评论";


#import "ZFEvaluateViewController.h"
#import "ZFAppraiseCell.h"
#import "ZFAppraiseSectionView.h"
#import "AppraiseModel.h"
@interface ZFEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource,AppraiseSectionViewDelegate>
{
    NSInteger _pageSize;//每页显示条数
    NSInteger _pageIndex;//当前页码;
    NSString * _commentNum;
    NSString * _goodCommentNum;
    NSString * _lackCommentNum;
    NSString * _imgCommentNum;
}
@property (nonatomic ,strong) UITableView* evaluate_tableView;
@property (nonatomic ,strong) ZFAppraiseSectionView * sectionView;
@property (nonatomic ,strong) NSMutableArray * appraiseListArray;

@end

@implementation ZFEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //默认一个页码 和 页数
    _pageSize = 10;
    _pageIndex = 1;
    [self initWithEvaluate_tableView];
    
    [self appriaseToPostRequest];
    
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
    
    [self.evaluate_tableView registerNib:[UINib nibWithNibName:@"ZFAppraiseCell" bundle:nil] forCellReuseIdentifier:@"ZFAppraiseCell"];
    _sectionView = [[NSBundle mainBundle]loadNibNamed:@"ZFAppraiseSectionView" owner:self options:nil].lastObject;
//    _sectionView =[[ZFAppraiseSectionView alloc]initWithFrame:CGRectMake(0, 64, KScreenW , 40)];
    _sectionView.delegate = self;
    
}
#pragma mark - AppraiseSectionViewDelegate 选择评论
-(void)whichOneDidClickAppraise:(UIButton *)sender
{
    NSLog(@"网络请求++");
    [self appriaseToPostRequest];
    
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
    return self.sectionView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    height  = [tableView fd_heightForCellWithIdentifier:@"ZFAppraiseCell" configuration:^(id cell) {
        
    }];
    return  height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFAppraiseCell *appraiseCell = [self.evaluate_tableView  dequeueReusableCellWithIdentifier:@"ZFAppraiseCell" forIndexPath:indexPath];
    AppraiseModel * model =self.appraiseListArray[indexPath.row];
    appraiseCell.lb_nickName.text = model.userName;
    appraiseCell.lb_message.text = model.reviewsText;
    appraiseCell.lb_detailtext.text = [NSString stringWithFormat:@"%@之前,来自%@",model.befor,model.equip];
    [appraiseCell.img_appraiseView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.userAvatarImg]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    appraiseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return appraiseCell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section=%ld  ,row =%ld",indexPath.section , indexPath.row);
    
}

#pragma mark - 评论的网络请求 getGoodsCommentInfo
-(void)appriaseToPostRequest
{
    
    NSString * pageSize= [NSString stringWithFormat:@"%ld",_pageSize];
    NSString * pageIndex= [NSString stringWithFormat:@"%ld",_pageIndex];
    
    NSDictionary * params = @{
                              @"goodsId":@"1",
                              @"svcName":@"getGoodsCommentInfo",
                              @"goodsComment":@"",
                              @"imgComment":@"",
                              @"pageSize":pageSize,//每页显示条数
                              @"pageIndex":pageIndex,//当前页码
                              @"cmUserId":BBUserDefault.cmUserId,
                              
                              };
    
    [SVProgressHUD show];
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:params];
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            if (self.appraiseListArray.count >0) {
                
                [self.appraiseListArray  removeAllObjects];
                
            }else{
                
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                NSArray * dictArray = jsondic [@"cmGoodsCommentInfo"];
                
                _commentNum = jsondic [@"commentNum"];          //全部评论数
                _goodCommentNum = jsondic [@"goodCommentNum"];  //好评数
                _lackCommentNum = jsondic [@"lackCommentNum"];  //差评数
                _imgCommentNum = jsondic [@"imgCommentNum"];    //有图数
                
                //mjextention 数组转模型
                NSArray *storArray = [AppraiseModel mj_objectArrayWithKeyValuesArray:dictArray];
                
                for (AppraiseModel *list in storArray) {
                    
                    [self.appraiseListArray addObject:list];
                }
                NSLog(@"storeListArr = %@",  self.appraiseListArray);
                
                [self.evaluate_tableView reloadData];
            }
            [SVProgressHUD dismiss];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
    }];
    
}
@end
