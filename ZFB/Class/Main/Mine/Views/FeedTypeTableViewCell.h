//
//  FeedTypeTableViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FeedTypeTableViewCellDelegate <NSObject>

@required

-(void)didClickTypeName:(NSString *)typeName Index :(NSInteger)index isSelected :(BOOL) isSelected;

@end

@interface FeedTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewLayoutHeight;

@property (assign , nonatomic) id <FeedTypeTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *typeCollectionView;

@property (strong,nonatomic) NSArray * nameArray;

@property (assign,nonatomic) BOOL isSelectedBackGround;

@end
