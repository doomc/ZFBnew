//
//  FuncListTableViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FuncListTableViewCell.h"
#import "FuncListCollectionViewCell.h"
#import "HomeFuncModel.h"

@interface FuncListTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>


@end
@implementation FuncListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.funcCollectionView.dataSource =self;
    self.funcCollectionView.delegate = self;
    self.funcCollectionView.scrollEnabled = NO;

    [self.funcCollectionView registerNib:[UINib nibWithNibName:@"FuncListCollectionViewCell" bundle:nil]
              forCellWithReuseIdentifier:@"FuncListCollectionViewCellid"];

    [self FuncListPostRequst];
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataArray.count > 0) {
       
        return self.dataArray.count;

    }
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeFuncModel * func=  [HomeFuncModel new];
    if (indexPath.item < [self.dataArray count]) {
        
       func  = [self.dataArray objectAtIndex:indexPath.row];
    }
    FuncListCollectionViewCell * cell = [self.funcCollectionView dequeueReusableCellWithReuseIdentifier:@"FuncListCollectionViewCellid" forIndexPath:indexPath];
    cell.lb_listName.text = func.name;
    NSURL * img_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",func.iconUrl]];
    [cell.img_listView sd_setImageWithURL:img_url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
 
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld  = item" ,indexPath.item);
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(KScreenW/4-10,85);
}
// 设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


#pragma mark - funcList-getGoodsTypeInfo 按钮图片和状态
-(void)FuncListPostRequst
{
    NSDictionary * parma = @{
                             
                             @"svcName":@"getGoodsTypeInfo",
                             @"cmUserId":BBUserDefault.cmUserId,
                             
                             };
 
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parma responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
          
            if (self.dataArray.count >0) {

                [self.dataArray removeAllObjects];
                
            }else{
                
                [self makeToast:@"请求成功" duration:2 position:@"center" ];
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                NSArray * dictArray = jsondic [@"CmGoodsTypeList"];
                
                //mjextention 数组转模型
                NSArray *storArray = [HomeFuncModel mj_objectArrayWithKeyValuesArray:dictArray];
                for (HomeFuncModel *funclist in storArray) {
 
                    [self.dataArray addObject:funclist];
                }
                NSLog(@"dataArray = %@",  self.dataArray);

                [self.funcCollectionView reloadData];
            }
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
       [self makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
