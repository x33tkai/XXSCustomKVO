//
//  UIXXSViewController.m
//  XXSCustomKVO
//
//  Created by Admin on 2020/10/29.
//  Copyright © 2020 Admin. All rights reserved.
//

#import "UIXXSViewController.h"
#import "Person.h"
#import "NSObject+XXSKVO.h"
@interface UIXXSViewController ()
@property(nonatomic,strong) Person *person;
@end

@implementation UIXXSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blueColor;
    // Do any additional setup after loading the view.
    self.person = [[Person alloc] init];
    self.person.name = @"xxxxss";
    [self.person xxs_addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:NULL block:^(id  _Nonnull observer, NSString * _Nonnull keyPath, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"--%@", newValue);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person.name = [NSString stringWithFormat:@"%@+", self.person.name];
}


- (void)dealloc
{
    NSLog(@"vc dealloc --");
}
@end
