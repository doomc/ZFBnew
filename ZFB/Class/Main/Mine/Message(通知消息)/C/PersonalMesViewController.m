//
//  PersonalMesViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/10/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "PersonalMesViewController.h"
#import "PersonMessageModel.h"
#import "PersonalMessCell.h"
@interface PersonalMesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * messagelist;

@end
@implementation PersonalMesViewController
-(NSMutableArray *)messagelist
{
    if (!_messagelist) {
        _messagelist = [NSMutableArray array];
    }
    return _messagelist;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通知中心";
    [self settingTableview];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self messageListPOSTRequste];
}
-(void)settingTableview
{
    self.zfb_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-64) style:UITableViewStylePlain];
    self.zfb_tableView.delegate  = self;
    self.zfb_tableView.dataSource = self;
//    self.zfb_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.zfb_tableView];
    
    [self.zfb_tableView registerNib:[UINib nibWithNibName:@"PersonalMessCell" bundle:nil] forCellReuseIdentifier:@"PersonalMessCell"];

    [self setupRefresh];

}
-(void)footerRefresh
{
    [super footerRefresh];
    [self messageListPOSTRequste];
}
-(void)headerRefresh
{
    [super headerRefresh];
    [self messageListPOSTRequste];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messagelist.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalMessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalMessCell" forIndexPath:indexPath];

    if (self.messagelist.count > 0 )  {
        PushMessageList * pushList = self.messagelist[indexPath.row];
        cell.pushList  = pushList;
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
                             @"mobilePhone":BBUserDefault.userPhoneNumber
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
//                NSLog(@"content=%@, title=%@", pushlist.content, pushlist.title);
                
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
