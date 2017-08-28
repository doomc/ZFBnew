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
    BOOL _isSelectCount;

    NSString  * _nickName;
    NSInteger   _sex;//1. 男 2.女 3保密
    NSString  * _cmBirthday;
    NSString  * _userImgAttachUrl;

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
    _isSelectCount = NO;//默认选择一次
    _sex = 3;//默认
    
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
        headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        headCell.lb_title.text =@"头像";
        cell =  headCell;

    }if (indexPath.section == 1 ) {
     
        ZFSettingRowCell * rowCell = [self.tableView dequeueReusableCellWithIdentifier:settingRowid forIndexPath:indexPath];

        if (indexPath.row == 0) {
            rowCell.lb_detailTitle.hidden = YES;
            rowCell.tf_contentTextfiled.placeholder = @"请输入昵称,该昵称填写后不可修改";
            rowCell.delegate = self;
            rowCell.isSaved = _isSelectCount;
     
        }
        else if (indexPath.row == 1) {
            rowCell.tf_contentTextfiled.hidden = YES;
            if (_sex == 1) {
                rowCell.lb_detailTitle.text= @"男";

            }
            if (_sex == 2) {
                rowCell.lb_detailTitle.text= @"女";
  
            }
            if (_sex == 3) {
                rowCell.lb_detailTitle.text= @"保密";
            }
        }
        else if (indexPath.row == 2) {
            rowCell.tf_contentTextfiled.hidden = YES;

        }
        else if (indexPath.row == 3){
            rowCell.tf_contentTextfiled.hidden = YES;
            rowCell.lb_detailTitle.hidden = YES;

        }
        rowCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
 
            cell.img_headView.image = (UIImage *)data;
            _userImgAttachUrl = [ZZYPhotoHelper shareHelper].imgName;
            NSLog(@"[ZZYPhotoHelper shareHelper].imgName = = %@",[ZZYPhotoHelper shareHelper].imgName);
        }];
 
    }
    if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            
        }
        else if (indexPath.row == 1) {
            
            JXTAlertController * alertSheet  =[[ JXTAlertController alloc]init];
            UIAlertAction  * alertSeet1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                rowCell.lb_detailTitle.text = @"男";
                _sex = 1;
            }];
            UIAlertAction  * alertSeet2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                rowCell.lb_detailTitle.text   = @"女";
                _sex = 2;

            }];
            UIAlertAction  * alertSeet3 = [UIAlertAction actionWithTitle:@"保密" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                rowCell.lb_detailTitle.text  = @"保密";
                _sex = 3;
            }];
            
            [alertSheet addAction:alertSeet1];
            [alertSheet addAction:alertSeet2];
            [alertSheet addAction:alertSeet3];
            [self presentViewController:alertSheet animated:YES completion:nil];
            
      
        } else if (indexPath.row == 2) {
            if (_isSelectCount == NO) {
                
                [UICustomDatePicker showCustomDatePickerAtView:self.view choosedDateBlock:^(NSDate *date) {
                  
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSString * dataStr =[dateFormatter stringFromDate:date];
                    rowCell.lb_detailTitle.text = _cmBirthday = dataStr;
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
        
        [self.tableView reloadData];
        
    }
}

//保存事件
-(void)right_button_event:(UIButton*)sender{
    
    NSLog(@"保存");
    
    if ([ZZYPhotoHelper shareHelper].imgName == nil || _nickName == nil || _cmBirthday == nil) {
        
        JXTAlertController *alertVC = [JXTAlertController alertControllerWithTitle:nil message:@"个人信息还没填写完" preferredStyle:UIAlertControllerStyleAlert];
       
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
                             @"nickName":_nickName,
                             @"sex":[NSString stringWithFormat:@"%ld",_sex],
                             @"cmBirthday":_cmBirthday,
                             @"userImgAttachUrl":[ZZYPhotoHelper shareHelper].imgName,
                             
                             };
    [SVProgressHUD show];
   
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getUserInfoUpdate",zfb_baseUrl] params:param success:^(id response) {
        if ([response[@"resultCode"] intValue] == 0) {
            
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            //保存成功后不可以修改
            _isSelectCount = YES;  //Yes 默认为只能执行一次
 
        }
        [SVProgressHUD dismiss];
 
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
    }];
    
}

@end
