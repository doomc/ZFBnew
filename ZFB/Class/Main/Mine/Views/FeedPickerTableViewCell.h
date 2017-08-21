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

-(void)uploadImageArray:(NSMutableArray *)uploadArr;

-(void)reloadCellHeight:(CGFloat)cellHeight;

@end
@interface FeedPickerTableViewCell : UITableViewCell

@property (assign, nonatomic) id <FeedPickerTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *pickerCollectionView;

@property (nonatomic, strong) NSMutableArray * imgUrl_mutArray;//存放选取的图片数组

@property (nonatomic, assign) CGFloat cellHight;


@end
