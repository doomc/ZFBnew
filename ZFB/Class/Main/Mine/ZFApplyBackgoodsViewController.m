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

@interface ZFApplyBackgoodsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *img_view;//商品图片
@property (weak, nonatomic) IBOutlet UILabel *lb_title;//商品名字
@property (weak, nonatomic) IBOutlet UILabel *lb_goosPrice;//价格
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsCount;//商品数量

@property (weak, nonatomic) IBOutlet UILabel *lb_goodsReturn;//退货
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsReturnMoney;//返回原退款

@property (weak, nonatomic) IBOutlet UILabel *lb_chooseResult;//请选择结果
@property (weak, nonatomic) IBOutlet UITextView *tv_descirption;//描述
@property (weak, nonatomic) IBOutlet UIButton *didClickNextPage;//下一页

@end

@implementation ZFApplyBackgoodsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initGoodsData];

}
//初始化商品数据
-(void)initGoodsData
{
    self.title = @"申请退货";
    
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
