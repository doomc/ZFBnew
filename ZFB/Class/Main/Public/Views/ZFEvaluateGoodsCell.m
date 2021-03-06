//
//  ZFEvaluateGoodsCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFEvaluateGoodsCell.h"
#import "UITextView+ZWLimitCounter.h"
//图片选择器
#import "HXPhotoViewController.h"
#import "HXPhotoView.h"

//星星
#import "XHStarRateView.h"

//表情处理
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"
#import "NSString+EnCode.h"

@interface ZFEvaluateGoodsCell ()<UITextViewDelegate,HXPhotoViewDelegate,XHStarRateViewDelegate>

//图片选择器
@property (strong, nonatomic) HXPhotoManager *manager;

@property (strong, nonatomic) HXPhotoView *photoView;


@end
@implementation ZFEvaluateGoodsCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self initPickerView];
    [self initTextView];
    [self resetTextStyle];
 
    //创建评价
    XHStarRateView * wdStarView = [[XHStarRateView alloc]initWithFrame:CGRectMake(110, 90.5, _starView.width, 30) numberOfStars:5 rateStyle:WholeStar isAnination:YES delegate:self WithtouchEnable:YES littleStar:@"0"];//da星星
    wdStarView.delegate = self;
    [self addSubview:wdStarView];
    
}

-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore
{
    _lb_score.text = [NSString stringWithFormat:@"%.f分",currentScore];
    
    if ([self.delegate respondsToSelector:@selector(getScorenum:)]) {
        [self.delegate getScorenum:[NSString stringWithFormat:@"%.f",currentScore]];
    }
    
}

-(void)initTextView
{
    //textview
//    self.textView.zw_limitCount = 150;//个数显示
//    self.textView.zw_labHeight = 20;//高度
    self.textView.delegate = self;
    self.textView.placeholder = @"请输入评价,150字以内哦~";
    
    // 添加输入改变Block回调.
    [self.textView addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
 
//        NSLog(@"----%@-----",textView.text);
    
        if ([self.delegate respondsToSelector:@selector(getTextViewValues:)]) {
            [self.delegate getTextViewValues:[textView.text encodedString]];
        }
    }];
    
    // 添加到达最大限制Block回调.
    [self.textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
    // 达到最大限制数后的相应操作.
    }];
    
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"开始编辑");
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
    return YES;
    NSLog(@"结束编辑");
}

#pragma mark - initPickerView
-(void)initPickerView
{
    self.photoView                 = [HXPhotoView photoManager:self.manager];
//    self.photoView.frame           = CGRectMake(0, 0, KScreenW - 30 , (KScreenW - 30-3*5)/4);
    self.photoView.frame           = CGRectMake(0, 0, KScreenW - 30 , (KScreenW - 30)/4-3*5);
    self.photoView.delegate        = self;
    self.photoView.backgroundColor = [UIColor whiteColor];
    [self.pickerView addSubview:self.photoView];
    
}

- (void)dealloc {
    
    [self.manager clearSelectedList];
 }

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray <HXPhotoModel *> *)videos original:(BOOL)isOriginal {

    [HXPhotoTools getImageForSelectedPhoto:photos type:HXPhotoToolsFetchHDImageType completion:^(NSArray<UIImage *> *images) {
        NSSLog(@"%@",images);

        //将数据传出去
        if ([self.delegate respondsToSelector:@selector(uploadImageArray:)]) {
            
            [self.delegate uploadImageArray: images ];
        }
        NSLog(@"images === %@",images);
    }];
    
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
//    NSSLog(@"%@",NSStringFromCGRect(frame));
//    NSLog(@"  我当前的高度是 ---%f" ,frame.size.height) ;
    
    self.heightOfConstraint.constant = frame.size.height;
    
    self.pickerView.frame  = CGRectMake(0, 0, KScreenW - 30 , self.heightOfConstraint.constant + 10);
    
    if ([self.delegate respondsToSelector:@selector(reloadCellHeight:)]) {
      
        [self.delegate reloadCellHeight:self.heightOfConstraint.constant + 10];
    }
}

//图片管理器
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager                    = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.openCamera         = YES;
        _manager.cacheAlbum         = YES;
        _manager.open3DTouchPreview = YES;
        _manager.cameraType         = HXPhotoManagerCameraTypeSystem;
        _manager.photoMaxNum        = 5;
        _manager.maxNum             = 5;
        _manager.saveSystemAblum    = NO;
    }
    return _manager;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self insertEmoji];
}

- (void)resetTextStyle {
    //After changing text selection, should reset style.
    NSRange wholeRange = NSMakeRange(0, _textView.textStorage.length);
    [_textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_textView.textStorage addAttribute:NSFontAttributeName value:_textView.font range:wholeRange];
}

-(void)insertEmoji
{
    //Create emoji attachment
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    
    NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:emojiTextAttachment];
    NSRange selectedRange = _textView.selectedRange;
    if (selectedRange.length > 0) {
        [_textView.textStorage deleteCharactersInRange:selectedRange];
    }
    //Insert emoji image
    [_textView.textStorage insertAttributedString:str atIndex:_textView.selectedRange.location];
    
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location+1, 0); // self.textView.selectedRange.length
    
    //Move selection location
    //_textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);
    
    //Reset text style
    [self resetTextStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
