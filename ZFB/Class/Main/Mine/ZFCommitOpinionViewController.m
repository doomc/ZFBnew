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
@interface ZFCommitOpinionViewController () <UITableViewDataSource,UITableViewDelegate,FeedPickerTableViewCellDelegate,QBImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,FeedTypeTableViewCellDelegate>

@property (nonatomic,strong) UITableView  * tableView;

@property (nonatomic,copy)   NSString  * phoneNum;//输入的手机号
@property (nonatomic,copy)   NSString  * textViewText;//输入的手机号
@property (nonatomic,copy)   NSString  * selectedTypeText;//输入的手机号

//上传图片的图片数组
@property (strong, nonatomic) MPUploadImageHelper *curUploadImageHelper;
@property (nonatomic , strong) NSMutableArray<UIImage *> *uploadImageArray;

//类型
@property (nonatomic , strong) NSArray * typeArray;
@property (nonatomic , copy) NSString * typeName;
@property (nonatomic , copy) NSString * pickerImgString;//图片数组的字符串用逗号隔开

@end

@implementation ZFCommitOpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeedTypeTableViewCellid"];

    [self.tableView registerNib:[UINib nibWithNibName:@"FeedTextViewCell" bundle:nil] forCellReuseIdentifier:@"FeedTextViewCellid"];

    [self.tableView registerNib:[UINib nibWithNibName:@"FeedPickerTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeedPickerTableViewCellid"];

    [self.view addSubview:self.tableView];
    
    //初始化
    _curUploadImageHelper = [MPUploadImageHelper MPUploadImageForSend:NO];

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
        height = 40+40 * (_typeArray.count/4.0);
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
        typeCell.delegate = self;
        typeCell.nameArray = _typeArray;
        typeCell.collectionViewLayoutHeight.constant =  40 * (_typeArray.count/4.0);
        [typeCell.typeCollectionView reloadData];
        return typeCell;
        
    }
    else if (indexPath.section ==1)
    {
        FeedTextViewCell * textViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedTextViewCellid" forIndexPath:indexPath];
        textViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _textViewText  = textViewCell.textView.text;
        
        return textViewCell;
    }
    else {
        MPWeakSelf(self);
        FeedPickerTableViewCell * pickerCell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedPickerTableViewCellid" forIndexPath:indexPath];
        pickerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        pickerCell.delegate = self;
        pickerCell.addPicturesBlock = ^(){
            [weakself showActionForPhoto];
        };
        pickerCell.deleteImageBlock = ^(MPImageItemModel *toDelete){
            [weakself.curUploadImageHelper deleteAImage:toDelete];
            [weakself.tableView reloadData];
        };
        pickerCell.curUploadImageHelper=self.curUploadImageHelper;
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
    if (phoneNum.length == 11) {
 
        if (![phoneNum isMobileNumber]) {
            
            [self.view makeToast:@"手机格式不正确" duration:2.0 position:@"center"];
        }else{
            
            _phoneNum = phoneNum;
        }
    }
}

///提交数据
-(void)didClickCommit
{
    NSLog(@"请求----_phoneNum= %@",_phoneNum);
    
    [self getFeedbackINfoInsertPOSTRequste];
    
  
}

//弹出选择框
-(void)showActionForPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"从相册选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //拍照
        if (![cameraHelper checkCameraAuthorizationStatus]) {
            return;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;//设置可编辑
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    }else if (buttonIndex == 1){
        //相册
        if (![cameraHelper checkPhotoLibraryAuthorizationStatus]) {
            return;
        }
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        [imagePickerController.selectedAssetURLs removeAllObjects];
        [imagePickerController.selectedAssetURLs addObjectsFromArray:self.curUploadImageHelper.selectedAssetURLs];
        imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        imagePickerController.delegate = self;
        imagePickerController.maximumNumberOfSelection = kupdateMaximumNumberOfImage;
        imagePickerController.allowsMultipleSelection = YES;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
   
    [assetsLibrary writeImageToSavedPhotosAlbum:[pickerImage CGImage] orientation:(ALAssetOrientation)pickerImage.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        [self.curUploadImageHelper addASelectedAssetURL:assetURL];
        
        
        //局部刷新 根据布局相应调整
        [self partialTableViewRefresh];
    }];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
 
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UINavigationControllerDelegate, QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    NSMutableArray *selectedAssetURLs = [NSMutableArray new];
    [imagePickerController.selectedAssetURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedAssetURLs addObject:obj];
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.curUploadImageHelper.selectedAssetURLs = selectedAssetURLs;
    
        //局部刷新 根据布局相应调整
        [self partialTableViewRefresh];
    });
#warning ------添加到阿里服务器会崩溃
//    NSLog(@"selectedAssetURLs ===== %@", selectedAssetURLs);
//    NSArray * imgArray = [NSArray arrayWithArray:selectedAssetURLs];
//    [OSSImageUploader asyncUploadImages:imgArray complete:^(NSArray<NSString *> *names, UploadImageState state) {
//        NSLog(@"names---%@", names);
//        
//    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//上传图后局部刷新图片行 根据布局相应调整
-(void)partialTableViewRefresh
{
    [self.tableView reloadData];
}

-(NSMutableArray<UIImage *> *)uploadImageArray {
    
    if (!_uploadImageArray) {
        _uploadImageArray = [NSMutableArray<UIImage *> array];
        MPWeakSelf(self);
        [self.curUploadImageHelper.imagesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MPImageItemModel *itemModel = obj;
            [weakself.uploadImageArray addObject:itemModel.image];

        }];
    }
    return _uploadImageArray;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self getFeedbackTypePOSTRequste];
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
