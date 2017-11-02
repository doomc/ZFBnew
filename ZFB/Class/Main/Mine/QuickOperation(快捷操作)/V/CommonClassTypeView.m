//
//  CommonClassTypeView.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CommonClassTypeView.h"
#import "SearchTypeCollectionCell.h"
#import "CollectionCategoryModel.h"
#import "ClassLeftListModel.h"
static NSString * identifier = @"SearchTypeCollectionCell";

@interface CommonClassTypeView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic , strong) UICollectionView  * collctionView;
@property (nonatomic , strong) NSIndexPath *   currentIndex;

@end

@implementation CommonClassTypeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize                                    = CGSizeMake( (KScreenW - 80) / 2.0,  40);
    

    self.collctionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW ,210) collectionViewLayout:layout];
    self.collctionView.backgroundColor = HEXCOLOR(0xf7f7f7);
    self.collctionView.delegate = self;
    self.collctionView.dataSource = self;
    [self.collctionView registerNib:[UINib nibWithNibName:@"SearchTypeCollectionCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    //如果collectionView有头的话，那么写上它，注册collectionview的尾部视图，
    
    [self addSubview:self.collctionView];
    
    NSInteger lieCount = 0;
    if (_isThemeType == YES) {
        if (_classListArray.count%2 == 0)
        {
            lieCount = _classListArray.count/2;
        }
        else
        {
            lieCount = _classListArray.count/2+1;
        }
 
    }else{
        if (_brandListArray.count%2 == 0)
        {
            lieCount = _brandListArray.count/2;
        }
        else
        {
            lieCount = _brandListArray.count/2+1;
        }

    }
    UIView  * footView  =[[ UIView alloc ]initWithFrame:CGRectMake(0, 210 , KScreenW, 50)];
    footView.backgroundColor = [ UIColor redColor];
    [self addSubview:footView];
    
    //取消
    UIButton * cancel = [UIButton buttonWithType: UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 0, KScreenW/2, 50);
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self  action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:cancel];
    
    //确定
    UIButton * sure = [UIButton buttonWithType: UIButtonTypeCustom];
    sure.frame = CGRectMake(KScreenW/2, 0, KScreenW/2, 50);
    sure.backgroundColor = HEXCOLOR(0xf95a70);
    [sure setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure addTarget:self  action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:sure];
 
}
 
#pragma mark - 主题 点击事件
-(void)cancelAction:(UIButton *)sender
{
    if ( [self.delegate respondsToSelector:@selector(removeFromtoSuperView)]) {
        [self.delegate removeFromtoSuperView];
    }
    NSLog(@"取消");
}
-(void)sureAction:(UIButton *)sender
{
    NSLog(@"确认");
    if ( [self.delegate respondsToSelector:@selector(selectedAfter)]) {
        [self.delegate selectedAfter];
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
    if (_isThemeType == YES) {
        return _classListArray.count;
    }else{
        
        return  _brandListArray.count;
    }
}

//返回某个indexPath对应的cell，该方法必须实现：
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTypeCollectionCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (_isThemeType == YES) {
        CmgoodsClasstypelist * list = _classListArray[indexPath.item];
        cell.lb_title.text = list.name;
    }else{
        Nexttypelist * list = _brandListArray[indexPath.item];
        cell.lb_title.text = list.name;
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
    SearchTypeCollectionCell *cell = (SearchTypeCollectionCell *) [collectionView cellForItemAtIndexPath:_currentIndex];
    NSLog(@" --选中当前---%@-----",_currentIndex);
    cell.bgview.backgroundColor = HEXCOLOR(0xf95a70);
    cell.lb_title.textColor = HEXCOLOR(0xffffff);
    
    if (_isThemeType == YES) {
        CmgoodsClasstypelist * list = _classListArray[indexPath.item];
        NSLog(@"typeId ==== %ld",list.typeId);
        if ([self.delegate respondsToSelector:@selector(didClicktypeId:AndTitle:)]) {
            [self.delegate didClicktypeId:[NSString stringWithFormat:@"%ld",list.typeId] AndTitle:list.name];
        }
    }else{
        Nexttypelist * list = _brandListArray[indexPath.item];
        NSString * goodid = [NSString stringWithFormat:@"%ld",list.goodId];
        NSLog(@"goodid = = =%@",goodid);
        if ([self.delegate respondsToSelector:@selector(didClicktypeId:AndTitle:)]) {
            [self.delegate  didClicktypeId:goodid AndTitle:list.name];
        }
    }

    
}
//取消选定
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" --取消选中了---%@-----",_currentIndex);
 
    SearchTypeCollectionCell *cell = (SearchTypeCollectionCell *)[self.collctionView cellForItemAtIndexPath:_currentIndex];
    cell.bgview.backgroundColor = HEXCOLOR(0xe0e0e0);
    cell.lb_title.textColor =  HEXCOLOR(0x333333);
}

-(void)reloadCollctionView
{
    [self.collctionView reloadData];
}
@end
