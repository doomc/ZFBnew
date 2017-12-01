//
//  EditCommentViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "EditCommentViewController.h"
#import "EditCommentFootView.h"
#import "EditCommetCell.h"
#import "EditCommentModel.h"

@interface EditCommentViewController ()<UITableViewDataSource,UITableViewDelegate,EditCommetCellDelegate,EditCommentFootViewDelegate>
{
    NSString * _commentNum;
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) EditCommentFootView * footerView;
@property (nonatomic , strong) NSMutableArray * commentList;//评论列表

@end

@implementation EditCommentViewController
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH - 64-55) style:UITableViewStylePlain];
        _tableView.delegate = self ;
        _tableView.dataSource  = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSMutableArray *)commentList
{
    if (!_commentList) {
        _commentList = [NSMutableArray array];
    }
    return _commentList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    [self initFooterView];

    [self.view addSubview:self.tableView];
    self.zfb_tableView = self.tableView;
    [self.tableView registerNib:[UINib nibWithNibName:@"EditCommetCell" bundle:nil] forCellReuseIdentifier:@"EditCommetCell"];
   
    [self commentPostList];
    [self setupRefresh];

}
-(void)initFooterView
{
    self.footerView = [[EditCommentFootView alloc]initWithFootViewFrame:CGRectMake(0, KScreenH -55 - 64, KScreenW, 55)];
    self.footerView .footDelegate = self;
    self.footerView.textViewPlacehold = @"请输入评论";
    [self.view addSubview:self.footerView ];
}
-(void)headerRefresh
{
    [super headerRefresh];
    [self commentPostList];
}
-(void)footerRefresh
{
    [super footerRefresh];
    [self commentPostList];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * head = nil;
    if (head == nil) {
        head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 64)];
        head.backgroundColor = [UIColor whiteColor];
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(15,12 , KScreenW, 40)];
        title.text = [NSString stringWithFormat:@"%@条评论",_commentNum];
        title.textColor = HEXCOLOR(0x333333);
        [head addSubview:title];
        
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63, KScreenW, 1)];
        line.backgroundColor = HEXCOLOR(0xe0e0e0);
        [head addSubview:line];
        
    }
    return head;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"EditCommetCell" configuration:^(id cell) {
        [self setUpConfigCell:cell WithIndexPath:indexPath];
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditCommetCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditCommetCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.row;
    [self setUpConfigCell:cell WithIndexPath:indexPath];
    
    return cell;
}

-(void)setUpConfigCell:( EditCommetCell *)cell WithIndexPath :(NSIndexPath*)indexPath
{
    if (self.commentList.count > 0) {
        EditCommentList * list  = self.commentList[indexPath.row];
        cell.commentlist = list;
    }
}
#pragma mark - EditCommetCellDelegate  点赞 代理
-(void)didClickZanWithIndex:(NSInteger)index
{
    EditCommentList * list  = self.commentList[index];
    [self didZanCommentId:[NSString stringWithFormat:@"%ld",list.comment_id]];
}
#pragma mark - EditCommentFootViewDelegate  发布评论 代理
-(void)pushlishCommentWithContent:(NSString *)content
{
    if (content.length > 0) {
        [self commitPublishPostAndContent:content];
    }else
    {
        [self.view makeToast:@"评论太短了" duration:2 position:@"center"];
    }
}


//发布评论
-(void)commitPublishPostAndContent:(NSString *)content
{
    NSDictionary * param = @{
                             @"cmUserId":BBUserDefault.cmUserId,//评论或回复用户
                             @"topic_id":_shareId,
                             @"parent_id":@"0",//上级id，评论上级id0
                             @"content":content,//评论内容
                             @"comment_img_url":@"",//评论图片，逗号隔开
                             @"nickname":BBUserDefault.nickName,//昵称
                             @"thumb_img":BBUserDefault.userHeaderImg,//头像地址
 
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/shareComment/setComment",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];

        }else
        {
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self endRefresh];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}
//列表
-(void)commentPostList
{
    NSDictionary * param = @{
                             @"topicId":_shareId,//分享id
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"type":@"1",
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/shareComment/getComment",zfb_baseUrl] params:param success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                if (self.commentList.count > 0) {
                    [self.commentList removeAllObjects];
                }
            }
            EditCommentModel * commentModel = [EditCommentModel mj_objectWithKeyValues:response];
            _commentNum = [NSString stringWithFormat:@"%ld",commentModel.data.num];
            for (EditCommentList * list in commentModel.data.commentList) {
                [self.commentList addObject:list];
            }
            
            [self.tableView reloadData];
        }else{
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }
        [self endRefresh];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self endRefresh];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}
//点赞请求
-(void)didZanCommentId:(NSString *)commentId
{
    NSDictionary * param = @{
                             @"mark":@"1",
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"comment_id":commentId,//评论id
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/shareComment/commentLike",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            [self commentPostList];
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
         [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}
-(void)loadNodataView
{
    UIImageView * noDataImageView = [[UIImageView alloc]init];
    noDataImageView.image = [UIImage imageNamed:@""];
    noDataImageView.center = self.view.center;
    [self.view addSubview:noDataImageView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];
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
