//
//  FeedPickerTableViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FeedPickerTableViewCell.h"
#import "FeedPickerCollectionViewCell.h"

@interface FeedPickerTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionLayoutHeight;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (strong, nonatomic) NSMutableArray *imageViewsDict;
 

@end
@implementation FeedPickerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 3;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    self.bgView.clipsToBounds = YES;
    
    self.commitButton.layer.cornerRadius = 3;
    self.commitButton.clipsToBounds = YES;
    
    self.tf_phoneNum.delegate = self;
    [self.tf_phoneNum addTarget:self action:@selector(changeTextFiled:) forControlEvents:UIControlEventEditingChanged];

    self.pickerCollectionView.delegate = self;
    self.pickerCollectionView.dataSource = self;
    
    [self.pickerCollectionView registerNib:[UINib nibWithNibName:@"FeedPickerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FeedPickerCollectionViewCellid"];
    [self reloadCell];
    
}
-(void)reloadCell
{
    [self.pickerCollectionView reloadData];
    self.collectionLayoutHeight.constant = self.collectionViewFlowLayout.collectionViewContentSize.height;
    [self updateConstraintsIfNeeded];
    
}
-(void)setImgArray:(NSMutableArray *)imgArray
{
    _imgArray = [NSMutableArray array];
    _imgArray = imgArray;
}
-(void)setCurUploadImageHelper:(MPUploadImageHelper *)curUploadImageHelper {
    if (_curUploadImageHelper!=curUploadImageHelper) {
        _curUploadImageHelper=curUploadImageHelper;
    }
    
    //把为浏览大图做准备
    if (_imageViewsDict) {
        [_imageViewsDict removeAllObjects];
        
        for (NSURL *itemUrl in curUploadImageHelper.selectedAssetURLs) {
            MWPhoto *mwphoto=[MWPhoto photoWithURL:itemUrl];
            mwphoto.caption=nil;
            [_imageViewsDict addObject:mwphoto];
        }
    }
}
#pragma  mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger num = self.curUploadImageHelper.imagesArray.count;
    //如果没有大于最大上传数 则显示增加图标
    if (num<kupdateMaximumNumberOfImage) {
        return num+ 1;
    }
    return num;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FeedPickerCollectionViewCell *cell = [self.pickerCollectionView dequeueReusableCellWithReuseIdentifier:@"FeedPickerCollectionViewCellid" forIndexPath:indexPath];
    
    if (indexPath.row < self.curUploadImageHelper.imagesArray.count) {
        MPImageItemModel *curImage = [self.curUploadImageHelper.imagesArray objectAtIndex:indexPath.row];
        cell.curImageItem = curImage;
    }else{
        cell.curImageItem = nil;
    }
//    cell.deleteImageBlock = ^(MPImageItemModel *toDelete){
//        if (self.deleteImageBlock) {
//            self.deleteImageBlock(toDelete);
//        }
//    };
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_addPicturesBlock) {
        _addPicturesBlock();
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个cell的大小，因为有indexPath，所以可以判断哪一组，或者哪一个item，可一个给特定的大小，等同于layout的itemSize属性
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake( 50, 50);
    
}
// 设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}



#pragma mark - changeTextFiled 手机号
- (void)changeTextFiled:(UITextField *)textF {
   
    if ([self.delegate respondsToSelector:@selector(phoneNum:)]) {
        
        [self.delegate phoneNum:_tf_phoneNum.text];
    }

    NSLog(@"text = %@",_tf_phoneNum.text);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
//收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf_phoneNum resignFirstResponder];
    [self endEditing:YES];
}

#pragma mark - didCommitAction 点击提交
- (IBAction)didCommitAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCommit)]) {
        
        [self.delegate didClickCommit];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
