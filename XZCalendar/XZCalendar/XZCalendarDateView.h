//
//  XZCalendarDateView.h
//  XZCalendar
//
//  Created by 徐章 on 16/1/13.
//  Copyright © 2016年 xuzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  XZCalendarDateViewDelegate<NSObject>

- (void)calendarChangeTitle:(NSDate *)date;

@end

@interface XZCalendarDateView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, weak) id<XZCalendarDateViewDelegate>delegate;

- (void)reloadCalendar:(NSDate *)date;
@end
