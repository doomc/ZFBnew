  //
//  ZZYPhotoHelper.m
//  dd
//
//  Created by dd on 16/9/9.
//  Copyright © 2016年 Tuse. All rights reserved.
//

#import "ZZYPhotoHelper.h"
#import "ZFBaseNavigationViewController.h"
@interface ZZYPhotoDelegateHelper: NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, copy) ZZYPhotoHelperBlock selectImageBlock;

@end

@interface ZZYPhotoHelper ()

@property (nonatomic, strong) ZZYPhotoDelegateHelper *helper;

@end

static ZZYPhotoHelper *picker = nil;

@implementation ZZYPhotoHelper


+ (instancetype)shareHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[ZZYPhotoHelper alloc] init];
    });
    return picker;
}

- (void)showImageViewSelcteWithResultBlock:(ZZYPhotoHelperBlock)selectImageBlock{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * library = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self creatWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary block:selectImageBlock];
    }];
    UIAlertAction * carmare = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [self creatWithSourceType:UIImagePickerControllerSourceTypeCamera block:selectImageBlock];
        }else{
            [MBProgressHUD showMessage:@"相机功能暂不能使用"];
        }
    }];
    [alertController addAction:canleAction];
    [alertController addAction:library];
    [alertController addAction:carmare];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:^{
        [self settingNavBarBgName:@"nav64_gray"];
    }];
}

-(void)settingNavBarBgName:(NSString *)bgName
{
    ZFBaseNavigationViewController *nvc =  (ZFBaseNavigationViewController *)self.navigationController;
    
    UINavigationBar *navBar = nvc.navigationBar;
    // 设置导航栏title属性
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :HEXCOLOR(0x333333)}];
    // 设置导航栏颜色
    [navBar setBarTintColor:[UIColor clearColor]];
    UIImage *image = [UIImage imageNamed:bgName];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    
}

- (void)creatWithSourceType:(UIImagePickerControllerSourceType)sourceType block:selectImageBlock
{
    picker.helper   = [[ZZYPhotoDelegateHelper alloc] init];
    picker.delegate  = picker.helper;
    picker.sourceType  = sourceType;
    picker.allowsEditing = YES;//默认是可以修改的
    
    picker.helper.selectImageBlock = selectImageBlock;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self animated:YES completion:nil];
}

@end


@implementation ZZYPhotoDelegateHelper

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *theImage = nil;
    
    // 判断，图片是否允许修改。默认是可以的
    if ([picker allowsEditing]){
        
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else {
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    CGSize imagesize = theImage.size;
    imagesize.height = KScreenW*3/4;
    imagesize.width  = KScreenW*3/4;
    
    if (_selectImageBlock) {
        //设置image的尺寸
        theImage = [self imageWithImageSimple:theImage scaledToSize:imagesize];
        
        [OSSImageUploader asyncUploadImage:theImage complete:^(NSArray<NSString *> *names, UploadImageState state) {
            
            NSString * imgPath =  names[0];
            NSLog(@" 11111 uploadImgName =====  %@ ",names[0]);
            _selectImageBlock(theImage,imgPath);

        }];

    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//压缩图片
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{

    
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


@end
