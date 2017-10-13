//
//  CertificationCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CertificationCellDelegate <NSObject>

-(void)didClickUploadFace: (NSString *)upfaceUrl;

@end
@interface CertificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *uploadImg;

@property (nonatomic , assign) id <CertificationCellDelegate> delegate;


@end
