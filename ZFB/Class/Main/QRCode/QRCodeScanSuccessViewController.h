//
//  QRCodeScanSuccessViewController.h
//  ZFB
//
//  Created by 熊维东 on 2017/8/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface QRCodeScanSuccessViewController : BaseViewController

/** 接收扫描的二维码信息 */
@property (nonatomic, copy) NSString *jump_URL;
/** 接收扫描的条形码信息 */
@property (nonatomic, copy) NSString *jump_bar_code;

@end
