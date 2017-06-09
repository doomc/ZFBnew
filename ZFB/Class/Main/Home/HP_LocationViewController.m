//
//  HP_LocationViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  首页定位

#import "HP_LocationViewController.h"
#import "SearchCell.h"

@interface HP_LocationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView * location_TableView;
@property(nonatomic,strong)UITextField * tf_search;
@property(nonatomic,strong)UIView * bgView;

@end

@implementation HP_LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self creatTableViewInterface];
    
}

-(void)creatTableViewInterface
{
    self.title = @"选择地址";

    //创建bgView
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenW,50 )];
    [self.view addSubview:_bgView];
    
    self.tf_search.clearButtonMode = UITextFieldViewModeAlways;
    self.tf_search = [[UITextField alloc]initWithFrame:CGRectMake(35, 10, KScreenW-70, 35)];
    self.tf_search.layer.borderWidth = 1;
    self.tf_search.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor;
    self.tf_search.layer.cornerRadius = 8;
    self.tf_search.textColor = HEXCOLOR(0xfe6d6a);
    _tf_search.font = [UIFont fontWithName:@"Arial" size:14.0f];
    [_bgView addSubview:_tf_search];
    
    self.tf_search.placeholder = @"请输入要搜索的地址";
    self.tf_search.delegate = self;

    
    //tableView的创建
    self.location_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, KScreenW, KScreenH-64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.location_TableView];

    self.location_TableView.dataSource = self;
    self.location_TableView.delegate = self;

    [self.location_TableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SearchCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 3;
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if (section==1) {
        
        UIView * bgview =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
        bgview.backgroundColor =HEXCOLOR(0xffcccc);
        
        UILabel * _lb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW, 40)];
        _lb.textColor = HEXCOLOR(0x363636);
        _lb.text = @"附近地址";
        _lb.font = [UIFont systemFontOfSize:15.0];
        [bgview addSubview:_lb];
        
        return bgview;
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    UITableViewCell * customCell = [self.location_TableView dequeueReusableCellWithIdentifier:@"cell"];
 
    if (indexPath.section == 0) {
        
        SearchCell * searchCell = [self.location_TableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
        return searchCell;
    }
    if (indexPath.section == 1 ) {
      
        if (!customCell) {
            customCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        customCell.textLabel.font =[ UIFont systemFontOfSize:12];
        customCell.textLabel.textColor = HEXCOLOR(0x363636);
        customCell.textLabel.text = @"水晶国际";

        return customCell;

    }
    return nil;
    
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
