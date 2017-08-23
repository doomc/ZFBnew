//
//  IMChatSessionViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "IMChatSessionViewController.h"
#import "FriendListModel.h"

@interface IMChatSessionViewController ()

@property (nonatomic , strong) NSMutableArray * friendsList;//好友列表

@end

@implementation IMChatSessionViewController

-(NSMutableArray *)friendsList{
    if (!_friendsList) {
        _friendsList = [NSMutableArray array];
    }
    return _friendsList;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self friendListPostRequst];
    [self argeeBecomeFriendPost];
    [self deleteFriendFriendPost];
 
    //群列表
    [self editGroupPost];
    [self userinfoAddGroupPost];
    [self pullFriendJoinGroupPost];
    [self creatGroupPost];
}

#pragma mark - 好友列表 friendList
-(void)friendListPostRequst
{
    
    NSDictionary * param = @{
                             @"friendUserId":BBUserDefault.cmUserId,
                             
                             };
    [NoEncryptionManager noEncryptionPost:[NSString stringWithFormat:@"%@/friendList",IMsingle_baseUrl]  params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            FriendListModel * model = [FriendListModel mj_objectWithKeyValues:response];
            
            for (Userfeiendlist * list in model.data.userFeiendList) {
                
                [self.friendsList addObject:list];
            }
            
        }
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        NSLog(@" 获取好友列表成功");

    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
}


#pragma mark - 用户同意添加好友接口  agreeAddFriend 1直接加好友，2请求加好友，3同意加好友，4拒绝加好友
-(void)argeeBecomeFriendPost
{
    NSDictionary * param = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"accid":BBUserDefault.accid,//用户的accid
                             @"mobilePhone":BBUserDefault.userPhoneNumber,
                             @"type":@"1",//添加好友类型	否	1直接加好友，2请求加好友，3同意加好友，4拒绝加好友
                             @"msg":@"我是你的陪朋友",
                             
                             };
    [NoEncryptionManager noEncryptionPost:[NSString stringWithFormat:@"%@/agreeAddFriend",IMsingle_baseUrl]  params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
 
        }
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        NSLog(@"添加成功");
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

#pragma mark - 删除好友接口 delFriend
-(void)deleteFriendFriendPost
{
    NSDictionary * param = @{
                             @"accid":BBUserDefault.accid,//用户的accid
                             @"faccid":@"15923974943",
 
                             };
    [NoEncryptionManager noEncryptionPost:[NSString stringWithFormat:@"%@/delFriend",IMsingle_baseUrl]  params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
 
            
        }
        NSLog(@"删除");

        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];

    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];

}

#pragma mark - ------------ 群模块 -----------  创建群
-(void)creatGroupPost
{
    NSMutableDictionary * mutAcont = [NSMutableDictionary dictionary];
    [mutAcont setObject:@"zfb_cs1" forKey:@"accId"];
    [mutAcont setObject:@"1" forKey:@"userId"];
    [mutAcont setObject:@"userName" forKey:@"立马"];
    
    NSString * jsonMeber = [NSString convertToJsonData:[NSDictionary dictionaryWithDictionary:mutAcont]] ;

    NSDictionary * param = @{
                             @"groupName":@"群名称",
                             @"userAccId":@"13628311317",//群主id
                             @"userId":BBUserDefault.cmUserId,//群主id	否	我们的用户id
                             @"members":jsonMeber,//群成员
                             @"groupMsg":@"一起开黑啊",//邀请发送的文字，最大长度150字符
                             @"magree":@"0",//管理后台建群时，0不需要被邀请人同意加入群，1需要被邀请人同意才可以加入群。
                             @"joinmode":@"0",//0不用验证，1需要验证,2不允许任何人加入
                             @"icon":@"13628311317",//群头像 最大长度1024字符
                             @"groupNotice":@"群公告",//群公告
                             @"groupIntro":@"群描述",//群描述
                             @"beinvitemode":@"1",//被邀请人同意方式，0-需要同意(默认),1-不需要同意
                             @"invitemode":@"1",//谁可以邀请他人入群，0-管理员(默认),1-所有人
                             @"uptinfomode":@"1",//谁可以修改群资料，0-管理员(默认),1-所有人
                             @"upcustommode":@"1",//谁可以更新群自定义属性，0-管理员(默认),1-所有人
                             @"groupQrcode":@"1",//群二维码
                             @"orderNum":@"1",//1.排序 0.置顶
                             
                             
                             };
    [NoEncryptionManager noEncryptionPost:[NSString stringWithFormat:@"%@/createGroup",IMGroup_baseUrl]  params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            
        }
        NSLog(@"创建群聊");
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];

}




#pragma mark - 拉人进入群
-(void)pullFriendJoinGroupPost
{
    NSMutableDictionary * mutAcont = [NSMutableDictionary dictionary];
    [mutAcont setObject:@"zfb_cs1" forKey:@"accId"];
    [mutAcont setObject:@"1" forKey:@"userId"];
    [mutAcont setObject:@"userName" forKey:@"哎呀妈呀"];
    
    NSString * jsonMeber = [NSString convertToJsonData:[NSDictionary dictionaryWithDictionary:mutAcont]] ;
    
    NSDictionary * param = @{
                             @"tid":@"94667611",//网易云所用的群id
                             @"owner":@"13628311317",//群主accId
                             @"members":jsonMeber,//群成员
                             @"attach":@"自定义扩展字段，最大长度512",//自定义扩展字段，最大长度512
                             @"msg":@"一起开黑啊",//邀请发送的文字，最大长度150字符
                             @"magree":@"0",//管理后台建群时，0不需要被邀请人同意加入群，1需要被邀请人同意才可以加入群。
 
                             
                             
                             };
    [NoEncryptionManager noEncryptionPost:[NSString stringWithFormat:@"%@/addManGroup",IMGroup_baseUrl]  params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            
        }
        NSLog(@"拉入群聊了~~~~~~~");
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];

}





#pragma mark - 用户主动加入群
-(void)userinfoAddGroupPost
{
    NSMutableDictionary * mutAcont = [NSMutableDictionary dictionary];
    [mutAcont setObject:@"zfb_cs1" forKey:@"accId"];
    [mutAcont setObject:@"1" forKey:@"userId"];
    [mutAcont setObject:@"userName" forKey:@"哎呀妈呀"];
    
    NSString * jsonMeber = [NSString convertToJsonData:[NSDictionary dictionaryWithDictionary:mutAcont]] ;
    
    NSDictionary * param = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"groupId":@"94667611",
                             @"members":jsonMeber,//群成员
                             
                             };
    [NoEncryptionManager noEncryptionPost:[NSString stringWithFormat:@"%@/addGroupUser",IMGroup_baseUrl]  params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            
        }
        NSLog(@"拉入群聊了~~~~~~~");
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
}




#pragma mark - 编辑群资料
-(void)editGroupPost
{
 
    NSDictionary * param = @{
                             @"groupName":@"群名称++1",
                             @"id":@"94667611",//群主id
                             @"userAccId":@"13628311317",//群主accId
                             @"userId":@"8",
                             @"acctId":@"8",
                             @"groupMsg":@"一起开黑啊",//邀请发送的文字，最大长度150字符
                             @"magree":@"0",//管理后台建群时，0不需要被邀请人同意加入群，1需要被邀请人同意才可以加入群。
                             @"joinmode":@"0",//0不用验证，1需要验证,2不允许任何人加入
                             @"icon":@"",//群头像 最大长度1024字符
                             @"groupNotice":@"群公告",//群公告
                             @"groupIntro":@"群描述",//群描述
                             @"beinvitemode":@"1",//被邀请人同意方式，0-需要同意(默认),1-不需要同意
                             @"invitemode":@"1",//谁可以邀请他人入群，0-管理员(默认),1-所有人
                             @"uptinfomode":@"1",//谁可以修改群资料，0-管理员(默认),1-所有人
                             @"upcustommode":@"1",//谁可以更新群自定义属性，0-管理员(默认),1-所有人
                             @"groupQrcode":@"1",//群二维码
                             @"order":@"1",//1.排序 0.置顶
                             
                             
                             };
    [NoEncryptionManager noEncryptionPost:[NSString stringWithFormat:@"%@/updateGroup",IMGroup_baseUrl]  params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            
        }
        NSLog(@"编辑群资料  你大爷的~~~~~~~");
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
}






@end
