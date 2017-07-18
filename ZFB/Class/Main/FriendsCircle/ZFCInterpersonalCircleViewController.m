//
//  ZFCInterpersonalCircleViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****人际圈

#import "ZFCInterpersonalCircleViewController.h"


static NSString *const dataUrl = @"http://api.budejie.com/api/api_open.php";
static NSString *const downloadUrl = @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4";


@interface ZFCInterpersonalCircleViewController ()
@property(nonatomic,strong)   UITextView  * textView;

@end

@implementation ZFCInterpersonalCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =  randomColor;
    self.title = @"人际圈";
    
 

}
-(void)uploadaaaaa{
       
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
