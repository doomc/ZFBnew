//
//  AddBankCardViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  添加银行卡

#import "AddBankCardViewController.h"
#import "AddBankCell.h"
#import "BankMessageViewController.h"//银行卡信息
#import "SupprotBankViewController.h"//支持银行
@interface AddBankCardViewController () <UITableViewDelegate ,UITableViewDataSource,UITextFieldDelegate>
{
    BOOL _massgeEnough;//信息是否完整 yes是完整 no 不完整
    NSString * _bandCardName; //持卡人姓名
    NSString * _kcardNum; //卡号
    NSString * _realNameFlag; //实名认证
    UIButton * _edit_btn;
    UITextField * _tf_content;
    
}
@property (nonatomic ,strong) NSArray * titles;
@property (nonatomic ,strong) NSArray * placeHoder;
@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) UIButton * nextBtn;//下一步

@end

@implementation AddBankCardViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 55 *2 + 32  ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = HEXCOLOR(0xeaeaea);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加银行卡";
    _titles = @[@"持卡人",@"卡号"];
    _placeHoder = @[@"请输入有效姓名",@"无需网银/免手续费" ];
    _massgeEnough = NO; //默认NO 没有填完信息

    [self.tableView registerNib:[UINib nibWithNibName:@"AddBankCell" bundle:nil] forCellReuseIdentifier:@"AddBankCell"];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);

    [self settingButton];
    
}
-(void)settingButton
{
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = SYSTEMFONT(15);
    [_nextBtn addTarget: self action:@selector(bandNext) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.frame = CGRectMake( 15, 110+ 32+55+45, KScreenW -30, 45);
    
    [_nextBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:HEXCOLOR(0xF95A70)];
    _nextBtn.enabled = YES;
    
    [self.view addSubview:_nextBtn];

 

}
//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    NSString * saveStr = @"支持银行";
    _edit_btn          = [[UIButton alloc]init];
    [_edit_btn setTitle:saveStr forState:UIControlStateNormal];
    _edit_btn.titleLabel.font = SYSTEMFONT(14);
    [_edit_btn setTitleColor:HEXCOLOR(0x333333)  forState:UIControlStateNormal];
    _edit_btn.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size                        = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width                      = size.width ;
    _edit_btn.frame                    = CGRectMake(0, 0, width+10, 22);
    [_edit_btn addTarget:self action:@selector(supportBankAction) forControlEvents:UIControlEventTouchUpInside];
    
    return _edit_btn;
}
#pragma mark- 绑卡下一步
-(void)bandNext
{
    NSLog(@"下一步");
    if (_kcardNum.length > 0 && _kcardNum.length >0) {
     
        [self verificationNameAndCardNumPost];
//        BankMessageViewController  * nextVC  = [BankMessageViewController new];
//        [self.navigationController pushViewController:nextVC animated:NO];

    }else{
        [self.view makeToast:@"提交身份信息有误" duration:1.5 position:@"center"];
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    
    if (!view) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 32)];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, KScreenW, 12)];
        label.text = @"请绑定持卡人本人银行卡";
        label.font = SYSTEMFONT(12);
        label.textColor = HEXCOLOR(0x8d8d8d);
        [view addSubview:label];
        
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddBankCell * backCell = [self.tableView dequeueReusableCellWithIdentifier:@"AddBankCell" forIndexPath:indexPath];
    backCell.LB_title.text = _titles[indexPath.row];
    backCell.tf_content.placeholder = _placeHoder[indexPath.row];
    
    if (indexPath.row == 0) {
        [backCell.tf_content addTarget:self action:@selector(handCarText:) forControlEvents:UIControlEventEditingChanged];
        
    }else
    {
        [backCell.tf_content addTarget:self action:@selector(carNumText:) forControlEvents:UIControlEventEditingChanged];
        _tf_content =backCell.tf_content ;
        _tf_content.delegate = self;

    }
    return backCell;
    
}
//持卡人姓名
-(void)handCarText:(UITextField *)tf
{
    NSLog(@"%@ === text1",tf.text);
    _bandCardName = tf.text;

}
//卡号
-(void)carNumText:(UITextField *)tf
{
    NSLog(@"%@ === text2",tf.text);

    _kcardNum = tf.text;
    if (  _kcardNum.length > 0) {
        [_nextBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:HEXCOLOR(0xF95A70)];
        _nextBtn.enabled = YES;
    }else{
        [_nextBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:HEXCOLOR(0xe0e0e0)];
        _nextBtn.enabled = NO;

    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _tf_content) {
        // 4位分隔银行卡卡号
        NSString *text = [textField text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        if ([newString stringByReplacingOccurrencesOfString:@" " withString:@""].length >= 21) {
            return NO;
        }
        _kcardNum  = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
        [textField setText:newString];
        
        return NO;
    }
    return YES;
}


#pragma mark-  支持银行
-(void)supportBankAction
{
    SupprotBankViewController * supportVC =[ SupprotBankViewController new];
    [self.navigationController pushViewController: supportVC animated:NO];
}

#pragma mark - 验证卡号和姓名 getBankByCardNum
-(void)verificationNameAndCardNumPost
{
    NSDictionary * parma = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"bankCredNum":_kcardNum
                             };
    [SVProgressHUD showWithStatus:@"正在验证信息，请稍后"];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/QRCode/getBankByCardNum"] params:parma success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@",response [@"resultCode"]];
        if ([code isEqualToString:@"0"]) {

            [SVProgressHUD showSuccessWithStatus:@"验证成功！"];
            BankMessageViewController  * nextVC  = [BankMessageViewController new];
            nextVC.bankCredHolder = _bandCardName;//持卡人姓名
            nextVC.bankCredNum = _kcardNum ;//卡号
            nextVC.baseBankName = [NSString stringWithFormat:@"%@",response[@"bankInfo"][@"baseBankName"]];
            nextVC.bankCredType =[NSString stringWithFormat:@"%@",response[@"bankInfo"][@"bankCredType"]];
            nextVC.baseBankId = [NSString stringWithFormat:@"%@",response[@"bankInfo"][@"baseBankId"]];
            [self.navigationController pushViewController:nextVC animated:NO];
            
        }else{
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络出差了~"];
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
