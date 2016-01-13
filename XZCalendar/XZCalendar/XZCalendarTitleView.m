//
//  XZCalendarTitleView.m
//  XZCalendar
//
//  Created by 徐章 on 16/1/13.
//  Copyright © 2016年 xuzhang. All rights reserved.
//

#import "XZCalendarTitleView.h"
#import "Masonry.h"
#import "NSDate+String.h"

@implementation XZCalendarTitleView{

    __weak XZCalendarTitleView *_weakSelf;
    
    UIView *_yearMonthView;
    UIView *_weekDayView;
    
    UILabel *_yearMonthLab;
}


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _weakSelf = self;
        [self addYearMonthView];
        [self addWeekDayView];
    }
    
    return self;
}

/**
 *  年份月份TitleView
 */
- (void)addYearMonthView{
    
    _yearMonthView = ({
    
        UIView *view = [UIView new];
        
        view.backgroundColor = [UIColor blueColor];
        
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(_weakSelf);
            make.left.equalTo(_weakSelf);
            make.right.equalTo(_weakSelf);
            
            make.height.mas_equalTo(_weakSelf.mas_height).multipliedBy(0.5);
        }];
        
        //Add Left Button
        UIButton *leftBtn = ({
            
            UIButton *button = [UIButton new];
            
            button.backgroundColor = [UIColor blackColor];
            [button setTitle:@"上一月" forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(leftBtn_Pressed) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.left.equalTo(view).offset(15);
                make.centerY.equalTo(view);
                
                make.top.equalTo(view).offset(5);
                make.bottom.equalTo(view).offset(-5);
                
            }];
            
            button;
        });
        
        //Add Right Button
        UIButton *rightBtn = ({
            
            UIButton *button = [UIButton new];
            
            button.backgroundColor = [UIColor blackColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"下一月" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(rightBtn_Pressed) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(leftBtn);
                make.right.equalTo(view).offset(-15);
                make.height.equalTo(leftBtn);
            }];
            
            
            button;
        });
        
        //Add Middle Label
        _yearMonthLab = ({
            
            UILabel *label = [UILabel new];
            
            label.text = [NSDate stringFromDate:[NSDate date] format:@"yyyy年MM月"];
            
            label.textColor = [UIColor whiteColor];
            
            [view addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.center.equalTo(view);
                
            }];
            
            label;
        });
        
        view;
    });
}

/**
 *  星期TitleView
 */
- (void)addWeekDayView{
    
    _weekDayView = ({
        
        UIView *view = [UIView new];
        
        view.backgroundColor = [UIColor yellowColor];
        
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(_weakSelf);
            make.right.equalTo(_weakSelf);
            make.top.equalTo(_yearMonthView.mas_bottom);
            make.bottom.equalTo(_weakSelf);
        }];
        
        NSArray *array = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
        
        UILabel *lastView;
        CGFloat width = [UIScreen mainScreen].bounds.size.width/array.count;
        for (int i=0; i<7; i++) {
            
            UILabel *weekDayLabel = [UILabel new];
            if (i==5 || i==6) {
                
                weekDayLabel.textColor = [UIColor redColor];
            }else{
            
                weekDayLabel.textColor = [UIColor blackColor];
            }
            weekDayLabel.textAlignment = NSTextAlignmentCenter;
            weekDayLabel.text = array[i];
            
            [view addSubview:weekDayLabel];
            
            [weekDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.top.equalTo(view);
                make.bottom.equalTo(view);
                make.width.mas_equalTo(width);
                if (i == 0) {
                    
                    make.left.equalTo(view);
                }else if(i == 6){
                
                    make.right.equalTo(view);
                }else{
                    
                    make.left.equalTo(lastView.mas_right);
                }
                
            }];
            
            lastView = weekDayLabel;
        }
        
        
        view;
    });
}

#pragma mark - UIButton_Action
- (void)leftBtn_Pressed{

    NSLog(@"上一个月");
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    
    NSDate *date = [NSDate dateFromString:_yearMonthLab.text format:@"yyyy年MM月"];
    
    date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    
    _yearMonthLab.text = [NSDate stringFromDate:date format:@"yyyy年MM月"];
}

- (void)rightBtn_Pressed{

    NSLog(@"下一个月");
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    
    NSDate *date = [NSDate dateFromString:_yearMonthLab.text format:@"yyyy年MM月"];
    
    date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    
    _yearMonthLab.text = [NSDate stringFromDate:date format:@"yyyy年MM月"];
}



@end
