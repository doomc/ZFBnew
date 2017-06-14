//
//  ZFMainListCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZFMainListCellDelegate <NSObject>

//全部分类
-(void
  )didClickAllClassAction:(UIButton *)sender;

@end
@interface ZFMainListCell : UITableViewCell


@property(nonatomic,assign)id <ZFMainListCellDelegate>delegate;


//全部分类
@property (weak, nonatomic) IBOutlet UIButton *Classify_btn;
@end
