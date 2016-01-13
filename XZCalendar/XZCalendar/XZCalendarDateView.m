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

#define UISCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation XZCalendarDateView{
    
    __weak XZCalendarDateView *_weakSelf;
    /** 当前显示在屏幕的月的总天数*/
    NSInteger toalDaysOfCurrentMonth;
    
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _weakSelf = self;
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
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayot];
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.delegate =self;
    collectionView.dataSource = self;
    [collectionView registerClass:[XZCalendarCell class] forCellWithReuseIdentifier:@"calendarCell"];
    
    [self addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.edges.equalTo(_weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    
}

#pragma mark - Calculate Methods
- (NSInteger)totalDaysOfMonth:(NSDate *)date{
    
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    return range.length;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"calendarCell";
    XZCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.dayLabel.text = @"1";
    
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}
#pragma mark - UICollectionViewDelegate
@end
