//
//  ZFApplyBackgoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFApplyBackgoodsViewController.h"
//vc
#import "ZFBackWaysViewController.h"//确认退回的信息VC
//view
#import "SalesAfterPopView.h"//弹框选择退货原因
#import "PlaceholderTextView.h"

@interface ZFApplyBackgoodsViewController ()<SalesAfterPopViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *img_view;//商品图片
@property (weak, nonatomic) IBOutlet UILabel *lb_title;//商品名字
@property (weak, nonatomic) IBOutlet UILabel *lb_goosPrice;//价格
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsCount;//商品数量

@property (weak, nonatomic) IBOutlet UILabel *lb_goodsReturn;//退货
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsReturnMoney;//返回原退款

@property (weak, nonatomic) IBOutlet UILabel *lb_chooseResult;//请选择结果
@property (weak, nonatomic) IBOutlet UIView * textBgView;//描述
@property (weak, nonatomic) IBOutlet UIButton *didClickNextPage;//下一页

@property (strong , nonatomic) SalesAfterPopView *selectReasonView;//选择原因
@property (strong , nonatomic) UIView *popBackGView;//背景图
@property (strong , nonatomic) PlaceholderTextView *textView;


@end

@implementation ZFApplyBackgoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initGoodsData];
    [self InitPlaceholderTextView];
}

-(SalesAfterPopView *)selectReasonView
{
    if (!_selectReasonView) {
        _selectReasonView = [[SalesAfterPopView alloc]initWithFrame:CGRectMake(20, 0, KScreenW - 40, 44 * 6 +40)];
        _selectReasonView.center = self.view.center;
        _selectReasonView.delegate = self;
    }
    return  _selectReasonView;
}

-(UIView *)popBackGView
{
    if (!_popBackGView) {
        _popBackGView = [[UIView alloc]initWithFrame:self.view.bounds];
        _popBackGView.backgroundColor = RGBA(0, 0, 0, 0.2);
        [_popBackGView addSubview:self.selectReasonView];
    }
    return _popBackGView;
}

-(void)InitPlaceholderTextView
{
    _textView = [[PlaceholderTextView alloc]init];
    _textView.frame = self.textBgView.bounds;
    _textView.placeholderLabel.font = [UIFont systemFontOfSize:14];
    _textView.placeholder = @"请输入文字...";
    _textView.maxLength = 200;
    _textView.font = [UIFont systemFontOfSize:14];
    [self.textBgView  addSubview:_textView];
    
    [_textView didChangeText:^(PlaceholderTextView *textView) {
        NSLog(@"%@",textView.text);
    }];
    

}
//初始化商品数据
-(void)initGoodsData
{
    self.title = @"申请退货";
    self.mainScrollView.delegate = self;
    
    self.lb_title.text = _goodsName;
    self.lb_goosPrice.text = _price;
    self.lb_goodsCount.text = _goodCount;
    [self.img_view sd_setImageWithURL:[NSURL URLWithString:_img_urlStr] placeholderImage:[UIImage imageNamed:@""]];
  
    self.img_view.clipsToBounds = YES;
    self.img_view.layer.cornerRadius = 2;
    self.img_view.layer.borderWidth = 0.5;
    self.img_view.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    
    self.didClickNextPage.clipsToBounds = YES;
    self.didClickNextPage.layer.cornerRadius = 4;

    self.lb_goodsReturnMoney.clipsToBounds= YES;
    self.lb_goodsReturnMoney.layer.cornerRadius = 2;
    self.lb_goodsReturnMoney.layer.borderWidth = 1;
    self.lb_goodsReturnMoney.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor;
    
    self.lb_goodsReturn.clipsToBounds= YES;
    self.lb_goodsReturn.layer.cornerRadius = 2;
    self.lb_goodsReturn.layer.borderWidth = 1;
    self.lb_goodsReturn.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor;
}

/**
 下一步
 @param sender 提交申请
 */
- (IBAction)didClickNextPage:(id)sender {
    
    ZFBackWaysViewController *bcVC =[[ ZFBackWaysViewController alloc]init];
    [self.navigationController pushViewController: bcVC animated:YES];
}

/**
 申请原因
 @param sender 选择列表
 */
- (IBAction)didClickChooseReason:(id)sender {
    
    [self.view addSubview:self.popBackGView];
    
}
#pragma mark -  SalesAfterPopViewDelegate 选择原因
//移除popView
-(void)deletePopView
{
    [self.popBackGView removeFromSuperview];
}
-(void)getReasonString:(NSString *)reason{
    
    NSLog(@"%@",reason);
    self.lb_chooseResult.text = reason;
    [self.popBackGView removeFromSuperview];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"取消隐藏");
    [self setEditing:YES];
    [self.popBackGView removeFromSuperview];
//    [_textView resignFirstResponder];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
