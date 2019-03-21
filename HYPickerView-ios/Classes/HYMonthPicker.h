//
//  HYMonthPicker.h
//  StudyPickerView
//
//  Created by ocean on 2019/3/21.
//  Copyright © 2019 ocean. All rights reserved.
//

/**
 例子:
 
 NSTimeInterval oneday = 24 * 60 * 60;
 
 self.monthPicker = [[HYMonthPicker alloc] init];
 self.monthPicker.delegate = self;
 self.monthPicker.yearPrefix = @"第";
 self.monthPicker.yearSuffix = @"年";
 self.monthPicker.monthPrefix = @"第";
 self.monthPicker.monthSuffix = @"月";
 self.monthPicker.rowHeight = 100;
 [self.monthPicker setMaximumDate:[[NSDate date] dateByAddingTimeInterval:oneday * 31 * 2]];
 [self.monthPicker setCurrentDate:[NSDate date]];
 [self.monthPicker setMinimumDate:[[NSDate date] dateByAddingTimeInterval:-(oneday * 31 * 24)]];
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [self.monthPicker show];
 });
 */

#import <UIKit/UIKit.h>

@class HYMonthPicker;

NS_ASSUME_NONNULL_BEGIN

@protocol HYMonthPickerDelegate <NSObject>

@optional

/**
 点击了确定按钮

 @param monthPicker HYMonthPicker
 @param dateString yyyy-MM 格式的日期
 */
- (void)monthPickerDidClickConfirm:(HYMonthPicker *)monthPicker
                        dateString:(NSString *)dateString;

@end

@interface HYMonthPicker : NSObject

@property (nonatomic, weak, nullable) id<HYMonthPickerDelegate> delegate;

#pragma mark - 显示格式

/** 年前缀 */
@property (nonatomic, copy) NSString *yearPrefix;
/** 年后缀 */
@property (nonatomic, copy) NSString *yearSuffix;
/** 月前缀 */
@property (nonatomic, copy) NSString *monthPrefix;
/** 月后缀 */
@property (nonatomic, copy) NSString *monthSuffix;

#pragma mark - 

/** 行高 */
@property (nonatomic, assign) CGFloat rowHeight;

#pragma mark - 日期设置
/** 设置当前日期 */
- (void)setCurrentDate:(NSDate *)date;
/** 设置最小日期 */
- (void)setMinimumDate:(NSDate *)date;
/** 设置最大日期 */
- (void)setMaximumDate:(NSDate *)date;

#pragma mark - Show & Dismiss
- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
