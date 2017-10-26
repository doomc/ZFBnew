//
//  ZFCInterpersonalCircleViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****人际圈

#import "ZFCInterpersonalCircleViewController.h"
#import "SGPagingView.h"//控制自控制器
//#import "IMContactListViewController.h"//联系人通讯录
//#import "IMFriendsCircleViewController.h"//朋友圈
//#import "IMChatSessionViewController.h"//会话列表
#import "NTESCustomNotificationDB.h"

#import "NTESSessionListViewController.h"//当前会话列表
#import "NTESContactViewController.h"//联系人通讯录

#import "LoginViewController.h"
#import "ZFBaseNavigationViewController.h"
#import "IMSearchFriendViewController.h"//添加好友

#import "ZFBaseNavigationViewController.h"
#import "NTESSessionViewController.h"
#import "UIActionSheet+NTESBlock.h"
#import "Toast+UIView.h"
#import "NIMContactSelectViewController.h"
#import "NTESGroupedContacts.h"
#import "NTESContactUtilItem.h"
#import "PPBadgeView.h"
@interface ZFCInterpersonalCircleViewController () <SGPageTitleViewDelegate, SGPageContentViewDelegate,NIMUserManagerDelegate,NIMLoginManagerDelegate,NIMSystemNotificationManagerDelegate,NIMConversationManagerDelegate>
{
    UIRefreshControl *_refreshControl;
    NTESGroupedContacts *_contacts;
}

@property (nonatomic, strong) SGPageTitleView   *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;


@end

@implementation ZFCInterpersonalCircleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupPageView];
    
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    

}
- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setupPageView {
    
    NTESSessionListViewController  *messageVC       = [[NTESSessionListViewController alloc]init];
    NTESContactViewController *contactVC        = [[NTESContactViewController alloc]init];
//    IMChatSessionViewController *friendVC       = [[IMChatSessionViewController alloc]init];
    
    NSArray *childArr = @[messageVC, contactVC];
    
    /// pageContentView
    CGFloat contentViewHeight                = self.view.frame.size.height - 44 ;
    self.pageContentView                     = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    NSArray *titleArr = @[@"消息", @"通讯录"];
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self titleNames:titleArr];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.isTitleGradientEffect   = YES;
    _pageTitleView.indicatorLengthStyle    = SGIndicatorLengthStyleSpecial;
    _pageTitleView.indicatorScrollStyle    = SGIndicatorScrollStyleHalf;
    _pageTitleView.selectedIndex           = 0;
    _pageTitleView.isShowBottomSeparator   = NO;
    _pageTitleView.isNeedBounces           = NO;
    _pageTitleView.titleColorStateSelected = HEXCOLOR(0xf95a70);
    _pageTitleView.titleColorStateNormal = HEXCOLOR(0x7a7a7a);
    _pageTitleView.indicatorColor = HEXCOLOR(0xf95a70);
    _pageTitleView.indicatorHeight         = 1.0;
    _pageTitleView.titleTextScaling        = 0.3;

}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    
    if (selectedIndex == 0) {
        [self setCustomerTitle:@"消息" textColor:[UIColor whiteColor]];
    }
    else if (selectedIndex == 1) {
        [self setCustomerTitle:@"通讯录" textColor:[UIColor whiteColor]];

    }
    else {
     
    }
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    
    
}
- (void)prepareData{
    _contacts = [[NTESGroupedContacts alloc] init];
    
    NSString *contactCellUtilIcon   = @"icon";
    NSString *contactCellUtilVC     = @"vc";
    NSString *contactCellUtilBadge  = @"badge";
    NSString *contactCellUtilTitle  = @"title";
    NSString *contactCellUtilUid    = @"uid";
    NSString *contactCellUtilSelectorName = @"selName";
    //原始数据
    
    NSInteger systemCount = [[[NIMSDK sharedSDK] systemNotificationManager] allUnreadCount];
    NSMutableArray *utils =
    [@[
       @{
           contactCellUtilIcon:@"icon_notification_normal",
           contactCellUtilTitle:@"验证消息",
           contactCellUtilVC:@"NTESSystemNotificationViewController",
           contactCellUtilBadge:@(systemCount)
           },
       @{
           contactCellUtilIcon:@"icon_team_advance_normal",
           contactCellUtilTitle:@"高级群",
           contactCellUtilVC:@"NTESAdvancedTeamListViewController"
           },

       ] mutableCopy];
    
    
    //构造显示的数据模型
    NTESContactUtilItem *contactUtil = [[NTESContactUtilItem alloc] init];
    NSMutableArray * members = [[NSMutableArray alloc] init];
    for (NSDictionary *item in utils) {
        NTESContactUtilMember *utilItem = [[NTESContactUtilMember alloc] init];
        utilItem.nick              = item[contactCellUtilTitle];
        utilItem.icon              = [UIImage imageNamed:item[contactCellUtilIcon]];
        utilItem.vcName            = item[contactCellUtilVC];
        utilItem.badge             = [item[contactCellUtilBadge] stringValue];
        utilItem.userId            = item[contactCellUtilUid];
        utilItem.selName           = item[contactCellUtilSelectorName];
        [members addObject:utilItem];
    }
    contactUtil.members = members;
    
    [_contacts addGroupAboveWithTitle:@"" members:contactUtil.members];
}

- (void)setUpNavItem{
    // 设置导航栏颜色
//    [self.navigationController.navigationBar setBarTintColor:RGBA(244, 244, 244, 1.0)];    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xfe6d6a),NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    
    UIButton *teamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [teamBtn addTarget:self action:@selector(onOpera:) forControlEvents:UIControlEventTouchUpInside];
    [teamBtn setImage:[UIImage imageNamed:@"icon_tinfo_normal"] forState:UIControlStateNormal];
    [teamBtn setImage:[UIImage imageNamed:@"icon_tinfo_pressed"] forState:UIControlStateHighlighted];
    [teamBtn sizeToFit];
    UIBarButtonItem *teamItem = [[UIBarButtonItem alloc] initWithCustomView:teamBtn];
    self.navigationItem.rightBarButtonItem = teamItem;
}

#pragma mark - Action
- (void)onEnterMyComputer{
    NSString *uid = [[NIMSDK sharedSDK].loginManager currentAccount];
    NIMSession *session = [NIMSession session:uid type:NIMSessionTypeP2P];
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onOpera:(id)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加好友/群",@"创建群", nil];
    __weak typeof(self) wself = self;
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        UIViewController *vc;
        switch (index) {
            case 0:
            {
                IMSearchFriendViewController * serchVC = [[IMSearchFriendViewController alloc]init];
                [wself.navigationController pushViewController:serchVC animated:YES];
                
            }
                break;
            case 1:{  //创建高级群
                [wself presentMemberSelector:^(NSArray *uids) {
                    NSArray *members = [@[currentUserId] arrayByAddingObjectsFromArray:uids];
                    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
                    option.name       = @"高级群";
                    option.type       = NIMTeamTypeAdvanced;
                    option.joinMode   = NIMTeamJoinModeNoAuth;
                    option.postscript = @"邀请你加入群组";
                    [SVProgressHUD show];
                    [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError * _Nullable error, NSString * _Nullable teamId, NSArray<NSString *> * _Nullable failedUserIds) {
                        [SVProgressHUD dismiss];
                        if (!error) {
                            NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                            [wself.navigationController pushViewController:vc animated:YES];
                        }else{
                            [wself.view makeToast:@"创建失败" duration:2.0 position:@"CSToastPositionCenter"];
                        }
                    }];
                }];
                break;
            }
                
            default:
                
                break;
        }

        if (vc) {
            [wself.navigationController pushViewController:vc animated:YES];
        }
    }];

}

#pragma mark - NIMSDK Delegate
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    [self prepareData];
    NTESContactViewController * contactVC= [NTESContactViewController new];
    [contactVC.tableView reloadData];
}

- (void)onLogin:(NIMLoginStep)step
{
    NTESContactViewController * contactVC= [NTESContactViewController new];
    
    if (step == NIMLoginStepSyncOK) {
        if (self.isViewLoaded) {//没有加载view的话viewDidLoad里会走一遍prepareData
            [self prepareData];
            [contactVC.tableView reloadData];
            
        }
    }
}

- (void)onUserInfoChanged:(NIMUser *)user
{
    [self refresh];
}

- (void)onFriendChanged:(NIMUser *)user{
    [self refresh];
}

- (void)onBlackListChanged
{
    [self refresh];
}

- (void)onMuteListChanged
{
    [self refresh];
}

- (void)refresh
{
    [self prepareData];
    
    NTESContactViewController * contactVC= [NTESContactViewController new];
    [contactVC.tableView reloadData];
}

- (void)presentMemberSelector:(ContactSelectFinishBlock) block{
    NSMutableArray *users = [[NSMutableArray alloc] init];
    //使用内置的好友选择器
    NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
    //获取自己id
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [users addObject:currentUserId];
    //将自己的id过滤
    config.filterIds = users;
    //需要多选
    config.needMutiSelected = YES;
    //初始化联系人选择器
    NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
    //回调处理
    vc.finshBlock = block;
    [vc show];
}



-(void)viewWillAppear:(BOOL)animated
{
    [self setUpNavItem];
 
    // 设置导航栏title属性
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    UIImage *image = [UIImage imageNamed:@"nav64_red"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}





@end
