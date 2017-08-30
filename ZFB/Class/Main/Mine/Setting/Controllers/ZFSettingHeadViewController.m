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

    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFSettingHeaderCell" bundle:nil] forCellReuseIdentifier:settingheadid];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFSettingRowCell" bundle:nil] forCellReuseIdentifier:settingRowid];
    
    [self.view addSubview:self.tableView];
 
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

    }if (indexPath.section == 1 ) {
     
        ZFSettingRowCell * rowCell = [self.tableView dequeueReusableCellWithIdentifier:settingRowid forIndexPath:indexPath];

        if (indexPath.row == 0) {
            
            rowCell.isEdited = _isSavedNickName;
            if (_isSavedNickName == YES) {
         
                rowCell.lb_detailTitle.hidden = YES;
                rowCell.tf_contentTextfiled.placeholder = @"请输入昵称,该昵称填写后不可修改";
                rowCell.delegate = self;

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
            
                rowCell.lb_detailTitle.text= BBUserDefault.birthDay;
            
            }else{
                
                rowCell.lb_detailTitle.text = @"";
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
           
            cell.img_headView.image = (UIImage *)data;
            _imagePath = imgPath;
            _userImgAttachUrl =  [NSString stringWithFormat:@"%@%@",aliOSS_baseUrl,imgPath ];
            NSLog(@" 222222222 _userImgAttachUrl = = = = %@  ", imgPath );

        }];
 
    }
    if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
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
                
                NSLog(@"不做操作");
            }
         
        }
        else if (indexPath.row == 3)
        {
            //收货地址
            ZFAddressListViewController  * addVC = [[ZFAddressListViewController alloc]init];
            [self.navigationController pushViewController:addVC animated:YES];
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

    }
}

//保存事件
-(void)right_button_event:(UIButton*)sender{
    
    NSLog(@"保存");
    
    if ( _imagePath == nil || BBUserDefault.birthDay == nil || BBUserDefault.nickName == nil) {
        
        JXTAlertController *alertVC = [JXTAlertController alertControllerWithTitle:nil message:@"请填写完个人信息后再保存" preferredStyle:UIAlertControllerStyleAlert];
       
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"知道了 " style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction: sure];
        
        [self presentViewController:alertVC animated:NO completion:^{
            
        }];
        
    }else
    {
        [self getUserInfoUpdate];
 
    }
}

#pragma mark  -  ZFSettingRowCellDelegate 
-(void)getNickName:(NSString *)nickName
{
    _nickName = nickName;
}
#pragma mark -  保存用户信息getUserInfoUpdate  //1. 男 2.女 3保密
-(void)getUserInfoUpdate
{
    NSDictionary * param = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"nickName":BBUserDefault.nickName,
                             @"sex":[NSString stringWithFormat:@"%ld",BBUserDefault.sexType],
                             @"cmBirthday":BBUserDefault.birthDay,
                             @"userImgAttachUrl": _imagePath,
                             
                             };
    [SVProgressHUD showWithStatus:@"正在上传..."];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getUserInfoUpdate",zfb_baseUrl] params:param success:^(id response) {
        if ([response[@"resultCode"] intValue] == 0) {
            
            //保存成功后不可以修改
            _isSavedBirthDay = NO;
            _isSavedNickName = NO;
            
            [SVProgressHUD dismiss];
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }

        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
    }];
    
}
 
-(void)viewWillAppear:(BOOL)animated
{
      BBUserDefault.sexType  = 3;//默认
    
    if (BBUserDefault.nickName == nil) {
        
        _isSavedNickName = YES; //如果nickname不存在说明没有编辑过 YES == 可编辑 NO 非
    }else{
        
        _isSavedNickName =  NO;

    }
    if (BBUserDefault.birthDay == nil) {
        _isSavedBirthDay = YES;//可编辑状态
    }
    else{
        _isSavedBirthDay = NO;
    }
    
    [self.tableView reloadData];
}

@end
