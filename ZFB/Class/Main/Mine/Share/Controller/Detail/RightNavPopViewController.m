//
//  RightNavPopViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
// 时间选择器

#import "RightNavPopViewController.h"
#import "XLSlideMenu.h"
#import "SelectTimeCollectionCell.h"

@interface RightNavPopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong)  UICollectionView * collectionView;
@property (nonatomic , strong)  NSArray * titles;
@property (nonatomic , strong)  UIView * footerView;
@property (nonatomic , strong)  UIButton * resetButton;//重置
@property (nonatomic , strong)  UIButton * sureButton;//确定
@end

@implementation RightNavPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titles = @[@"全部",@"一个月内",@"一个月至三个月",@"三个月至六个月",@"六个月至一年",@"一年以上"];
    [self buildTable];
}

-(void)buildTable
{
    CGFloat margin = 10.0;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.xl_sldeMenu.emptyWidth, 20, self.xl_sldeMenu.menuWidth, 40)];
    tipsLabel.text = @"下单时间";
    tipsLabel.backgroundColor = RGBA(244, 244, 244, 1);
    tipsLabel.font = [UIFont boldSystemFontOfSize:16];
    tipsLabel.textColor = HEXCOLOR(0x363636);
    [self.view addSubview:tipsLabel];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.minimumLineSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin/2, margin);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.xl_sldeMenu.emptyWidth, CGRectGetMaxY(tipsLabel.frame) + margin, self.xl_sldeMenu.menuWidth, self.view.bounds.size.height - CGRectGetMaxY(tipsLabel.frame) - margin - 50) collectionViewLayout:flowLayout];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SelectTimeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"SelectTimeCollectionCellid"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self.view addSubview:_collectionView];
    [self.view addSubview:self.footerView];

}

-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(self.xl_sldeMenu.emptyWidth, KScreenH - 50, KScreenW - self.xl_sldeMenu.emptyWidth,50)];
        _footerView.backgroundColor = [UIColor whiteColor];
        //线
        UILabel * line = [[UILabel alloc]init];
        line.backgroundColor = RGB(244, 244, 244);
        [_footerView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.equalTo(_footerView).width.offset(0);
            make.height.mas_equalTo(1);
        }];
        
        //重置
        UIFont * font = [UIFont systemFontOfSize:15];
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetButton.backgroundColor = RGBA(244, 244, 244, 1);
        [_resetButton addTarget:self action:@selector(didClickReSet:) forControlEvents:UIControlEventTouchUpInside];
        [_resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [_resetButton setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
        _resetButton.titleLabel.font = font;
        [_footerView addSubview:_resetButton];
        [_resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.bottom).with.offset(1);
            make.left.equalTo(_footerView).with.offset(0);
            make.width.mas_equalTo(_footerView.width/2);
            make.height.mas_equalTo(49);
        }];
        
    
        //确定
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = HEXCOLOR(0xfe6d6a);
        [_sureButton addTarget:self action:@selector(didClickcommit:) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = font;
        [_footerView addSubview:_sureButton];
        [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.and.top.and.width.and.height.equalTo(_resetButton);
            make.right.equalTo(_footerView).with.offset(0);
        }];
    }
    return _footerView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self titles].count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat margin = 10;
    CGFloat itemWidth = (self.xl_sldeMenu.menuWidth - 3 * margin)/2.0f;
    CGSize itemSize = CGSizeMake(itemWidth, 40);
    return itemSize;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelectTimeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectTimeCollectionCellid" forIndexPath:indexPath];
//    cell.layer.borderWidth = 1.0f;
    cell.lb_name.text = [self titles][indexPath.row];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" item = %ld",indexPath.item);
    if (indexPath.row == [self titles].count - 1) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.title = @"ViewController";
        vc.view.backgroundColor = [UIColor whiteColor];
        //获取RootViewController
        UINavigationController *nav = (UINavigationController*)self.xl_sldeMenu.rootViewController;
        [nav pushViewController:vc animated:false];
        //显示主视图
        [self.xl_sldeMenu showRootViewControllerAnimated:true];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 重置
- (void)didClickReSet: (UIButton *)sender
{
    NSLog(@"重置了")
}
#pragma mark - 确定
- (void)didClickcommit: (UIButton *)sender
{
    NSLog(@"确定了")
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
