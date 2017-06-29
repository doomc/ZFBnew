//
//  ZFSaleAfterContentCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZFSaleAfterContentCellDelegate <NSObject>

-(void)salesAfterDetailPage;


@end
@interface ZFSaleAfterContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *saleAfter_btn;

@property (nonatomic,assign) id <ZFSaleAfterContentCellDelegate> delegate;


@end
