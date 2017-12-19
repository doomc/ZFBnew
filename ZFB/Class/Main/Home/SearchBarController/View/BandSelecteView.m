//
//  BandSelecteView.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BandSelecteView.h"
#import "SearchTypeCollectionCell.h"
#import "BrandListModel.h"

@interface BandSelecteView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic , strong) UICollectionView  * collctionView;
@property (nonatomic , strong) NSIndexPath *   currentIndex;

@end

@implementation BandSelecteView

-(instancetype)initWithBandSelecteViewFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.collctionView.showsVerticalScrollIndicator = NO;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake( (KScreenW - 80) / 2.0,  40);
    
    
    self.collctionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW ,210) collectionViewLayout:layout];
    self.collctionView.backgroundColor = HEXCOLOR(0xf7f7f7);
    self.collctionView.delegate = self;
    self.collctionView.dataSource = self;
    [self.collctionView registerNib:[UINib nibWithNibName:@"SearchTypeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"SearchTypeCollectionCell"];
    //如果collectionView有头的话，那么写上它，注册collectionview的尾部视图，
    
    [self addSubview:self.collctionView];
    
    UIView  * footView  =[[ UIView alloc ]initWithFrame:CGRectMake(0, 210 , KScreenW, 50)];
    footView.backgroundColor = [ UIColor whiteColor];
    [self addSubview:footView];
    
    UIFont *font = SYSTEMFONT(14);
    //取消
    UIButton * cancel = [UIButton buttonWithType: UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 0, KScreenW/2, 50);
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self  action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    cancel.titleLabel.font = font;
    [footView addSubview:cancel];
    
    //确定
    UIButton * sure = [UIButton buttonWithType: UIButtonTypeCustom];
    sure.frame = CGRectMake(KScreenW/2, 0, KScreenW/2, 50);
    sure.backgroundColor = HEXCOLOR(0xf95a70);
    [sure setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure addTarget:self  action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    sure.titleLabel.font = font;
    [footView addSubview:sure];
    
}

#pragma mark - 主题 点击事件
-(void)cancelAction:(UIButton *)sender
{
    NSLog(@"取消");
    if ([self.delegate respondsToSelector:@selector(didClickCancel)]) {
        
        [self.delegate didClickCancel];
    }
}
-(void)sureAction:(UIButton *)sender
{
    NSLog(@"点击了确认");
    if (_currentIndex.item >= 0) {
        BrandFindbrandlist * list = self.brandListArray[_currentIndex.item];
        NSString * brandName = list.brandName;
        NSString * brandid =  list.brandId;
        if ([self.delegate respondsToSelector:@selector(didSelectedIndex:brandId:brandName:)]) {
            [self.delegate didSelectedIndex:_currentIndex.item brandId:brandid brandName:brandName];
        }
    }else{
        NSLog(@"没有选择品牌");
        if ([self.delegate respondsToSelector:@selector(didClickConfirm)]) {
            [self.delegate didClickConfirm];
        }
    }
}
#pragma mark - UICollectionViewDataSource 代理
//返回collection view里区(section)的个数，如果没有实现该方法，将默认返回1：
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//返回指定区(section)包含的数据源条目数(number of items)，该方法必须实现：
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  _brandListArray.count;

}

//返回某个indexPath对应的cell，该方法必须实现：
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTypeCollectionCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchTypeCollectionCell" forIndexPath:indexPath];
    
    if (_brandListArray.count > 0) {
        BrandFindbrandlist * list = _brandListArray[indexPath.item];
        cell.lb_title.text = list.brandName;
        if (list.isChoosed) {
            cell.bgview.backgroundColor = HEXCOLOR(0xf95a70);
            cell.lb_title.textColor =  HEXCOLOR(0xffffff);
        }else{
            cell.bgview.backgroundColor = HEXCOLOR(0xe0e0e0);
            cell.lb_title.textColor =  HEXCOLOR(0x333333);
        }
    }
    return cell;
    
}

//设定collectionView(指定区)的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 20, 10,20);
    
}
//点击每个item实现的方法：
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _currentIndex = indexPath;

    SearchTypeCollectionCell *cell = (SearchTypeCollectionCell *)[collectionView cellForItemAtIndexPath:_currentIndex];
    cell.bgview.backgroundColor = HEXCOLOR(0xf95a70);
    cell.lb_title.textColor =  HEXCOLOR(0xffffff);
    NSLog(@" -- 选中了---%ld-----",_currentIndex.item);
}
//取消选定
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" --取消选中了---%ld-----",_currentIndex.item);
    
    SearchTypeCollectionCell *cell = (SearchTypeCollectionCell *)[collectionView cellForItemAtIndexPath:_currentIndex];
    cell.bgview.backgroundColor = HEXCOLOR(0xe0e0e0);
    cell.lb_title.textColor =  HEXCOLOR(0x333333);
}

-(void)reload_CollctionView
{
    [self.collctionView reloadData];
}

@end
