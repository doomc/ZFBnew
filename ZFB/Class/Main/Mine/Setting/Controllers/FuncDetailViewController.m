//
//  FuncDetailViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FuncDetailViewController.h"

@interface FuncDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;

@end

@implementation FuncDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"更新内容";
    self.lb_content.preferredMaxLayoutWidth = KScreenW - 30;
    self.lb_content.text = _content;
    self.lb_title.text = _theme;
    self.lb_date.text = _date;

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
