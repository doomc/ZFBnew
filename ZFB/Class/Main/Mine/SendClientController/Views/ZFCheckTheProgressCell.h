//
//  ZFCheckTheProgressCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZFCheckTheProgressCellDelegate <NSObject>

/**
 *  进度查询
 */
-(void)progressWithCheckout;

@end
@interface ZFCheckTheProgressCell : UITableViewCell
@property(assign ,nonatomic)id <ZFCheckTheProgressCellDelegate> deldegate;

@property (weak, nonatomic) IBOutlet UIButton *checkProgress_btn;

@end
