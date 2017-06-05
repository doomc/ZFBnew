//
//  ZFSettingHeadViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSettingHeadViewController.h"
#import "ZFSettingHeaderCell.h"
#import "ZFSettingRowCell.h"
#import "ZFSettingAddressViewController.h"


static NSString * settingheadid = @"ZFSettingHeaderCellid";
static NSString * settingRowid = @"ZFSettingRowCellid";

@interface ZFSettingHeadViewController ()<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate,QBImagePickerControllerDelegate>
{
    NSArray * _titleArr;
    NSMutableArray * imageMutableArray;

}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) QBImagePickerController * qbPickerController;
@property (nonatomic,retain) UIImagePickerController * imagePickerController;


@end

@implementation ZFSettingHeadViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.title = @"个人资料";
    _titleArr  = @[@"昵称",@"性别",@"生日",@"地址管理"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFSettingHeaderCell" bundle:nil] forCellReuseIdentifier:settingheadid];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFSettingRowCell" bundle:nil] forCellReuseIdentifier:settingRowid];
    
    [self.view addSubview:self.tableView];
    
}
-(QBImagePickerController *)qbPickerController
{
    if (!_qbPickerController) {
        _qbPickerController = [QBImagePickerController new];
        _qbPickerController.maximumNumberOfSelection = 5;
        _qbPickerController.allowsMultipleSelection = YES;
        _qbPickerController.showsNumberOfSelectedAssets = YES;
        _qbPickerController.delegate = self;
        _qbPickerController.automaticallyAdjustsScrollViewInsets = NO;
        [self presentViewController:_qbPickerController animated:YES completion:nil];

    }
    return _qbPickerController;
}

- (UIImagePickerController*)imagePickerController{
    if (!_imagePickerController) {
        _imagePickerController  = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;//设置可编辑
    }
    return _imagePickerController;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    NSString * saveStr = @"保存";
    UIButton *right_button = [[UIButton alloc]init];
    [right_button setTitle:saveStr forState:UIControlStateNormal];
    right_button.titleLabel.font=SYSTEMFONT(14);
    [right_button setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
    right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width = size.width ;
    right_button.frame =CGRectMake(0, 0, width+10, 22);
    
    return right_button;
}
//设置右边事件
-(void)right_button_event:(UIButton*)sender{
    NSLog(@"保存")
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if (indexPath.section == 0) {
    
        ZFSettingHeaderCell * headCell = [self.tableView dequeueReusableCellWithIdentifier:settingheadid forIndexPath:indexPath];
        headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        headCell.lb_title.text =@"头像";
        cell =  headCell;

    }if (indexPath.section == 1 ) {
        ZFSettingRowCell * rowCell = [self.tableView dequeueReusableCellWithIdentifier:settingRowid forIndexPath:indexPath];
        rowCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        rowCell.lb_title.text = _titleArr[indexPath.row];
        cell = rowCell;
        
    }
    return cell;
 
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sectin = %ld,row = %ld",indexPath.section ,indexPath.row);
    if (indexPath.section == 0) {
        
        [self showActionForPhoto];
        
//        [self jxt_showActionSheetWithTitle:nil message:@"选择你喜欢的头像" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
//            alertMaker.
//            addActionCancelTitle(@"取消").
//            addActionDestructiveTitle(@"拍照").
//            addActionDefaultTitle(@"从相册中选择");
// 
//        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
//            
//            if ([action.title isEqualToString:@"取消"]) {
//                NSLog(@"cancel");
//  
//            }
//            else if ([action.title isEqualToString:@"拍照"]) {
//                NSLog(@"拍照");
//                
//                //拍照
//                if (![cameraHelper checkCameraAuthorizationStatus]) {
//                    return;
//                }
//                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                picker.delegate = self;
//                picker.allowsEditing = NO;//设置可编辑
//                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                [self presentViewController:picker animated:YES completion:nil];//进入照相界面
//            }
//            else if ([action.title isEqualToString:@"从相册中选择"]) {
//                NSLog(@"从相册中选择");
//                
//                //相册
//                if (![cameraHelper checkPhotoLibraryAuthorizationStatus]) {
//                    return;
//                }
//             }
//          
//        }];

    }
    if (indexPath.section == 1){
        if (indexPath.row == 3)
        {
            ZFSettingAddressViewController *addVC = [[ZFSettingAddressViewController alloc]init];
            [self.navigationController pushViewController:addVC animated:YES];
        }
    }
   
}
#pragma mark - UIAlertController
- (void)showActionForPhoto{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择照片路径" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSLog(@"该设备不支持相机");
        }else{
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:self.imagePickerController
                                                    animated:YES
                                                  completion:nil];
        }
    }];
    
    
    UIAlertAction *cameroAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            NSLog(@"该设备不支持从相册选取文件");
        }else{
            
            [self presentViewController:self.qbPickerController animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:photoAction];
    [alertController addAction:cameroAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *imageMutableArray = [[NSMutableArray alloc] init];
    [imageMutableArray removeAllObjects];
    NSInteger n = 0;
    for (ALAsset * asset in assets) {
        CGImageRef ref = [asset thumbnail];    //获取缩略图
        UIImage *thumbnailImg = [[UIImage alloc]initWithCGImage:ref];
        [imageMutableArray addObject:thumbnailImg];
        n++;
    }
    
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
