//
//  ZFCommitOpinionViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  提交意见


#import "ZFCommitOpinionViewController.h"
#import "FeedTextViewCell.h"
#import "FeedPickerTableViewCell.h"
#import "FeedTypeTableViewCell.h"
@interface ZFCommitOpinionViewController () <UITableViewDataSource,UITableViewDelegate,FeedPickerTableViewCellDelegate>

@property (nonatomic,strong) UITableView  * tableView;
@property (nonatomic,copy)   NSString  * phoneNum;//输入的手机号

@end

@implementation ZFCommitOpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tableView.backgroundColor = randomColor;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeedTypeTableViewCellid"];

    [self.tableView registerNib:[UINib nibWithNibName:@"FeedTextViewCell" bundle:nil] forCellReuseIdentifier:@"FeedTextViewCellid"];

    [self.tableView registerNib:[UINib nibWithNibName:@"FeedPickerTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeedPickerTableViewCellid"];

    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -104) style:UITableViewStylePlain];
        _tableView.dataSource =self;
        _tableView.delegate= self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
#pragma mark - datasoruce  代理实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = 100;
    }else if (indexPath.section == 1)
    {
        height = 135;
    }else{
        height = 220;
    }
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FeedTypeTableViewCell * typeCell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedTypeTableViewCellid" forIndexPath:indexPath];
        
        typeCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return typeCell;
        
    }
    else if (indexPath.section ==1)
    {
        FeedTextViewCell * textViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedTextViewCellid" forIndexPath:indexPath];
        
        textViewCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return textViewCell;
    }
    else{
        FeedPickerTableViewCell * pickerCell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedPickerTableViewCellid" forIndexPath:indexPath];
        pickerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        pickerCell.delegate = self;
        return pickerCell;
    }
 
}
#pragma mark -tableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section === %ld",indexPath.section);
}

#pragma mark - FeedPickerTableViewCellDelegate代理
///输入的手机号码
-(void)phoneNum:(NSString *)phoneNum
{
    if (![phoneNum isMobileNumber]) {
        
        [self.view makeToast:@"手机格式不正确" duration:2.0 position:@"center"];
    }else{
        
        _phoneNum = phoneNum;
    }
}

///提交数据
-(void)didClickCommit
{
    NSLog(@"请求----_phoneNum= %@",_phoneNum);
  
}

@end
