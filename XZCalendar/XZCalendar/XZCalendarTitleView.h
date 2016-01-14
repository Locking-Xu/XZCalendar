//
//  XZCalendarTitleView.h
//  XZCalendar
//
//  Created by 徐章 on 16/1/13.
//  Copyright © 2016年 xuzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XZCalendarTitleViewDelegate <NSObject>

- (void)calendarChangeYearOrMonth:(NSDate *)date;

@end

@interface XZCalendarTitleView : UIView

@property (nonatomic, weak) id<XZCalendarTitleViewDelegate> delegate;

- (void)reloadTitle:(NSDate *)date;

@end
