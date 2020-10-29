//
//  ViewController.m
//  XXSCustomKVO
//
//  Created by Admin on 2020/10/29.
//  Copyright © 2020 Admin. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "UIXXSViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.yellowColor;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.navigationController pushViewController:[UIXXSViewController new] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
}
@end
