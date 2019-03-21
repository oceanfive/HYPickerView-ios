//
//  HYPickerView.h
//  StudyPickerView
//
//  Created by ocean on 2019/3/21.
//  Copyright © 2019 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYPickerView;
@protocol HYPickerViewDataSource;
@protocol HYPickerViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface HYPickerView : UIView

#pragma mark - dataSource & delegate
@property (nonatomic, weak, nullable) id<HYPickerViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<HYPickerViewDelegate> delegate;

#pragma mark - data source and delegate 缓存的信息

/**
 有多少列，对应的是数据源方法:
 - (NSInteger)hy_numberOfComponentsInPickerView:(HYPickerView *)pickerView;
 */
@property(nonatomic, readonly) NSInteger numberOfComponents;

/**
 第 component 列有多少行，对应的数据源方法:
 - (NSInteger)hy_pickerView:(HYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
 */
- (NSInteger)numberOfRowsInComponent:(NSInteger)component;

/**
 第 component 列的行大小，对应的代理方法:
- (CGFloat)hy_pickerView:(HYPickerView *)pickerView
       widthForComponent:(NSInteger)component;
- (CGFloat)hy_pickerView:(HYPickerView *)pickerView
   rowHeightForComponent:(NSInteger)component;
 */
- (CGSize)rowSizeForComponent:(NSInteger)component;

///**
// 第 component 、第 row 行的自定义控件，对应的代理方法:
// - (UIView *)hy_pickerView:(HYPickerView *)pickerView
//                viewForRow:(NSInteger)row
//              forComponent:(NSInteger)component
//               reusingView:(nullable UIView *)view;
// */
//- (nullable UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component;

#pragma mark - reload
/** 刷新所有的列 */
- (void)reloadAllComponents;
/** 刷新第 component 列 */
- (void)reloadComponent:(NSInteger)component;

#pragma mark - 选中 select
/** 选中 第 component 列的第 row 行*/
- (void)selectRow:(NSInteger)row
      inComponent:(NSInteger)component
         animated:(BOOL)animated;
/** 获取第 component 选中的行，-1 表示没有选中的 */
- (NSInteger)selectedRowInComponent:(NSInteger)component;

#pragma mark - UIDatePicker
/** 内部封装的 UIPickerView */
@property (nonatomic, strong) UIPickerView *picker;
/** UIPickerView 的高度，默认250.0f */
@property (nonatomic, assign) CGFloat pickerHeight;

#pragma mark - UIToolbar
/** 内部封装的 UIToolbar */
@property (nonatomic, strong) UIToolbar *toolbar;
/** 工具栏高度 默认 45 */
@property (nonatomic, assign) CGFloat toobarHeight;

#pragma mark - 左侧 "取消"
/** 设置左侧 ”取消“ 的文字，默认 ”取消“ */
- (void)setCancelText:(NSString *)text;
/**
 设置左侧 ”取消“ 的文字属性
 
 @param textColor 文字颜色
 @param font 文字字体
 */
- (void)setCancelTextColor:(nullable UIColor *)textColor
                      font:(nullable UIFont *)font;
/** 设置左侧 ”取消“ 的文字属性 */
- (void)setCancelTextAttributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes
                       forState:(UIControlState)state ;

#pragma mark - 右侧 "确定"
/** 设置右侧 ”确定“ 的文字，默认 ”确定“ */
- (void)setConfirmText:(NSString *)text;
/**
 设置右侧 ”确定“ 的文字属性
 
 @param textColor 文字颜色
 @param font 文字字体
 */
- (void)setConfirmTextColor:(nullable UIColor *)textColor
                       font:(nullable UIFont *)font;
/** 设置右侧 ”确定“ 的文字属性 */
- (void)setConfirmTextAttributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes
                        forState:(UIControlState)state;

#pragma mark - 中间 title
/** 设置中间 title 的文字，默认 nil */
- (void)setTitleText:(NSString *)text;
/**
 设置中间 title 的文字属性
 
 @param textColor 文字颜色
 @param font 文字字体
 */
- (void)setTitleTextColor:(nullable UIColor *)textColor
                     font:(nullable UIFont *)font;
/** 设置中间 title 的文字属性 */
- (void)setTitleTextAttributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes
                      forState:(UIControlState)state;

#pragma mark - Show & Dismiss
- (void)show;
- (void)dismiss;

@end


@protocol HYPickerViewDataSource<NSObject>
@required

/** 有多少列 */
- (NSInteger)hy_numberOfComponentsInPickerView:(HYPickerView *)pickerView;

/** 第 component 列有多少行 row */
- (NSInteger)hy_pickerView:(HYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end


@protocol HYPickerViewDelegate<NSObject>
@optional

/** 第 component 列的 宽度 */
- (CGFloat)hy_pickerView:(HYPickerView *)pickerView
       widthForComponent:(NSInteger)component;
/** 第 component 列的 行高 */
- (CGFloat)hy_pickerView:(HYPickerView *)pickerView
   rowHeightForComponent:(NSInteger)component;

#pragma mark - 下面的这三个方法，必须得实现一个
/** 第 component 列、第 row 行的显示的 ”文字“ */
- (nullable NSString *)hy_pickerView:(HYPickerView *)pickerView
                         titleForRow:(NSInteger)row
                        forComponent:(NSInteger)component;
///** 第 component 列、第 row 行的显示的 ”富文本“ */
//- (nullable NSAttributedString *)hy_pickerView:(HYPickerView *)pickerView
//                         attributedTitleForRow:(NSInteger)row
//                                  forComponent:(NSInteger)component;
///** 第 component 列、第 row 行的显示的 ”自定义控件“，会有重用的 view */
//- (UIView *)hy_pickerView:(HYPickerView *)pickerView
//               viewForRow:(NSInteger)row
//             forComponent:(NSInteger)component
//              reusingView:(nullable UIView *)view;

/** 选中了第 component 列、第 row 行 */
- (void)hy_pickerView:(HYPickerView *)pickerView
         didSelectRow:(NSInteger)row
          inComponent:(NSInteger)component;

/** 点击了确定 */
- (void)hy_pickerViewDidClickConfirm:(HYPickerView *)pickerView;

@end

NS_ASSUME_NONNULL_END
