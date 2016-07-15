//
//  ViewController.m
//  CMFooterView
//
//  Created by 王叶庆 on 16/7/14.
//  Copyright © 2016年 王叶庆. All rights reserved.
//

#import "ViewController.h"
#import "CMFooterView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CMFooterView *footerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [((UIButton *)self.footerView[2]) setBackgroundColor:[UIColor blueColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
