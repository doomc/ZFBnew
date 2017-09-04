//
//  ZFAddOfListCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressListModel.h"

@class ZFAddOfListCell;
@protocol AddressCellDelegate <NSObject>

///删除操作
-(void)deleteAction :(ZFAddOfListCell *)cell;
///编辑操作
-(void)editAction :(NSIndexPath *)indexPath ;

//选择状态
-(void)selecteStatus :(BOOL)isSelected;

@end

@interface ZFAddOfListCell : UITableViewCell

@property (nonatomic, strong) Useraddresslist  * list ;

@property (assign, nonatomic)  id <AddressCellDelegate> delegate;

@property (strong, nonatomic)  NSIndexPath *  indexPath;

@property (weak, nonatomic) IBOutlet UIButton *defaultButton;

@property (weak, nonatomic) IBOutlet UILabel *lb_nameAndphoneNum;

@property (weak, nonatomic) IBOutlet UILabel *lb_detailArress;

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
