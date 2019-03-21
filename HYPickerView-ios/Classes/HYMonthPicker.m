//
//  HYMonthPicker.m
//  StudyPickerView
//
//  Created by ocean on 2019/3/21.
//  Copyright © 2019 ocean. All rights reserved.
//

#import "HYMonthPicker.h"
#import "HYPickerView.h"

static const NSUInteger HYMonthPickerNumberOfMonthsInYear = 12;

@interface HYMonthPicker ()<HYPickerViewDataSource, HYPickerViewDelegate>

@property (nonatomic, assign) NSUInteger startYear;
@property (nonatomic, assign) NSUInteger endYear;

@property (nonatomic, assign) NSUInteger currentYear;
@property (nonatomic, assign) NSUInteger currentMonth;

@property (nonatomic, assign) NSUInteger minMonthForStartYear;
@property (nonatomic, assign) NSUInteger maxMonthForEndYear;

@property (nonatomic, strong) HYPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *yearDataSource;
@property (nonatomic, strong) NSMutableArray *monthDataSource;
@property (nonatomic, strong) NSMutableArray *monthDataSourceForAll;
@property (nonatomic, strong) NSMutableArray *monthDataSourceForStartYear;
@property (nonatomic, strong) NSMutableArray *monthDataSourceForEndYear;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, assign) BOOL selected;

@end

@implementation HYMonthPicker

- (instancetype)init {
    self = [super init];
    if (self) {
        _startYear = 1970;
        _endYear = 10000;
        _currentYear = [self p_yearForDate:[NSDate date]];
        _currentMonth = [self p_monthForDate:[NSDate date]];
        if (_endYear < _currentYear) {
            _endYear = _currentYear;
        }
        _yearPrefix = @"";
        _yearSuffix = @"";
        _monthPrefix = @"";
        _monthSuffix = @"";
        _rowHeight = 45.0f;
        _selectedDate = [NSDate date];
        _selected = YES;
        _maxMonthForEndYear = HYMonthPickerNumberOfMonthsInYear;
        _minMonthForStartYear = 1;
    }
    return self;
}

#pragma mark - 数据源

- (void)updateDataSource {
    [self updateYearDataSource];
    [self updateMonthDataSource];
}

- (void)updateYearDataSource {
    [self.yearDataSource removeAllObjects];
    for (NSUInteger i = _startYear; i <= _endYear; i++) {
        NSString *yearStr = [self formattedStringForYear:i];
        [self.yearDataSource addObject:yearStr];
    }
}

- (void)updateMonthDataSource {
    [self.monthDataSourceForAll removeAllObjects];
    for (NSUInteger i = 1; i <= HYMonthPickerNumberOfMonthsInYear; i++) {
        NSString *monthStr = [self formattedStringForMonth:i];
        [self.monthDataSourceForAll addObject:monthStr];
    }
    
    [self.monthDataSourceForStartYear removeAllObjects];
    for (NSUInteger i = _minMonthForStartYear; i <= HYMonthPickerNumberOfMonthsInYear; i++) {
        NSString *monthStr = [self formattedStringForMonth:i];
        [self.monthDataSourceForStartYear addObject:monthStr];
    }
    
    [self.monthDataSourceForEndYear removeAllObjects];
    for (NSUInteger i = 1; i <= _maxMonthForEndYear; i++) {
        NSString *monthStr = [self formattedStringForMonth:i];
        [self.monthDataSourceForEndYear addObject:monthStr];
    }
    
    // 默认采用的是最后一个年份，后面切换选中的年份时会自动刷新
    [self.monthDataSource addObjectsFromArray:self.monthDataSourceForEndYear];
}

- (NSString *)formattedStringForYear:(NSUInteger)year {
    return [NSString stringWithFormat:@"%@%@%@", _yearPrefix, @(year), _yearSuffix];
}

- (NSString *)formattedStringForMonth:(NSUInteger)month {
    return [NSString stringWithFormat:@"%@%@%@", _monthPrefix, @(month), _monthSuffix];
}

#pragma mark - 日期设置

- (void)setMinimumDate:(NSDate *)date {
    NSUInteger startYear = [self p_yearForDate:date];
    if (startYear > _endYear) return;
    _startYear = startYear;
//    _minMonthForStartYear = [self p_monthForDate:date]; // 不处理
}

- (void)setMaximumDate:(NSDate *)date {
    NSUInteger endYear = [self p_yearForDate:date];
    if (endYear < _startYear) return;
    _endYear = endYear;
    _maxMonthForEndYear = [self p_monthForDate:date];
}

- (void)setCurrentDate:(NSDate *)date {
    _selectedDate = date;
    _selected = YES;
}

#pragma mark - Show & Dismiss
- (void)show {
    [self updateDataSource];
    [self.pickerView show];
    [self.pickerView reloadAllComponents];
    // 先刷新再设置选中的日期
    if (_selected) {
        [self p_selectDate];
        _selected = NO;
    }
}

- (void)dismiss {
    [self.pickerView dismiss];
}

#pragma mark - HYPickerViewDataSource

- (NSInteger)hy_numberOfComponentsInPickerView:(HYPickerView *)pickerView {
    return 2;
}

- (NSInteger)hy_pickerView:(HYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearDataSource.count;
    } else {
        return self.monthDataSource.count;
    }
}

#pragma mark - HYPickerViewDelegate

- (CGFloat)hy_pickerView:(HYPickerView *)pickerView
       widthForComponent:(NSInteger)component {
    return [UIScreen mainScreen].bounds.size.width / 2;
}

- (CGFloat)hy_pickerView:(HYPickerView *)pickerView
   rowHeightForComponent:(NSInteger)component {
    return _rowHeight;
}

- (nullable NSString *)hy_pickerView:(HYPickerView *)pickerView
                         titleForRow:(NSInteger)row
                        forComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearDataSource[row];
    } else {
        return self.monthDataSource[row];
    }
}

- (void)hy_pickerView:(HYPickerView *)pickerView
         didSelectRow:(NSInteger)row
          inComponent:(NSInteger)component {
    if (component == 0) {
        [self.monthDataSource removeAllObjects];
        if (row == [pickerView numberOfRowsInComponent:component] - 1) {
            // 最后一年
            [self.monthDataSource addObjectsFromArray:self.monthDataSourceForEndYear];
        } else {
            [self.monthDataSource addObjectsFromArray:self.monthDataSourceForAll];
        }
        [pickerView reloadComponent:1];
    } else {
        
    }
}

- (void)hy_pickerViewDidClickConfirm:(HYPickerView *)pickerView {
    NSUInteger yearRow = [pickerView selectedRowInComponent:0];
    NSUInteger monthRow = [pickerView selectedRowInComponent:1];
    
    NSString *yearString = self.yearDataSource[yearRow];
    NSString *monthString = self.monthDataSource[monthRow];
    
    yearString = [yearString stringByReplacingOccurrencesOfString:_yearPrefix withString:@""];
    yearString = [yearString stringByReplacingOccurrencesOfString:_yearSuffix withString:@""];
    
    monthString = [monthString stringByReplacingOccurrencesOfString:_monthPrefix withString:@""];
    monthString = [monthString stringByReplacingOccurrencesOfString:_monthSuffix withString:@""];
    
    NSMutableString *dateString = [NSMutableString string];
    [dateString appendString:yearString];
    [dateString appendString:@"-"];
    if (monthString.integerValue < 10) {
        [dateString appendString:@"0"];
    }
    [dateString appendString:monthString];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(monthPickerDidClickConfirm:dateString:)]) {
        [self.delegate monthPickerDidClickConfirm:self dateString:[dateString copy]];
    }
}

#pragma mark - private method

- (NSUInteger)p_yearForDate:(NSDate *)date {
    return [self p_dateComponentsForDate:date].year;
}

- (NSUInteger)p_monthForDate:(NSDate *)date {
    return [self p_dateComponentsForDate:date].month;
}

- (NSDateComponents *)p_dateComponentsForDate:(NSDate *)date {
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth;
    return [[NSCalendar currentCalendar] components:unit fromDate:date];
}

- (void)p_selectDate {
    NSUInteger year = [self p_yearForDate:_selectedDate];
    NSUInteger month = [self p_monthForDate:_selectedDate];
    [self.pickerView selectRow:year - _startYear inComponent:0 animated:year];
    [self.pickerView selectRow:month - 1 inComponent:1 animated:YES];
}

#pragma mark - Lazy

- (HYPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[HYPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (NSMutableArray *)yearDataSource {
    if (!_yearDataSource) {
        _yearDataSource = [NSMutableArray array];
    }
    return _yearDataSource;
}

- (NSMutableArray *)monthDataSource {
    if (!_monthDataSource) {
        _monthDataSource = [NSMutableArray array];
    }
    return _monthDataSource;
}

- (NSMutableArray *)monthDataSourceForAll {
    if (!_monthDataSourceForAll) {
        _monthDataSourceForAll = [NSMutableArray array];
    }
    return _monthDataSourceForAll;
}

- (NSMutableArray *)monthDataSourceForStartYear {
    if (!_monthDataSourceForStartYear) {
        _monthDataSourceForStartYear = [NSMutableArray array];
    }
    return _monthDataSourceForStartYear;
}

- (NSMutableArray *)monthDataSourceForEndYear {
    if (!_monthDataSourceForEndYear) {
        _monthDataSourceForEndYear = [NSMutableArray array];
    }
    return _monthDataSourceForEndYear;
}

@end
