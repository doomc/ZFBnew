//
//  FeedCommitPhoneCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FeedCommitPhoneCellDelegate <NSObject>

///输入的手机号码
-(void)phoneNum:(NSString *)phoneNum;

///提交数据
-(void)didClickCommit;

@end
@interface FeedCommitPhoneCell : UITableViewCell

@property (assign, nonatomic)  id <FeedCommitPhoneCellDelegate>commitDelegate;

@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNum;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;


@end
