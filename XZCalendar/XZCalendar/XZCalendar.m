//
//  XZCalendar.m
//  XZCalendar
//
//  Created by 徐章 on 16/1/13.
//  Copyright © 2016年 xuzhang. All rights reserved.
//

#import "XZCalendar.h"

#import "Masonry.h"

@implementation XZCalendar{
    
    __weak XZCalendar *_weakSelf;
    
    XZCalendarTitleView *_titleView;
    XZCalendarDateView *_dateView;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _weakSelf = self;
        [self addTitleView];
        [self addDateView];
    }
    return self;
}

#pragma mark - Add TitleView
- (void)addTitleView{
    
    _titleView = ({
        
        XZCalendarTitleView *view = [[XZCalendarTitleView alloc] init];
        
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(_weakSelf);
            make.left.equalTo(_weakSelf);
            make.right.equalTo(_weakSelf);
            make.height.mas_equalTo(@80);
            
        }];
        view;
    });
    
    _titleView.delegate = self;
}

- (void)addDateView{
    
    _dateView = ({
        
        XZCalendarDateView *view = [[XZCalendarDateView alloc] init];
        view.backgroundColor = [UIColor purpleColor];
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(_weakSelf);
            make.bottom.equalTo(_weakSelf);
            make.right.equalTo(_weakSelf);
            make.top.equalTo(_titleView.mas_bottom);
        }];
        
        view;
    });
    _dateView.delegate = self;
}

#pragma mark - XZCalendarTitleViewDelegate
- (void)calendarChangeYearOrMonth:(NSDate *)date{
    
    [_dateView reloadCalendar:date];
}

#pragma mark - XZCalendarDateViewDelegate
- (void)calendarChangeTitle:(NSDate *)date{
    
    [_titleView reloadTitle:date];
    
}
@end
