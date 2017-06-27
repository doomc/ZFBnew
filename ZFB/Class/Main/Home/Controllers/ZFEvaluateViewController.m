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
    
}
@property (nonatomic ,strong) UITableView* evaluate_tableView;
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
  
    [sectionCell.all_btn setTitle:_commentNum forState:UIControlStateNormal];
    [sectionCell.goodAppraise_btn setTitle:_goodCommentNum forState:UIControlStateNormal];
    [sectionCell.bad_btn setTitle:_lackCommentNum forState:UIControlStateNormal];
    [sectionCell.haveImage_btn setTitle:_imgCommentNum forState:UIControlStateNormal];

    sectionCell.delegate = self;
    
    return sectionCell;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFAppraiseCell *appraiseCell = [self.evaluate_tableView  dequeueReusableCellWithIdentifier:@"ZFAppraiseCell" forIndexPath:indexPath];
    
    appraiseCell.Adelegate = self;
    //    appraiseCell.imgurl = @"http://47.92.118.205:8083/upload/2017/06/21/05513910524572300.jpg,http://47.92.118.205:8083/upload/2017/06/21/05513910524572300.jpg,http://47.92.118.205:8083/upload/2017/06/21/05513910524572300.jpg";
    
    Cmgoodscommentinfo * info = self.appraiseListArray[indexPath.row];

    appraiseCell.imgurl = info.reviewsImgUrl;
    if (self.appraiseListArray.count > 0) {
        
        appraiseCell.lb_nickName.text = info.userName;
        appraiseCell.lb_message.text = info.reviewsText;
        appraiseCell.lb_detailtext.text = [NSString stringWithFormat:@"%@之前,来自%@",info.befor,info.equip];
        [appraiseCell.img_appraiseView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",info.userAvatarImg]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        appraiseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return appraiseCell;
        
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
}
-(void)goodPrisebuttonSelect:(UIButton *)button
{
    NSLog(@"好评");

}
-(void)badPrisebuttonSelect:(UIButton *)button
{
    NSLog(@"差评");

}
-(void)haveImgbuttonSelect:(UIButton *)button
{
    NSLog(@"哟图");

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
                NSArray *commentInfoArray = [Cmgoodscommentinfo mj_objectArrayWithKeyValuesArray:dictArray];
                
                for (Cmgoodscommentinfo * info in commentInfoArray) {
                 
                    [self.appraiseListArray addObject:info];

                }
                NSLog(@" ===============appraiseListArray ========== %@",  self.appraiseListArray);

                _commentNum = jsondic [@"commentNum"];          //全部评论数
                _goodCommentNum = jsondic [@"goodCommentNum"];  //好评数
                _lackCommentNum = jsondic [@"lackCommentNum"];  //差评数
                _imgCommentNum = jsondic [@"imgCommentNum"];    //有图数

                [self shouldReloadData];
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
