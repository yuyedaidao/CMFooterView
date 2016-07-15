//
//  CMFooterView.h
//  CMFooterView
//
//  Created by 王叶庆 on 16/7/14.
//  Copyright © 2016年 王叶庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMFooterView : UIView

/**
 *  Button的图片名字，以XX_a和XX_b命名图片，
 *  传入是不需要写 “_a”和“_b”，多个名字以“,”分割开
 *  如果没有中间某个没有图片用空字符串表示
 */
@property (copy, nonatomic) IBInspectable NSString *imageNames;
/**
 *  Button的标题，多个标题以“,”分割开
 *  如果没有中间某个没有图片用空字符串表示
 */
@property (copy, nonatomic) IBInspectable NSString *titles;
/**
 *  是否显示 TextField
 */
@property (assign, nonatomic) IBInspectable BOOL showTextField;
/**
 *  TextField的高度
 */
@property (assign, nonatomic) IBInspectable CGFloat textFieldHeight;
/**
 *  TextField的placeholder
 */
@property (copy, nonatomic) IBInspectable NSString *textFieldPlaceholder;
/**
 *  TextField的背景图
 */
@property (strong, nonatomic) IBInspectable UIImage *textFieldBackgroundImage;
/**
 *  标题的平常和选中时的颜色
 */
@property (strong, nonatomic) IBInspectable UIColor *titleNormalColor;
@property (strong, nonatomic) IBInspectable UIColor *titleSelectedColor;
/**
 *  标题的字体大小
 */
@property (assign, nonatomic) IBInspectable CGFloat titleFontSize;
/**
 *  组件间的间距
 */
@property (assign, nonatomic) IBInspectable CGFloat componentSpace;


@property (copy, nonatomic) void (^didClickTextFieldBlock)(void);
@property (copy, nonatomic) void (^didClickButtonBlock)(UIButton *button);

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
@end
