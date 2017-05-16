//
//  ZFPersonalViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//   **** 我的 

#import "ZFPersonalViewController.h"

#import "ZFMyCashBagCell.h"
#import "ZFMyProgressCell.h"
#import "ZFMyOderCell.h"
#import "ZFHeaderView.h"
typedef NS_ENUM(NSUInteger, TypeCell) {
    TypeCellOfMyCashBagCell,
    TypeCellOfMyProgressCell,
    TypeCellOfMyOderCell,

    
};
@interface ZFPersonalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)UIView * myHeaderView;

@end

@implementation ZFPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =  randomColor;
    
    [self initmyTableViewInterface];
}

-(void)initmyTableViewInterface
{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
   
    UIView * headerView =  [[NSBundle mainBundle]loadNibNamed:@"ZFHeaderView" owner:self options:nil].lastObject;

    self.myTableView.tableHeaderView =headerView;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZFMyCashBagCell" bundle:nil] forCellReuseIdentifier:@"ZFMyCashBagCell"];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZFMyProgressCell" bundle:nil] forCellReuseIdentifier:@"ZFMyProgressCell"];
  
    [self.myTableView registerNib:[UINib nibWithNibName:@"ZFMyOderCell" bundle:nil] forCellReuseIdentifier:@"ZFMyOderCell"];
  
}


#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  

    if( section == 1 ){
        return 3;
    }
    
    return  1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row ==0) {
        
        return 120;
        
    }
    else if (indexPath.section == 1 && indexPath.row ==0 ) {
        
        return 120;
        
    }else{
      
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        ZFMyCashBagCell  * cashCell = [ self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyCashBagCell" forIndexPath:indexPath];

            return cashCell;

        }
    
    else if (indexPath.section == 1 && indexPath.row == 0) {
        ZFMyProgressCell * pressCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyProgressCell" forIndexPath:indexPath];

            return pressCell;
            
        }
   
    else {
        ZFMyOderCell * orderCell = [self.myTableView dequeueReusableCellWithIdentifier:@"ZFMyOderCell" forIndexPath:indexPath];
       
        return orderCell;
    }
   
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
