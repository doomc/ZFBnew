//
//  PublishShareViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//


#import "PublishShareViewController.h"
//图片选择器
#import "HXPhotoViewController.h"
#import "HXPhotoView.h"
//表情处理
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"
#import "NSString+EnCode.h"

@interface PublishShareViewController ()<HXPhotoViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) NSArray *imgUrlArray;
@property (copy, nonatomic) NSString *imgUrl;
@property (weak, nonatomic) IBOutlet UIView *photoView;


@end

@implementation PublishShareViewController


- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.openCamera = YES;
        _manager.cacheAlbum = YES;
        _manager.lookLivePhoto = YES;
        _manager.cameraType = HXPhotoManagerCameraTypeSystem;
        _manager.photoMaxNum = 5;
        _manager.maxNum = 5;
        _manager.rowCount = 4;
        _manager.saveSystemAblum = NO;
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的共享";
    [self settingBtnBoarder];

    [self settingPhotoView];
    
    [self settingTextView];
    //处理表情
    [self resetTextStyle];
 
}
-(void)settingPhotoView
{
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(15, 10, KScreenW - 30, 0);
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor clearColor];
    [self.photoView  addSubview:photoView];
}
-(void)settingBtnBoarder
{
    self.tf_title.text = _goodsName;
    self.tf_title.delegate = self;
    self.tf_title.clipsToBounds = YES;
    self.tf_title.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 0, 0)];
    self.tf_title.layer.cornerRadius = 4;
    self.tf_title.layer.borderWidth = 1;
    self.tf_title.layer.borderColor = HEXCOLOR(0xe0e0e0).CGColor;
    [self.tf_title addTarget:self action:@selector(textfieldChangetext:) forControlEvents:UIControlEventEditingChanged];
   
    self.commitBtn.layer.cornerRadius = 4;
    self.commitBtn.clipsToBounds = YES;
}
-(void)settingTextView
{
    self.textView.zw_limitCount = 150;//个数显示
    self.textView.zw_labHeight = 20;//高度
    self.textView.layer.cornerRadius = 4;
    self.textView.clipsToBounds = YES;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = HEXCOLOR(0xe0e0e0).CGColor;
    self.textView.placeholder = @"字数在150字以内哦~";
    self.textView.delegate = self;
    // 添加输入改变Block回调.
    [self.textView addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
        _describe = [textView.text encodedString];
        NSLog(@"----%@-----",textView.text);
    }];
    // 添加到达最大限制Block回调.
    [self.textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
        [self.view makeToast:@"超过限制字数了" duration:2 position:@"center"];

    }];
     
}
#pragma mark - UITextFieldDelegate 文本编辑器
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self insertEmoji];
}
-(void)textfieldChangetext:(UITextField *)tf{
    NSLog(@"%@",tf.text);
    _goodsName = tf.text;
}

#pragma mark - UITextViewDelegate 文本编辑器
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"开始编辑");
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
    return YES;
    NSLog(@"结束编辑");
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    _describe = textView.text;
    NSLog(@"结束编辑 ------%@",textView.text);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

    [self.tf_title resignFirstResponder];
}
#pragma mark - HXPhotoViewDelegate 相册选择器
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {

    [HXPhotoTools getImageForSelectedPhoto:photos type:HXPhotoToolsFetchHDImageType completion:^(NSArray<UIImage *> *images) {
        NSSLog(@"%@",images);
        _imgUrlArray = images;
    }];
 
    NSLog(@"_imgUrlArray === %@",_imgUrlArray);

}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {

    NSSLog(@"%@",networkPhotoUrl);
}
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    
//    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.constraintHeight.constant = frame.size.height + 20;
    self.photoView.height = frame.size.height + 20;
}

#pragma  mark  - 发布共享 
- (IBAction)commitAction:(id)sender {
    if (_describe.length > 0  && _goodsName.length > 0 ) {
        if (_imgUrlArray.count>0) {
            if (_imgUrl.length > 0) {
                [self publicMessagePostRequset];
            }else{
                [SVProgressHUD show];
                _commitBtn.userInteractionEnabled = NO;
                _photoView.userInteractionEnabled = NO;
                [OSSImageUploader asyncUploadImages:_imgUrlArray complete:^(NSArray<NSString *> *names, UploadImageState state) {
                    _imgUrl  = [names componentsJoinedByString:@","];
                    
                    NSLog(@"  UploadImageState =  %ld   ,_imgUrl = %@",state,_imgUrl);
                    if (state == 1) {
                        //网络请求
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (_imgUrl.length > 0) {
                                [self publicMessagePostRequset];
                            }
                        });
                    };
                }];
            }
        }else{
            [self.view makeToast:@"请晒出您要共享的图片哦" duration:2 position:@"center"];
        }
    }else{
        [self.view makeToast:@"请填写完标题和评语后再提交" duration:2 position:@"center"];
    }
}


#pragma  mark  - 发布共享内容请求
-(void)publicMessagePostRequset {
    
    NSDictionary * parma = @{
                             @"goodsPrice":_goodsPrice,
                             @"title":_goodsName,
                             @"describe":_describe,
                             @"userId":BBUserDefault.cmUserId,
                             @"imgUrls":_imgUrl,
                             @"goodsId":_goodId,
                             @"userAccount":BBUserDefault.userPhoneNumber,
                             @"userLogo":BBUserDefault.userHeaderImg,
                             @"userNickname":BBUserDefault.nickName,
                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/toShareGoods/goodsShareIssue"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {

            [self.view makeToast:@"发布成功" duration:2 position:@"center"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backAction];
            });
            [SVProgressHUD dismiss];

        }else{
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            [SVProgressHUD dismiss];

        }
        _commitBtn.userInteractionEnabled = YES;
        _photoView.userInteractionEnabled = YES;

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}

- (void)resetTextStyle {
    //After changing text selection, should reset style.
    NSRange wholeRange = NSMakeRange(0, _textView.textStorage.length);
    [_textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_textView.textStorage addAttribute:NSFontAttributeName value:_textView.font range:wholeRange];
}
-(void)insertEmoji
{
    //Create emoji attachment
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    
    NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:emojiTextAttachment];
    NSRange selectedRange = _textView.selectedRange;
    if (selectedRange.length > 0) {
        [_textView.textStorage deleteCharactersInRange:selectedRange];
    }
    //Insert emoji image
    [_textView.textStorage insertAttributedString:str atIndex:_textView.selectedRange.location];
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location+1, 0); // self.textView.selectedRange.length

    //Reset text style
    [self resetTextStyle];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [SVProgressHUD dismiss];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
