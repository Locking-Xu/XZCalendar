//
//  XZCalendarCell.m
//  XZCalendar
//
//  Created by 徐章 on 16/1/13.
//  Copyright © 2016年 xuzhang. All rights reserved.
//

#import "XZCalendarCell.h"
#import "Masonry.h"

@implementation XZCalendarCell

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderColor = [UIColor greenColor].CGColor;
        self.layer.borderWidth = 0.5f;
    }
    
    return self;
}


- (UILabel *)dayLabel{
    
    __weak XZCalendarCell *weakSelf = self;
    
    if (!_dayLabel) {
        
        _dayLabel = [UILabel new];
        
        _dayLabel.textColor = [UIColor whiteColor];
        
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_dayLabel];
        
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf);
            make.right.equalTo(weakSelf);
            make.height.equalTo(weakSelf.mas_height).multipliedBy(0.5f);
        }];
    }
    
    return _dayLabel;
}

- (UILabel *)chineseDayLabel{

    __weak XZCalendarCell *weakSelf = self;
    
    if (!_chineseDayLabel) {
        
        _chineseDayLabel = [UILabel new];
        
        _chineseDayLabel.textAlignment = NSTextAlignmentCenter;
        _chineseDayLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:_chineseDayLabel];
        
        [_chineseDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(weakSelf);
            make.left.equalTo(weakSelf);
            make.right.equalTo(weakSelf);
            make.height.equalTo(weakSelf.mas_height).multipliedBy(0.5f);
        }];
    }
    return _chineseDayLabel;
}
@end
