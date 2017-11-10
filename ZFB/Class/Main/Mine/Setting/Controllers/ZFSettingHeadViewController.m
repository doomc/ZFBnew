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
#import "ZFAddressListViewController.h"

#import "ZZYPhotoHelper.h"
#import "UICustomDatePicker.h"


static NSString * settingheadid = @"ZFSettingHeaderCellid";
static NSString * settingRowid = @"ZFSettingRowCellid";


@interface ZFSettingHeadViewController ()<UITableViewDelegate,UITableViewDataSource,ZFSettingRowCellDelegate>
{
    NSArray * _titleArr;
    BOOL _isSavedNickName;//yes 已经保存过了 NO反之
    BOOL _isSavedBirthDay;//yes 已经保存过了 NO反之

    NSString  * _nickName;
    NSString  * _imagePath;//图片路径

}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray *sexTitleArr;

@property (nonatomic, strong) NSDate *selectedDate; //代表dateButton上显示的时间。

@end

@implementation ZFSettingHeadViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人资料";    

    _titleArr  = @[@"昵称",@"性别",@"生日",@"地址管理"];
    _sexTitleArr = @[@"男",@"女"];

    BBUserDefault.sexType  = 3;//默认
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFSettingHeaderCell" bundle:nil] forCellReuseIdentifier:settingheadid];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFSettingRowCell" bundle:nil] forCellReuseIdentifier:settingRowid];
    [self.view addSubview:self.tableView];
 
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH ) style:UITableViewStylePlain];
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
    [right_button setTitleColor:HEXCOLOR(0xf95a70)  forState:UIControlStateNormal];
    right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width = size.width ;
    right_button.frame =CGRectMake(0, 0, width+10, 22);
    
    return right_button;
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
    if (indexPath.section == 0) {
        return  70;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if (indexPath.section == 0) {
 
        ZFSettingHeaderCell * headCell = [self.tableView dequeueReusableCellWithIdentifier:settingheadid forIndexPath:indexPath];
        headCell.lb_title.text =@"头像";
        NSURL *imgURL = [NSURL URLWithString:_userImgAttachUrl];
        [headCell.img_headView sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"head"]];
        cell =  headCell;

    }
    if (indexPath.section == 1 ) {
     
        ZFSettingRowCell * rowCell = [self.tableView dequeueReusableCellWithIdentifier:settingRowid forIndexPath:indexPath];
        rowCell.delegate = self;

        if (indexPath.row == 0) {
            rowCell.isEdited = YES;//_isSavedNickName;
            rowCell.tf_contentTextfiled.enabled = NO;
            if (_nickName.length > 0) { //如果当前输入有值
                rowCell.tf_contentTextfiled.text = _nickName;

            }else{
                rowCell.tf_contentTextfiled.text = BBUserDefault.nickName;
            }
     
        }
        else if (indexPath.row == 1) {
            rowCell.tf_contentTextfiled.hidden = YES;
            if (BBUserDefault.sexType == 1) {
                rowCell.lb_detailTitle.text= @"男";

            }
            if (BBUserDefault.sexType == 2) {
                rowCell.lb_detailTitle.text= @"女";
  
            }
            if (BBUserDefault.sexType == 3) {
                rowCell.lb_detailTitle.text= @"保密";
            }
        }
        else if (indexPath.row == 2) {
            rowCell.tf_contentTextfiled.hidden = YES;
            
            if (_isSavedBirthDay == NO) {
                if ([BBUserDefault.birthDay isEqualToString:@""] || BBUserDefault.birthDay == nil) {
                  
                    rowCell.lb_detailTitle.text  = nil;
                
                }else{
                    rowCell.lb_detailTitle.text = BBUserDefault.birthDay;
                }
            
            }else{
                
                rowCell.lb_detailTitle.text = nil;
            }

        }
        else if (indexPath.row == 3){
            rowCell.tf_contentTextfiled.hidden = YES;
            rowCell.lb_detailTitle.hidden = YES;

        }
        rowCell.lb_title.text = _titleArr[indexPath.row];
        cell = rowCell;
        
    }
    return cell;
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sectin = %ld,row = %ld",indexPath.section ,indexPath.row);
    ZFSettingRowCell *rowCell =(ZFSettingRowCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        ZFSettingHeaderCell *cell = (ZFSettingHeaderCell *)[tableView cellForRowAtIndexPath:indexPath];
        [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data, NSString *imgPath) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
              
                cell.img_headView.image = (UIImage *)data;
                _imagePath = imgPath;
                _userImgAttachUrl =  [NSString stringWithFormat:@"%@",imgPath ];
            });
            NSLog(@" 222222222 _userImgAttachUrl = = = = %@  ", imgPath );
        }];
 
    }
    if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            JXTAlertController * alertVC  =[ JXTAlertController alertControllerWithTitle:@"编辑昵称" message:nil preferredStyle:UIAlertControllerStyleAlert ];
            
            [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                [textField addTarget:self action:@selector(changeNickName:) forControlEvents:UIControlEventEditingChanged];
                 textField.placeholder = @"编辑昵称";
            }];
            UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.tableView reloadData];
            }];
            [alertVC addAction: cancel];
            [alertVC addAction: sure];

            [self presentViewController:alertVC animated:YES completion:nil];

            
        }
        else if (indexPath.row == 1) {
            
            JXTAlertController * alertSheet  =[[ JXTAlertController alloc]init];
            UIAlertAction  * alertSeet1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                rowCell.lb_detailTitle.text = @"男";
                BBUserDefault.sexType  = 1;
            }];
            UIAlertAction  * alertSeet2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                rowCell.lb_detailTitle.text   = @"女";
                BBUserDefault.sexType  = 2;

            }];
            UIAlertAction  * alertSeet3 = [UIAlertAction actionWithTitle:@"保密" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                rowCell.lb_detailTitle.text  = @"保密";
                BBUserDefault.sexType  = 3;
            }];
            
            [alertSheet addAction:alertSeet1];
            [alertSheet addAction:alertSeet2];
            [alertSheet addAction:alertSeet3];
            [self presentViewController:alertSheet animated:YES completion:nil];
      
        } else if (indexPath.row == 2) {
            if (_isSavedBirthDay == YES) {
                
                [UICustomDatePicker showCustomDatePickerAtView:self.view choosedDateBlock:^(NSDate *date) {
                  
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSString * dataStr =[dateFormatter stringFromDate:date];
                    rowCell.lb_detailTitle.text = BBUserDefault.birthDay = dataStr;
                    NSLog(@"current Date:%@",dataStr);
    
                } cancelBlock:^{
                    
                }];

            }else{
                
                JXTAlertController *alertVC = [JXTAlertController alertControllerWithTitle:nil message:@"你已经修改过生日信息，不能二次修改了" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * sure = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertVC addAction: sure];
                [self presentViewController:alertVC animated:NO completion:^{
                }];

                NSLog(@"不做操作");
            }
         
        }
        else if (indexPath.row == 3)
        {
            //收货地址
            ZFAddressListViewController  * addVC = [[ZFAddressListViewController alloc]init];

            [self.navigationController pushViewController:addVC animated:YES];
            
        }
 
    }
}

//保存事件
-(void)right_button_event:(UIButton*)sender{
    
    NSLog(@"保存");
    
    if ( (BBUserDefault.birthDay == nil || [BBUserDefault.birthDay isEqualToString:@""] )|| (BBUserDefault.nickName == nil  && [BBUserDefault.nickName isEqualToString:@""])) {
        
        JXTAlertController *alertVC = [JXTAlertController alertControllerWithTitle:nil message:@"请填写完个人信息后再保存" preferredStyle:UIAlertControllerStyleAlert];
       
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"知道了 " style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction: sure];
        [self presentViewController:alertVC animated:NO completion:^{
        }];
        
    }else{
        [self getUserInfoUpdate];
    }
}

#pragma mark  -  ZFSettingRowCellDelegate
-(void)changeNickName:(UITextField  *)textField
{
    _nickName = textField.text;
    
}
#pragma mark -  保存用户信息getUserInfoUpdate  //1. 男 2.女 3保密
-(void)getUserInfoUpdate
{
    NSDictionary * param = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"nickName":_nickName,
                             @"sex":[NSString stringWithFormat:@"%ld",BBUserDefault.sexType],
                             @"cmBirthday":BBUserDefault.birthDay,
                             @"userImgAttachUrl": _imagePath,
                             
                             };
    [SVProgressHUD showWithStatus:@"正在上传..."];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getUserInfoUpdate",zfb_baseUrl] params:param success:^(id response) {
        if ([response[@"resultCode"] intValue] == 0) {
            
            //保存成功后不可以修改
            _isSavedBirthDay = NO;
            [SVProgressHUD showSuccessWithStatus:response[@"resultMsg"]];
        }

        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        NSLog(@"error=====%@",error);
    }];
    
}
 
-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];

    if (BBUserDefault.birthDay == nil || [BBUserDefault.birthDay isEqualToString:@""]) {
        _isSavedBirthDay = YES;//可编辑状态
    }
    else{
        _isSavedBirthDay = NO;
    }
    
    [self.tableView reloadData];
}

@end
