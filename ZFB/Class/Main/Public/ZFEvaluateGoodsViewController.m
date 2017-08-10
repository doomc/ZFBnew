//
//  ZFEvaluateGoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFEvaluateGoodsViewController.h"
#import "TggStarEvaluationView.h"

@interface ZFEvaluateGoodsViewController ()

@property (weak, nonatomic) IBOutlet TggStarEvaluationView *goodsAppraiseView;
@property (weak, nonatomic) IBOutlet TggStarEvaluationView *sendSpeedAppraiseView;
@property (weak, nonatomic) IBOutlet TggStarEvaluationView *serviceAppraiseView;

@property (weak, nonatomic) IBOutlet UILabel *lb_goodsScore;
@property (weak, nonatomic) IBOutlet UILabel *lb_sendSpeedScore;
@property (weak, nonatomic) IBOutlet UILabel *lb_serviceScore;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation ZFEvaluateGoodsViewController

- (IBAction)commitAction:(id)sender {
    
    //提交
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.commitBtn.layer.cornerRadius = 4;
    self.commitBtn.clipsToBounds = YES;
    
    [self starViewInit];
}
-(void)starViewInit
{
    weakSelf(weakSelf);
     _goodsAppraiseView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
        
         weakSelf.lb_goodsScore.text = [NSString stringWithFormat:@"%ld分",count];
         
     }];


    _sendSpeedAppraiseView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
        
    
        weakSelf.lb_sendSpeedScore.text = [NSString stringWithFormat:@"%ld分",count];
    }];
   
    _serviceAppraiseView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
        
        NSLog(@"\n\n给了铁哥哥：%ld星好评！！!\n\n",count);
        weakSelf.lb_sendSpeedScore.text = [NSString stringWithFormat:@"%ld分",count];
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
