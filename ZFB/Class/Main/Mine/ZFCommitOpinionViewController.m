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
@interface ZFCommitOpinionViewController () <UITableViewDataSource,UITableViewDelegate,FeedPickerTableViewCellDelegate,QBImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView  * tableView;
@property (nonatomic,copy)   NSString  * phoneNum;//输入的手机号

@property (strong, nonatomic) MPUploadImageHelper *curUploadImageHelper;

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
    
    //初始化
    _curUploadImageHelper=[MPUploadImageHelper MPUploadImageForSend:NO];
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
    else {
        MPWeakSelf(self);
        FeedPickerTableViewCell * pickerCell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedPickerTableViewCellid" forIndexPath:indexPath];
        pickerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        pickerCell.delegate = self;
        pickerCell.addPicturesBlock = ^(){
            [weakself showActionForPhoto];
        };
//        pickerCell.curUploadImageHelper=self.curUploadImageHelper;
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
//        [self partialTableViewRefresh];
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
//        [self partialTableViewRefresh];
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//上传图后局部刷新图片行 根据布局相应调整
-(void)partialTableViewRefresh
{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
}

@end
