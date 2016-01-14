//
//  XZCalendarDateView.m
//  XZCalendar
//
//  Created by 徐章 on 16/1/13.
//  Copyright © 2016年 xuzhang. All rights reserved.
//

#import "XZCalendarDateView.h"
#import "Masonry.h"
#import "XZCalendarCell.h"
#import "MMPlaceHolder.h"
#import "NSDate+String.h"

#define UISCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define ChineseMonths @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"]
#define ChineseDays @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]

@implementation XZCalendarDateView{
    
    __weak XZCalendarDateView *_weakSelf;
    /** 当前显示在屏幕的月的总天数*/
    NSInteger _toalDaysOfCurrentMonth;
    /** 某一月月的1号的是星期几，0:星期一、1:星期二、2:星期三、3:星期四、4:星期五、5:星期六、6:星期日、*/
    NSInteger _weekDayOfFirstDayOfMonth;
    /** 某一个月的前一个月的总天数*/
    NSInteger _totalDaysOfPreviousMonth;
    /** 日期数组*/
    NSMutableArray *_dayArray;
    
    UICollectionView *_collectionView;
    /** 当前显示的日期*/
    NSDate *_currentDate;
    /** 当前选中的日期，没有选时以今天为选中日期*/
    NSDateComponents *_selectComponents;
    /** */
    XZCalendarCell *_selectCell;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _weakSelf = self;
        
        _currentDate = [NSDate date];
        
        _selectComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth| NSCalendarUnitDay fromDate:[NSDate date]];
        
        [self numberOfCollectionCells:_currentDate];
        
        [self addCollectionView];
    }
    
    return self;
}

- (void)addCollectionView{
    CGFloat itemWidth = UISCREEN_WIDTH / 7;
    UICollectionViewFlowLayout *flowLayot = [[UICollectionViewFlowLayout alloc] init];
    flowLayot.itemSize = CGSizeMake(itemWidth, 40);
    flowLayot.minimumLineSpacing = 0;
    flowLayot.minimumInteritemSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayot];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate =self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[XZCalendarCell class] forCellWithReuseIdentifier:@"calendarCell"];
    
    [self addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.edges.equalTo(_weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    
}

#pragma mark - Calculate Methods
/**
 *  获得date所在月份的总天数
 *
 *  @param date NSDate
 *
 *  @return 月份总天数
 */
- (NSInteger)totalDaysOfMonth:(NSDate *)date{
    
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    return range.length;
}

/**
 *  获得date所在月份的起一个月总天数
 *
 *  @param date NSDate
 *
 *  @return 月份总天数
 */
- (NSInteger)totalDaysOfPreviosMonth:(NSDate *)date{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setMonth:-1];
    
    NSDate *previousDate = [calendar dateByAddingComponents:components toDate:date options:0];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:previousDate];
    
    return range.length;
}

/**
 *  获得date所在月份的一号是星期几
 *
 *  @param date NSDate
 *
 *  @return 星期几
 */
- (NSInteger)weekDayOfFirstDayInMonth:(NSDate *)date{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //将星期一设置为一个星期的第一天
    [calendar setFirstWeekday:2];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    [components setDay:1];
    
    NSDate *firstDate = [calendar dateFromComponents:components];
    
    NSInteger weekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDate];
    
    return weekday-1;
}

/**
 *  获得date对应的农历
 *
 *  @param date NSDate
 *
 *  @return 农历
 */
- (NSString *)dayInChineseCalendar:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    if (components.day == 1) {
        
        return ChineseMonths[components.month - 1];
    }else{
        
        return ChineseDays[components.day - 1];
    }
}

/**
 *  collectionView中Cell的个数
 */
- (void)numberOfCollectionCells:(NSDate *)date{

    /** 当前显示在屏幕的月的总天数*/
     _toalDaysOfCurrentMonth = [self totalDaysOfMonth:date];
    /** 某一月月的1号的是星期几，0:星期一、1:星期二、2:星期三、3:星期四、4:星期五、5:星期六、6:星期日、*/
    _weekDayOfFirstDayOfMonth = [self weekDayOfFirstDayInMonth:date];
    /** 某一个月的前一个月的总天数*/
    _totalDaysOfPreviousMonth = [self totalDaysOfPreviosMonth:date];

    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSMutableArray *previousArray = [NSMutableArray arrayWithCapacity:_weekDayOfFirstDayOfMonth];
    //上一个月日期
    for (NSInteger i=0; i<_weekDayOfFirstDayOfMonth; i++) {
    
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:_currentDate];
        
        [components setMonth:components.month-1];
        
        [components setDay:_totalDaysOfPreviousMonth-i];
        
        [previousArray addObject:components];
    }
    //当前月日期
    NSMutableArray *currentArray = [NSMutableArray arrayWithCapacity:_toalDaysOfCurrentMonth];
    for (NSInteger j=1; j<=_toalDaysOfCurrentMonth; j++) {
        
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:_currentDate];
        
        [components setDay:j];
        
        [currentArray addObject:components];
    }
    
    //collectionView的整行的余数
    NSInteger remainder = (previousArray.count + currentArray.count)%7;
    
    NSMutableArray *nextArray = [NSMutableArray new];
    
    if (remainder != 0) {
        //下一个月日期
        for (int k = 1; k <= (7-remainder); k++) {
            
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:_currentDate];
            [components setMonth:components.month+1];
            [components setDay:k];
            
            [nextArray addObject:components];
        }
        
    }
    
    _dayArray = [NSMutableArray new];
    [_dayArray addObjectsFromArray:[previousArray reverseObjectEnumerator].allObjects];
    [_dayArray addObjectsFromArray:currentArray];
    [_dayArray addObjectsFromArray:nextArray];
}

- (void)reloadCalendar:(NSDate *)date{
    
    _currentDate = date;
    
    [self numberOfCollectionCells:_currentDate];
    
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _dayArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"calendarCell";
    XZCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.dayLabel.textColor = [UIColor whiteColor];
    cell.chineseDayLabel.textColor = [UIColor whiteColor];
   
    
    if (indexPath.row < _weekDayOfFirstDayOfMonth || indexPath.row>=(_weekDayOfFirstDayOfMonth+_toalDaysOfCurrentMonth)) {
        
        cell.dayLabel.textColor = cell.chineseDayLabel.textColor = [UIColor blackColor];
    }
    
    NSDateComponents *components = _dayArray[indexPath.row];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    cell.backgroundColor = [UIColor grayColor];
    if (_selectComponents && [[calendar dateFromComponents:components] isEqualToDate:[calendar dateFromComponents:_selectComponents]]) {
        
        cell.backgroundColor = [UIColor greenColor];
        
    }
    
    
    cell.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)components.day];
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
  
    cell.chineseDayLabel.text = [self dayInChineseCalendar:date];

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDateComponents *components = _dayArray[indexPath.row];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    if (_selectComponents && [[calendar dateFromComponents:components] isEqualToDate:[calendar dateFromComponents:_selectComponents]]) {
        
        return;
    }
    
    _selectComponents = components;
    
    if (indexPath.row<_weekDayOfFirstDayOfMonth) {
        
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:_currentDate];
        [components setMonth:components.month-1];
        
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(calendarChangeTitle:)]) {
            
            [self.delegate calendarChangeTitle:date];
        }
        
        [self reloadCalendar:date];
    }else if (indexPath.row>=(_weekDayOfFirstDayOfMonth + _toalDaysOfCurrentMonth)){
        
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:_currentDate];
        [components setMonth:components.month+1];
        
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(calendarChangeTitle:)]) {
            
            [self.delegate calendarChangeTitle:date];
        }
        
        [self reloadCalendar:date];
        
    }else{
    
        [_collectionView reloadData];
    }

}
@end
