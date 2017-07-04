//
//  FeedPickerTableViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FeedPickerTableViewCellDelegate <NSObject>
@required
///输入的手机号码
-(void)phoneNum:(NSString *)phoneNum;

///提交数据
-(void)didClickCommit;


@end
@interface FeedPickerTableViewCell : UITableViewCell

@property (assign, nonatomic) id <FeedPickerTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *pickerCollectionView;

@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNum;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (nonatomic,strong) NSMutableArray * imgArray;

@end
