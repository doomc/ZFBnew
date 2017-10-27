//
//  DetailMsgNoticeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailMsgNoticeViewController.h"
#import "DetailMsgCell.h"
#import "PersonMessageModel.h"
@interface DetailMsgNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * messagelist;
@end

@implementation DetailMsgNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统通知";
    [self settingTableview];

}
-(NSMutableArray *)messagelist{
    if (!_messagelist) {
        _messagelist = [NSMutableArray array];
    }
    return _messagelist;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self messageListPOSTRequste];
    [self settingNavBarBgName:@"nav64_gray"];
    
}
-(void)settingTableview{
    self.zfb_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-64) style:UITableViewStylePlain];
    self.zfb_tableView.delegate  = self;
    self.zfb_tableView.dataSource = self;
    self.zfb_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.zfb_tableView];
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"DetailMsgCell" bundle:nil] forCellReuseIdentifier:@"DetailMsgCell"];
    [self setupRefresh];
    
}
-(void)footerRefresh{
    [super footerRefresh];
    [self messageListPOSTRequste];
    
}
-(void)headerRefresh{
    [super headerRefresh];
    [self messageListPOSTRequste];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.messagelist.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    PushMessageList * overList = self.messagelist[section];
    return  overList.list.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = nil;
    if (!headView) {
        headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
        headView.backgroundColor = HEXCOLOR(0xf7f7f7);
    
        UILabel *  title = [[UILabel alloc]init];
        title.frame = headView.frame;
        title.font = SYSTEMFONT(14);
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor =HEXCOLOR(0x333333);
        
        PushMessageList * overList = self.messagelist[section];
        title.text = overList.title;
        [headView addSubview:title];
    }
    return headView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailMsgCell" forIndexPath:indexPath];
    if (self.messagelist.count > 0 )  {
        PushMessageList * overList = self.messagelist[indexPath.section];
        DateList * list = overList.list[indexPath.row];
        cell.dateList  = list;
    }
    return cell;
    
}
-(void)messageListPOSTRequste
{
    //消息类型1.用户配送员接单通知 2.用户配送员送达通知 3.用户退货成功通知 4.用户退货金额到账通知 5.用户优惠券到期通知 6.用户共享商品被购买通知 7.用户确认收货通知8.优惠券投放到期通知 9.结算不可用余额通知 10 结算到可用余额通知
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             @"mobilePhone":BBUserDefault.userPhoneNumber,
                             @"msgType":@"",
                             @"timestamp":@"",

                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getPushMessageList"] params:parma success:^(id response) {
        NSString * code = [ NSString stringWithFormat:@"%@",response [@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                if (self.messagelist.count > 0) {
                    [self.messagelist removeAllObjects];
                }
            }
            PersonMessageModel * mess = [PersonMessageModel mj_objectWithKeyValues:response];
            for (PushMessageList * pushlist in mess.pushMessageList) {
                [self.messagelist addObject:pushlist];
            }
            [self.zfb_tableView reloadData];
        }
        
        [self endRefresh];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [self endRefresh];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
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
