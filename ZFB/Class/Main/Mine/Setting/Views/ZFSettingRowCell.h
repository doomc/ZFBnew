//
//  ZFSettingRowCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZFSettingRowCellDelegate  <NSObject>

-(void )getNickName:(NSString *)nickName;

@end
@interface ZFSettingRowCell : UITableViewCell

@property (assign ,nonatomic) id <ZFSettingRowCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UITextField *tf_contentTextfiled;

@property (weak, nonatomic) IBOutlet UILabel *lb_detailTitle;

@property (copy, nonatomic) NSString * nickName;

@property (assign, nonatomic) BOOL   isEdited;//已经编辑过了

@end
