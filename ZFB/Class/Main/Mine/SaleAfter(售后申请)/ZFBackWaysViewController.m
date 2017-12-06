//
//  ZFBackWaysViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFBackWaysViewController.h"
#import "ZFAllOrderViewController.h"

@interface ZFBackWaysViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf_contactName;
@property (weak, nonatomic) IBOutlet UITextField *tf_contactPhone;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end
@implementation ZFBackWaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets= YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self setupUI];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tf_contactPhone.text = _postPhone;
    self.tf_contactName.text = _postName;
}

-(void)setupUI{
    self.title =@"商品退回方式";

    self.commitBtn.clipsToBounds = YES;
    self.commitBtn.layer.cornerRadius = 4;
    
    self.tf_contactName.delegate= self;
    self.tf_contactPhone.delegate = self;
    
    [self.tf_contactName addTarget:self action:@selector(textFieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
    [self.tf_contactPhone addTarget:self action:@selector(textFieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
    
 
    
}
#pragma mark - UITextFieldDelegate
-(void)textFieldChangeValue:(UITextField * )textfield
{
    if (_tf_contactName == textfield) {
        NSLog(@"%@",textfield.text);
    }
    if (_tf_contactPhone == textfield) {
        NSLog(@"%@",textfield.text);

    }
}

///提交所有信息
- (IBAction)didClickcommitAction:(id)sender {
    
    if ([_tf_contactName.text isMobileNumberClassification]) {
        
    }
    [self commitPostRequsetWithParam];
    
    if (_imgArr == nil ) {
        _imgArr = @"";
    }
    
}

#pragma mark - 服务名称 -----提交售后申请 zfb/InterfaceServlet/afterSale/afterSaleApply
-(void)commitPostRequsetWithParam
{
    
    [SVProgressHUD showWithStatus:@"正在上传"];
    NSDictionary * param = @{
                             @"orderId":_orderId,
                             @"orderNum":_orderNum,
                             @"goodsId":_goodsId,
                             @"goodsName":_goodsName,
                             @"serviceType":_serviceType,
                             @"coverImgUrl":_coverImgUrl,
                             @"price":_price,
                             @"goodsCount":_goodCount,
                             @"reason":_reason,
                             @"storeId":_storeId,
                             @"orderTime":_orderTime,
                             @"problemDescr":_problemDescr,
                             @"pic1":_imgArr,
                             @"storeName":_storeName,
                             @"userId":BBUserDefault.cmUserId,
                             @"userName":self.tf_contactName.text ,
                             @"userPhone":self.tf_contactPhone.text ,
                             @"skuId":_skuId,
                             @"orderGoodsId":_orderGoodsId,
                             @"refundType":@"0",//退款方式暂时默认0 可能会改东
                             
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/afterSale/afterSaleApply"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            [SVProgressHUD showSuccessWithStatus:response[@"resultMsg"]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
                [self poptoUIViewControllerNibName:@"ZFAllOrderViewController" AndObjectIndex:1];
                ZFAllOrderViewController * vc = [ZFAllOrderViewController new];
                vc.orderType = OrderTypeAfterSale;
            });
        }else{
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            [SVProgressHUD dismiss];

        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
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
