//
//  MineShareDetailViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "MineShareDetailViewController.h"
#import "SDCycleScrollView.h"

@interface MineShareDetailViewController () <SDCycleScrollViewDelegate>

@property (strong, nonatomic)  UIButton * edit_btn;

@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleView;

@end

@implementation MineShareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的共享";

    [self sd_HeadScrollViewInit];
}

-(void)sd_HeadScrollViewInit
{
    _cycleView.imageURLStringsGroup = @[@"placeholder"];
    _cycleView.pageControlAliment   = SDCycleScrollViewPageContolAlimentCenter;
    _cycleView.delegate             = self;
    
    //自定义dot 大小和图案
    _cycleView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
    _cycleView.pageDotImage        = [UIImage imageNamed:@"dot_selected"];
    _cycleView.currentPageDotColor = [UIColor whiteColor];// 自定义分页控件小圆标颜色
    _cycleView.placeholderImage    = [UIImage imageNamed:@"placeholder"];
    
}

#pragma mark - SDCycleScrollViewDelegate 轮播图代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    //  [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}

//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    NSString * saveStr = @"审核中";
    _edit_btn = [[UIButton alloc]init];
    [_edit_btn setTitle:saveStr forState:UIControlStateNormal];
    _edit_btn.titleLabel.font=SYSTEMFONT(14);
    [_edit_btn setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
    _edit_btn.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width = size.width ;
    _edit_btn.frame =CGRectMake(0, 0, width+10, 22);
    return _edit_btn;
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
