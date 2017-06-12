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
#import "ZFSettingAddressViewController.h"

#import "ZZYPhotoHelper.h"
#import "PTXDatePickerView.h"
#import "ACAlertController.h"

typedef NS_ENUM(NSUInteger, IndexType) {
    IndexTypeMan,
    IndexTypeWoman,
};

static NSString * settingheadid = @"ZFSettingHeaderCellid";
static NSString * settingRowid = @"ZFSettingRowCellid";


@interface ZFSettingHeadViewController ()<UITableViewDelegate,UITableViewDataSource,GGActionSheetDelegate,PTXDatePickerViewDelegate>
{
    NSArray * _titleArr;
    NSMutableArray * _imageMutableArray;
    NSString * _seletDate;//选择时间
    NSInteger _IndexType;
    BOOL _isSelectCount;
    
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) GGActionSheet *actionSheetTitle;
@property (nonatomic,strong) NSArray *sexTitleArr;
//@property (nonatomic,assign) IndexType indexType;
@property (nonatomic,strong) PTXDatePickerView *datePickerView;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFSettingHeaderCell" bundle:nil] forCellReuseIdentifier:settingheadid];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFSettingRowCell" bundle:nil] forCellReuseIdentifier:settingRowid];
    
    [self.view addSubview:self.tableView];
    _datePickerView.datePickerViewShowModel = PTXDatePickerViewShowModelYearMonthDay;

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
-(PTXDatePickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[PTXDatePickerView alloc]initWithFrame:CGRectMake(0, KScreenH, KScreenW, 246.0)];
        _datePickerView.delegate = self;
        _datePickerView.datePickerViewShowModel = PTXDatePickerViewShowModelYearMonthDay;

        [self.view addSubview:_datePickerView];
    }
    
    return _datePickerView;
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
//设置右边事件
-(void)right_button_event:(UIButton*)sender{
    NSLog(@"保存")
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
        }
        else if (indexPath.row == 1) {
            rowCell.tf_contentTextfiled.hidden = YES;

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
        [self.actionSheetTitle showGGActionSheet];
   
//        ZFSettingHeaderCell *cell = (ZFSettingHeaderCell *)[tableView cellForRowAtIndexPath:indexPath];
//        [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
// 
//            cell.img_headView.image = (UIImage *)data;
//        }];
//        
    }
    if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
        }
        else if (indexPath.row == 1) {
            
            [self createACAlertController];
            
            if (_IndexType == 0) {
                rowCell.lb_detailTitle.text = @"男";
            }
            if (_IndexType == 1) {
                rowCell.lb_detailTitle.text = @"女";
            }
            else{
                rowCell.lb_detailTitle.text = @"保密";

            }
        }
        else if (indexPath.row == 2) {
            if (_isSelectCount == NO) {
                
                [self.datePickerView  showViewWithDate:_selectedDate animation:YES];
                rowCell.lb_detailTitle.text = _seletDate;
                //_isSelectCount = YES;

            }else{
                
                NSLog(@"不做操作");
            }
         
        }
        else if (indexPath.row == 3)
        {
            ZFSettingAddressViewController *addVC = [[ZFSettingAddressViewController alloc]init];
            [self.navigationController pushViewController:addVC animated:YES];
        }
    }
   
}
#pragma mark - UIAlertController
- (void)createACAlertController {
    //1、初始化
    ACAlertController *action2 = [[ACAlertController alloc] initWithActionSheetTitles:_sexTitleArr cancelTitle:@"保密"];
    
    //2、获取点击事件
    [action2 clickActionButton:^(NSInteger index) {
        NSLog(@"选中的item = %ld", (long)index);
        _IndexType = index;
   
    }];
    
    //3、显示
    [action2 show];
}
#pragma mark - GGActionSheet代理方法
-(void)GGActionSheetClickWithActionSheet:(GGActionSheet *)actionSheet Index:(int)index{
    if (actionSheet == self.actionSheetTitle) {
        
        NSLog(@"--------->点击了第%d个按钮<----------",index);
    }
}
-(GGActionSheet *)actionSheetTitle{
    if (!_actionSheetTitle) {
        _actionSheetTitle = [GGActionSheet ActionSheetWithTitleArray:@[@"拍照",@"从相册中选择"] andTitleColorArray:@[[UIColor orangeColor]] delegate:self];
        //取消按钮颜色设置
        _actionSheetTitle.cancelDefaultColor = HEXCOLOR(0x363636);
        _actionSheetTitle.optionDefaultColor = HEXCOLOR(0x363636);
    }
    return _actionSheetTitle;
}

#pragma mark - PTXDatePickerViewDelegate
- (void)datePickerView:(PTXDatePickerView *)datePickerView didSelectDate:(NSDate *)date {

    self.selectedDate = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _seletDate =[dateFormatter stringFromDate:date];


}

@end
