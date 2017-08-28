//
//  DetailWebViewCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/8/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DetailWebViewCellDelegate <NSObject>

-(void)getHeightForWebView:(CGFloat)Height;

@end
@interface DetailWebViewCell : UITableViewCell

@property (nonatomic , assign) id <DetailWebViewCellDelegate> delegate;

 

@property (nonatomic ,copy) NSString * HTMLString;

@end
