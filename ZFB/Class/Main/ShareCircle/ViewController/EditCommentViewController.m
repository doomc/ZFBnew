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
#import "CQPlaceholderView.h"
#import "IQKeyboardManager.h"
#import "UIButton+HETouch.h"
#import "NSString+EnCode.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"
#import "NSString+EnCode.h"


@interface EditCommentViewController ()<UITableViewDataSource,UITableViewDelegate,EditCommetCellDelegate,EditCommentFootViewDelegate,CQPlaceholderViewDelegate,UITextViewDelegate>
{
    CGFloat _textHeight;
    NSString * _content;
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) EditCommentFootView * footerView;
@property (nonatomic , strong) NSMutableArray * commentList;//评论列表
@property (nonatomic , strong) CQPlaceholderView *placeholderView;
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
    [self.view addSubview:self.tableView];
    self.zfb_tableView = self.tableView;
    [self initFooterView];

    [self.tableView registerNib:[UINib nibWithNibName:@"EditCommetCell" bundle:nil] forCellReuseIdentifier:@"EditCommetCell"];
   
    [self commentPostList];
    [self setupRefresh];

}
-(void)initFooterView
{
    _textHeight  = 55; //默认一个footer高度
    self.footerView = [[EditCommentFootView alloc]initWithFootViewFrame:CGRectMake(0, KScreenH -55 - 64, KScreenW, 55) AndPlacehold:@"请输入评论"];
    self.footerView.footDelegate = self;
    self.footerView.commentTextView.delegate = self;
    [self.view addSubview:self.footerView ];
    [self.view bringSubviewToFront:self.footerView];

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
    if (BBUserDefault.isLogin == 1) {
        EditCommentList * list  = self.commentList[index];
        [self didZanCommentId:[NSString stringWithFormat:@"%ld",list.comment_id]];
    }else{
        [self isNotLoginWithTabbar:NO];
    }

}
#pragma mark - EditCommentFootViewDelegate  发布评论 代理
-(void)pushlishComment:(UIButton *)sender
{
    if (BBUserDefault.isLogin == 1) {
        if (_content.length > 0){
            sender.he_timeInterval = 1;
            [self commitPublishPostAndContent:_content];
  
        }else{
            [self.view makeToast:@"评论太短了" duration:2 position:@"center"];
        }
    }else{
        [self isNotLoginWithTabbar:NO];
    }

}

-(void)textViewDidChange:(UITextView *)textView {
    
    //获得textView的初始尺寸
    if (self.footerView.commentTextView == textView ) {
        [textView scrollRangeToVisible:NSMakeRange(0, 0)];
        CGFloat width = CGRectGetWidth(textView.frame);
        CGFloat height = CGRectGetHeight(textView.frame);
        CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
        CGRect newFrame = textView.frame;
        newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
        textView.frame= newFrame;
        if (textView.text.length == 0) {
            self.footerView.holdLabel.text = @"请输入评论";
        }else{
            self.footerView.holdLabel.text = @"";
            CGRect  myframe = CGRectMake(0, 0, KScreenW, newFrame.size.height +20);
            CGFloat height2 = CGRectGetHeight(myframe);
            if ( height2 > 67 ) {
                float offset = 164+ 120;
                self.footerView.frame = CGRectMake(0, KScreenH -height2 - 64 - offset, KScreenW, height2);
                self.footerView.layoutConstarainHeight.constant = _textHeight = height2 ;

            }
            _content = [textView.text encodedString];
            
        }
    }
  
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [self insertEmoji];
    //这里的offset的大小是控制着呼出键盘的时候view上移多少。比如上移20，就给offset赋值-20，以此类推。也可以根据屏幕高度的不同做一个if判断。
    
    float offset = 0.0f;
    if(self.footerView.commentTextView == textView){
        offset = -164 -120;
    }
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.footerView.frame = CGRectMake(0, KScreenH -_textHeight - 64 + offset, KScreenW, _textHeight);;
    [UIView commitAnimations];
}

//完成编辑的时候下移回来（只要把offset重新设为0就行了）
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    float offset = 0.0f;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.footerView.frame = CGRectMake(0, KScreenH -_textHeight - 64 - offset, KScreenW, _textHeight);;
    [UIView commitAnimations];
    [self.footerView.commentTextView resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( self.tableView == scrollView) {
        [self.footerView.commentTextView resignFirstResponder];
    }
}

-(void)insertEmoji
{
    //Create emoji attachment
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    
    NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:emojiTextAttachment];
    NSRange selectedRange = self.footerView.commentTextView.selectedRange;
    if (selectedRange.length > 0) {
        [self.footerView.commentTextView.textStorage deleteCharactersInRange:selectedRange];
    }
    //Insert emoji image
    [self.footerView.commentTextView.textStorage insertAttributedString:str atIndex:self.footerView.commentTextView.selectedRange.location];
    self.footerView.commentTextView.selectedRange = NSMakeRange(self.footerView.commentTextView.selectedRange.location+1, 0); //
    
    [self resetTextStyle];
}
- (void)resetTextStyle {
    //After changing text selection, should reset style.
    NSRange wholeRange = NSMakeRange(0, self.footerView.commentTextView.textStorage.length);
    [self.footerView.commentTextView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [self.footerView.commentTextView.textStorage addAttribute:NSFontAttributeName value:self.footerView.commentTextView.font range:wholeRange];
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
            [self commentPostList];
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
            for (EditCommentList * list in commentModel.data.commentList) {
                [self.commentList addObject:list];
            }
            [_placeholderView removeFromSuperview];
            if ([self isEmptyArray:self.commentList]) {
                _placeholderView = [[CQPlaceholderView alloc]initWithFrame:self.tableView.bounds type:CQPlaceholderViewTypeNoComments delegate:self];
                [self.tableView addSubview:_placeholderView];
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
#pragma mark - Delegate - 占位图
/** 占位图的重新加载按钮点击时回调 */
- (void)placeholderView:(CQPlaceholderView *)placeholderView reloadButtonDidClick:(UIButton *)sender{
 
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.footerView.commentTextView resignFirstResponder];
//}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self settingNavBarBgName:@"nav64_gray"];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

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
