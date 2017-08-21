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
#import "FeedCommitPhoneCell.h"
@interface ZFCommitOpinionViewController ()
<
    UITableViewDataSource,UITableViewDelegate,
    FeedPickerTableViewCellDelegate,
    UIActionSheetDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    FeedTypeTableViewCellDelegate,
    FeedCommitPhoneCellDelegate
>

@property (nonatomic,strong) UITableView  * tableView;
@property (nonatomic,copy)   NSString  * phoneNum;//输入的手机号
@property (nonatomic,copy)   NSString  * textViewText;//输入的手机号
@property (nonatomic,copy)   NSString  * selectedTypeText;//输入的手机号

//上传图片的图片数组
@property (nonatomic , strong) NSMutableArray  *uploadImageArray;

//类型
@property (nonatomic , strong) NSArray * typeArray;
@property (nonatomic , copy) NSString * typeName;
@property (nonatomic , copy) NSString * pickerImgString;//图片数组的字符串用逗号隔开
@property (nonatomic , assign) CGFloat cellHeight;//选择照片的高度

@end

@implementation ZFCommitOpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeedTypeTableViewCellid"];

    [self.tableView registerNib:[UINib nibWithNibName:@"FeedTextViewCell" bundle:nil] forCellReuseIdentifier:@"FeedTextViewCellid"];

    [self.tableView registerNib:[UINib nibWithNibName:@"FeedPickerTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeedPickerTableViewCellid"];

    [self.tableView registerNib:[UINib nibWithNibName:@"FeedCommitPhoneCell" bundle:nil] forCellReuseIdentifier:@"FeedCommitPhoneCellid"];
    
    [self.view addSubview:self.tableView];
    
 
  
    [self getFeedbackTypePOSTRequste];

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
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = 40+40 * (_typeArray.count/4.0);
    }else if (indexPath.section == 1)
    {
        height = 135;
    }else if (indexPath.section == 2){
       
        if (self.uploadImageArray.count > 0) {
            
            height = _cellHeight + 40;
            
        }
        else{
            height = 132 ;
        }
    }
    else{
        height = 120;
    }
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FeedTypeTableViewCell * typeCell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedTypeTableViewCellid" forIndexPath:indexPath];
        typeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        typeCell.delegate = self;
        typeCell.nameArray = _typeArray;
        typeCell.collectionViewLayoutHeight.constant =  40 * (_typeArray.count/4.0);
        [typeCell.typeCollectionView reloadData];
        return typeCell;
        
    }
    else if (indexPath.section == 1)
    {
        FeedTextViewCell * textViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedTextViewCellid" forIndexPath:indexPath];
        textViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _textViewText  = textViewCell.textView.text;
        
        return textViewCell;
    }
    else if (indexPath.section ==2){
        FeedPickerTableViewCell * pickerCell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedPickerTableViewCellid" forIndexPath:indexPath];
        pickerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        pickerCell.delegate = self;
 
        return pickerCell;
    }
    else{
        FeedCommitPhoneCell * phoneCell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedCommitPhoneCellid" forIndexPath:indexPath];
        phoneCell.commitDelegate = self;
        return phoneCell;
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
    if (phoneNum.length == 11) {
 
        if (![phoneNum isMobileNumberClassification]) {
            
            [self.view makeToast:@"手机格式不正确" duration:2.0 position:@"center"];
        }else{
            
            _phoneNum = phoneNum;
        }
    }
}

///提交数据
-(void)didClickCommit
{
    NSLog(@"反馈类型 ----%@",_typeName);
    if ([_typeName isEqualToString:@""]|| _typeName == nil) {
        JXTAlertController * alert = [JXTAlertController alertControllerWithTitle:@"请选择一个反馈类型" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        [self getFeedbackINfoInsertPOSTRequste];
   
    }
}



//上传图后局部刷新图片行 根据布局相应调整
-(void)reloadCellHeight:(CGFloat)cellHeight
{
    _cellHeight = cellHeight;
}
////内部的ucell 中的数组传出
-(void)uploadImageArray:(NSMutableArray *)uploadArr
{
    self.uploadImageArray =  uploadArr;
    [self.tableView reloadData];

}
-(NSMutableArray *)uploadImageArray{
    if (!_uploadImageArray) {
        _uploadImageArray = [NSMutableArray array];
    }
    return _uploadImageArray;
}

 
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
#pragma mark  - 平台意见类型网络请求 getFeedbackType
-(void)getFeedbackTypePOSTRequste
{
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getFeedbackType"] params:nil success:^(id response) {
        
        NSString * typestr = response[@"feedbackType"];
        
        _typeArray = [NSArray array];
        _typeArray = [typestr componentsSeparatedByString:@","];
        
        NSLog(@"%@",_typeArray);
        
        [self.tableView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
 
 
#pragma mark -  FeedTypeTableViewCellDelegate
-(void)didClickTypeName:(NSString *)typeName Index :(NSInteger)index
{
    _typeName = typeName;
    // 此处获取类型
    NSLog(@"_typeName = %@",_typeName);
}

#pragma mark  - 保存用户反馈意见（针对平台反馈的意见)getFeedbackINfoInsert
-(void)getFeedbackINfoInsertPOSTRequste
{
    if (_phoneNum == nil || _pickerImgString == nil  ) {
        _phoneNum = @"";
        _pickerImgString = @"";
    }
    
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"feedbackType":_typeName,//反馈类型
                             @"feedbackContent":_textViewText,//反馈意见
                             @"feedbackUrl":_pickerImgString,//图片评论
                             @"feedbackUserPhone":_phoneNum,//用户预留电话
 
                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getFeedbackINfoInsert"] params:parma success:^(id response) {

        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];

    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}




@end
