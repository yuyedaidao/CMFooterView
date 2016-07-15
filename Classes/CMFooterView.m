//
//  CMFooterView.m
//  CMFooterView
//
//  Created by 王叶庆 on 16/7/14.
//  Copyright © 2016年 王叶庆. All rights reserved.
//

#import "CMFooterView.h"

@interface CMFooterView ()<UITextFieldDelegate>
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *imageNameArray;
@property (strong, nonatomic) NSMutableArray *componentArray;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation CMFooterView

- (NSMutableArray *)componentArray {
    if (!_componentArray) {
        _componentArray = [NSMutableArray array];
    }
    return _componentArray;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)awakeFromNib {
    [self prepareTextField];
    [self prepareButtons];
    [self layoutComponents];
}

- (void)setImageNames:(NSString *)imageNames {
    if (_imageNames != imageNames) {
        _imageNames = imageNames;
        self.imageNameArray = [imageNames componentsSeparatedByString:@","];
        if (self.titleArray.count) {
            NSAssert(_titleArray.count == _imageNameArray.count, @"您提供的图片跟标题的个数不相符");
        }
    }
}
- (void)setTitles:(NSString *)titles {
    if (_titles != titles) {
        _titles = titles;
        self.titleArray = [titles componentsSeparatedByString:@","];
        if (self.imageNameArray.count) {
            NSAssert(_titleArray.count == _imageNameArray.count, @"您提供的图片跟标题的个数不相符");
        }
    }
}

- (void)setShowTextField:(BOOL)showTextField {
    if (_showTextField != showTextField) {
        _showTextField = showTextField;
        if (showTextField) {
            if (!_textField) {
                UITextField *tf = [[UITextField alloc] init];
                tf.borderStyle = UITextBorderStyleNone;
                [self.componentArray addObject:tf];
                self.textField = tf;
            }
        } else {  //应该不用处理删除操作
            if (_textField) {
                [self.componentArray removeObject:_textField];
            }
        }
    }
}

- (void)setTextFieldPlaceholder:(NSString *)textFieldPlaceholder {
    if (_textFieldPlaceholder != textFieldPlaceholder) {
        _textFieldPlaceholder = textFieldPlaceholder;
        if (_textField) {
            _textField.placeholder = textFieldPlaceholder;
        }
    }
}

- (void)setTextFieldBackgroundImage:(UIImage *)textFieldBackgroundImage {
    if (_textFieldBackgroundImage != textFieldBackgroundImage) {
        _textFieldBackgroundImage = textFieldBackgroundImage;
        if (_textField) {
            _textField.background = textFieldBackgroundImage;
        }
    }
}

- (void)prepareButtons {
    NSInteger count = MAX(self.imageNameArray.count, self.titleArray.count);
    for (int i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        NSString *imageName = self.imageNameArray.count > i ? self.imageNameArray[i] : nil;
        NSString *title = self.titleArray.count > i ? self.titleArray[i] : nil;
        if (imageName) {
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_a",imageName]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_b",imageName]] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_b",imageName]] forState:UIControlStateSelected];
        }
        if (title.length) {
            [button setTitle:title forState:UIControlStateNormal];
        }
        if (_titleFontSize > 0) {
            button.titleLabel.font = [UIFont systemFontOfSize:_titleFontSize];
        }
        [button setTitleColor:(self.titleNormalColor ? : [UIColor lightTextColor]) forState:UIControlStateNormal];
        [button setTitleColor:(self.titleSelectedColor ? : self.tintColor) forState:UIControlStateHighlighted];
        [button setTitleColor:(self.titleSelectedColor ? : self.tintColor) forState:UIControlStateSelected];
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.componentArray addObject:button];
    }
}

- (void)prepareTextField {
    if (_textField) {
        UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 10)];
        _textField.leftView = left;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.background = self.textFieldBackgroundImage;
        _textField.placeholder = self.textFieldPlaceholder;
//        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _textField.enabled = NO;
        _textField.delegate = self;
        [self addSubview:_textField];
    }
}

- (void)layoutComponents {
    [self.componentArray enumerateObjectsUsingBlock:^(UIView *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.translatesAutoresizingMaskIntoConstraints = NO;
        if (idx == 0 ) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:obj attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
            if (_textField) {
                [obj setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
                if (_textFieldHeight > 0) {
                    [obj addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_textFieldHeight]];
                }
            }
        } else {
            UIView *lastView = self.componentArray[idx - 1];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1 constant:_componentSpace]];
            if (!_textField) {//添加等宽约束，否则会导致其中一个被拉伸
                [self addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
            } else {
                if (_buttonWidth > 0) {
                    [obj addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_buttonWidth]];
                }
            }
        }
        [self addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        if (idx == self.componentArray.count - 1) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailingMargin multiplier:1 constant:0]];
        }
    }];
}
- (void)buttonClickAction:(UIButton *)button {
    if (self.didClickButtonBlock) {
        self.didClickButtonBlock(button);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.didClickTextFieldBlock) {
        self.didClickTextFieldBlock();
    }
    return NO;
}

#pragma mark subscript
- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    NSAssert(idx < self.componentArray.count, @"访问CMFooterView下标越界");
    return self.componentArray[idx];
}


@end
