//
//  HYPickerView.m
//  StudyPickerView
//
//  Created by ocean on 2019/3/21.
//  Copyright © 2019 ocean. All rights reserved.
//

#import "HYPickerView.h"

@interface HYPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *leftSpaceItem;
@property (nonatomic, strong) UIBarButtonItem *cancelItem;
@property (nonatomic, strong) UIBarButtonItem *titleLeftSpaceItem;
@property (nonatomic, strong) UIBarButtonItem *titleItem;
@property (nonatomic, strong) UIBarButtonItem *titleRightSpaceItem;
@property (nonatomic, strong) UIBarButtonItem *confirmItem;
@property (nonatomic, strong) UIBarButtonItem *rightSpaceItem;
@property (nonatomic, assign) CGFloat spacing;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) NSLayoutConstraint *pickerBottomLC;

@end

@implementation HYPickerView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pickerHeight = 250.0f;
        _toobarHeight = 45.0f;
        _duration = 0.25;
        _spacing = 20.0f;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDidClick)];
        [self addGestureRecognizer:tapGesture];
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.picker];
    [self addSubview:self.toolbar];
    
    [self.toolbar setItems:@[self.leftSpaceItem,
                             self.cancelItem,
                             self.titleLeftSpaceItem,
                             self.titleItem,
                             self.titleRightSpaceItem,
                             self.confirmItem,
                             self.rightSpaceItem]];
}

#pragma mark - Layout

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.picker attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.picker attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    self.pickerBottomLC = [NSLayoutConstraint constraintWithItem:self.picker attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:self.pickerBottomLC];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.picker attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.pickerHeight]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.picker attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.toobarHeight]];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - setter

- (void)setCancelText:(NSString *)text {
    self.cancelItem.title = [text copy];
}

- (void)setConfirmText:(NSString *)text {
    self.confirmItem.title = [text copy];
}

- (void)setTitleText:(NSString *)text {
    self.titleItem.title = [text copy];
}

- (void)setCancelTextColor:(UIColor *)textColor
                      font:(UIFont *)font {
    NSDictionary *attributes = [self _getAttributesWithTextColor:textColor font:font];
    [self setCancelTextAttributes:attributes forState:UIControlStateNormal];
    [self setCancelTextAttributes:attributes forState:UIControlStateHighlighted];
}

- (void)setConfirmTextColor:(UIColor *)textColor
                       font:(UIFont *)font {
    NSDictionary *attributes = [self _getAttributesWithTextColor:textColor font:font];
    [self setConfirmTextAttributes:attributes forState:UIControlStateNormal];
    [self setConfirmTextAttributes:attributes forState:UIControlStateHighlighted];
}

- (void)setTitleTextColor:(UIColor *)textColor
                     font:(UIFont *)font {
    NSDictionary *attributes = [self _getAttributesWithTextColor:textColor font:font];
    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
}

- (void)setCancelTextAttributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes forState:(UIControlState)state {
    [self.cancelItem setTitleTextAttributes:attributes forState:state];
}

- (void)setConfirmTextAttributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes forState:(UIControlState)state {
    [self.confirmItem setTitleTextAttributes:attributes forState:state];
}

- (void)setTitleTextAttributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes forState:(UIControlState)state {
    [self.titleItem setTitleTextAttributes:attributes forState:state];
}


#pragma mark - Private

- (NSDictionary *)_getAttributesWithTextColor:(UIColor *)textColor
                                         font:(UIFont *)font {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (textColor) {
        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    }
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    return [attributes copy];
}

#pragma mark - Events

- (void)confirmDidClick {
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hy_pickerViewDidClickConfirm:)]) {
        [self.delegate hy_pickerViewDidClickConfirm:self];
    }
}

- (void)cancelDidClick {
    [self dismiss];
}

- (void)tapGestureDidClick {
    [self dismiss];
}

#pragma mark - show / dismiss

- (void)show {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    CGRect frame = keyWindow.bounds;
    frame.origin.y += frame.size.height;
    self.frame = frame;
    // frame 动画
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = keyWindow.bounds;
    } completion:^(BOOL finished) {
        
    }];
    // backgroundColor 动画；延时执行，避免突兀，不会显示“self黑框”上移动画
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:self.duration delay:self.duration - 0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    // 约束动画
    self.pickerBottomLC.constant += self.pickerHeight + self.toobarHeight;
    [UIView animateWithDuration:self.duration delay:0  options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(hy_numberOfComponentsInPickerView:)]) {
        return [self.dataSource hy_numberOfComponentsInPickerView:self];
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(hy_pickerView:numberOfRowsInComponent:)]) {
        return [self.dataSource hy_pickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hy_pickerView:widthForComponent:)]) {
        return [self.delegate hy_pickerView:self widthForComponent:component];
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hy_pickerView:rowHeightForComponent:)]) {
        return [self.delegate hy_pickerView:self rowHeightForComponent:component];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hy_pickerView:titleForRow:forComponent:)]) {
        return [self.delegate hy_pickerView:self titleForRow:row forComponent:component];
    }
    return nil;
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(hy_pickerView:attributedTitleForRow:forComponent:)]) {
//        return [self.delegate hy_pickerView:self attributedTitleForRow:row forComponent:component];
//    }
//    return nil;
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(hy_pickerView:viewForRow:forComponent:reusingView:)]) {
//        return [self.delegate hy_pickerView:self viewForRow:row forComponent:component reusingView:view];
//    }
//    return nil;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hy_pickerView:didSelectRow:inComponent:)]) {
        [self.delegate hy_pickerView:self didSelectRow:row inComponent:component];
    }
}

#pragma mark - UIPickerView
- (NSInteger)numberOfComponents {
    return self.picker.numberOfComponents;
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    return [self.picker numberOfRowsInComponent:component];
}

- (CGSize)rowSizeForComponent:(NSInteger)component {
    return [self.picker rowSizeForComponent:component];
}

- (UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.picker viewForRow:row forComponent:component];
}

- (void)reloadAllComponents {
    [self.picker reloadAllComponents];
}

- (void)reloadComponent:(NSInteger)component {
    [self.picker reloadComponent:component];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    [self.picker selectRow:row inComponent:component animated:animated];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    return [self.picker selectedRowInComponent:component];
}

#pragma mark - Lazy

- (UIPickerView *)picker {
    if (!_picker) {
        _picker = [[UIPickerView alloc] init];
        _picker.dataSource = self;
        _picker.delegate = self;
        _picker.translatesAutoresizingMaskIntoConstraints = NO;
        _picker.backgroundColor = [UIColor whiteColor];
    }
    return _picker;
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _toolbar;
}

- (UIBarButtonItem *)cancelItem {
    if (!_cancelItem) {
        _cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelDidClick)];
    }
    return _cancelItem;
}

- (UIBarButtonItem *)confirmItem {
    if (!_confirmItem) {
        _confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmDidClick)];
    }
    return _confirmItem;
}

- (UIBarButtonItem *)leftSpaceItem {
    if (!_leftSpaceItem) {
        _leftSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        _leftSpaceItem.width = self.spacing;
    }
    return _leftSpaceItem;
}

- (UIBarButtonItem *)rightSpaceItem {
    if (!_rightSpaceItem) {
        _rightSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        _rightSpaceItem.width = self.spacing;
    }
    return _rightSpaceItem;
}

- (UIBarButtonItem *)titleItem {
    if (!_titleItem) {
        _titleItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return _titleItem;
}

- (UIBarButtonItem *)titleLeftSpaceItem {
    if (!_titleLeftSpaceItem) {
        _titleLeftSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return _titleLeftSpaceItem;
}

- (UIBarButtonItem *)titleRightSpaceItem {
    if (!_titleRightSpaceItem) {
        _titleRightSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return _titleRightSpaceItem;
}


@end
