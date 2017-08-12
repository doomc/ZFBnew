//
//  SearchHistoryCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/8/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchHistoryCellDelegate <NSObject>

@optional

-(void)deleteSingleDataRow:(NSUInteger)row;


@end
@interface SearchHistoryCell : UITableViewCell

@property (assign , nonatomic) NSUInteger row;

@property (assign , nonatomic) id <SearchHistoryCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *lb_historyName;

- (IBAction)deleteAction:(id)sender;


@end
