//
//  SearchTypeFootReusableView.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchTypeFootReusableViewDelegate <NSObject>



@end
@interface SearchTypeFootReusableView : UICollectionReusableView

@property (assign , nonatomic) id <SearchTypeFootReusableViewDelegate>delegate;


@end
