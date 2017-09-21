//
//  ZFEvaluateGoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  新评价晒单（单个商品）


#import "ZFEvaluateGoodsViewController.h"
#import "ZFServiceEvaluteCell.h"
#import "ZFEvaluateGoodsCell.h"

@interface ZFEvaluateGoodsViewController () <UITableViewDelegate,UITableViewDataSource ,ZFEvaluateGoodsCellDelegate,ZFServiceEvaluteCellDelegate>
{
    CGFloat _cellHeight;
    NSString * _textViewValues;
    NSString * _imgComment;//是否有图评论  1.有图评论 0.无图评论
    NSString * _deviceName;//设备名称
    BOOL _isCommited;
}
@property (nonatomic,strong) UITableView * tableview;
@property (nonatomic,strong) NSArray     * upImgArray;

@end

@implementation ZFEvaluateGoodsViewController

-(UITableView *)tableview
{
    if (!_tableview ) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    self.title = @"晒单";

    _imgComment = @"0"; //默认评论没有图片
    _isCommited = NO;//默认没有提交
    UIDevice *currentDevice = [UIDevice currentDevice];
    _deviceName = currentDevice.name;    //设备名称
    [self.view addSubview:self.tableview];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"ZFServiceEvaluteCell" bundle:nil] forCellReuseIdentifier:@"ZFServiceEvaluteCell"];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"ZFEvaluateGoodsCell" bundle:nil] forCellReuseIdentifier:@"ZFEvaluateGoodsCell"];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_upImgArray.count > 0) {
            return _cellHeight + 240 + 50 ;
        }
        return 113 + 240 + 50;
    }else{
        return 210 ;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        ZFEvaluateGoodsCell * goodsCell = [self.tableview dequeueReusableCellWithIdentifier:@"ZFEvaluateGoodsCell" forIndexPath:indexPath];
        

        goodsCell.delegate = self;
        return goodsCell;
        
    }else{
        
        ZFServiceEvaluteCell * serviceCell = [self.tableview dequeueReusableCellWithIdentifier:@"ZFServiceEvaluteCell" forIndexPath:indexPath];
        
        serviceCell.delegate = self;
        return serviceCell;
        
    
    }
}

#pragma mark - ZFEvaluateGoodsCellDelegate
//传入选择的图片
-(void)uploadImageArray:(NSArray *)uploadArr
{
    _upImgArray = uploadArr;
 
    if (_upImgArray.count > 0) {
        _imgComment = @"1";
    }
    [self.tableview reloadData];
    
 
}
//刷新高度
-(void)reloadCellHeight:(CGFloat)cellHeight
{
    _cellHeight = cellHeight;
    
}
//获取textview的内容
-(void)getTextViewValues:(NSString *)textViewValues
{
    NSLog(@" 外部的 %@",textViewValues);
    _textViewValues = textViewValues;
}
#pragma mark - ZFServiceEvaluteCellDelegate
//提交
-(void)didClickCommit
{
    if (_isCommited == YES) {//如果还没有提交
        return;
    }
    _isCommited = YES;

    [SVProgressHUD show];
    [OSSImageUploader asyncUploadImages:_upImgArray complete:^(NSArray<NSString *> *names, UploadImageState state) {
        if (state == 1) {
            NSLog(@"点击提交了 _images = %@",names);
            NSMutableArray * reviewsJsonArr = [NSMutableArray array];
            NSMutableDictionary * jsondic =[NSMutableDictionary dictionary];
            NSString * imgUrlString = [names componentsJoinedByString:@","];
            
            [jsondic setValue:@"5" forKey:@"goodsComment"];//评分评级得分 1到5分
            [jsondic setValue:_textViewValues forKey:@"reviewsText"];
            [jsondic setValue:imgUrlString forKey:@"reviewsImgUrl"];
            [jsondic setValue:_imgComment forKey:@"imgComment"];
            [jsondic setValue:_goodId forKey:@"goodsId"];
            [reviewsJsonArr addObject:jsondic];
            
            if ([_textViewValues isEqualToString:@""] || _textViewValues == nil) {
              
                [self.view makeToast:@"请填写完评价信息后再提交" duration:2 position:@"center"];
 
            }else{
                [self insertGoodsCommentPost:[NSArray arrayWithArray:reviewsJsonArr]];
            }
        }
    }];

    
}

#pragma mark  - insertGoodsComment 晒单的接口
-(void)insertGoodsCommentPost:(NSArray*)reviewsJson
{

    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"equip":_deviceName,//获取手机
                             @"imgComment":_imgComment,
                             @"reviewsJson":reviewsJson,//集合
                             @"serAttitude":@"4",//服务态度(最高五星)
                             @"deliverySpeed":@"4",//送货速度
                             @"storeName":_storeName,
                             @"orderId":_orderId,
                             @"storeId":_storeId,
                             @"orderNum":_orderNum,
                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/insertGoodsComment"] params:parma success:^(id response) {
        
        if ([response [@"resultCode"] isEqualToString:@"0"]) {
          
            [SVProgressHUD dismiss];
            _isCommited = NO;//提交成功后返回默认

            JXTAlertController * alertvc = [JXTAlertController alertControllerWithTitle:@"评价成功,马上返回？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * sure = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self backAction];
            }];
            UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertvc addAction:sure];
            [alertvc addAction:cancle];
            [self presentViewController:alertvc animated:YES completion:^{
                
            }];
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
