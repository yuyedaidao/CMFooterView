//
//  CMFooterView.m
//  CMFooterView
//
//  Created by 王叶庆 on 16/7/14.
//  Copyright © 2016年 王叶庆. All rights reserved.
//

#import "CMFooterView.h"

@interface CMFooterView ()
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
                if (_textFieldPlaceholder) {
                    tf.placeholder = _textFieldPlaceholder;
                }
                if (_textFieldBackgroundImage) {
                    tf.background = _textFieldBackgroundImage;
                }
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
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_b",imageName]] forState:UIControlStateNormal];
        }
        if (title.length) {
            [button setTitle:title forState:UIControlStateNormal];
        }
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.componentArray addObject:button];
    }
}

- (void)prepareTextField {
    if (_textField) {
        [self addSubview:_textField];
        [self.componentArray addObject:_textField];
    }
}

- (void)layoutComponents {
    [self.componentArray enumerateObjectsUsingBlock:^(UIView *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.translatesAutoresizingMaskIntoConstraints = NO;
        if (idx == 0 ) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:obj attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        } else {
            UIView *lastView = self.componentArray[idx - 1];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:lastView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:obj attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        }
        [self addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        if (idx == self.componentArray.count - 1) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailingMargin multiplier:1 constant:0]];
        }
    }];
}
- (void)buttonClickAction:(UIButton *)button {
    
}


@end
