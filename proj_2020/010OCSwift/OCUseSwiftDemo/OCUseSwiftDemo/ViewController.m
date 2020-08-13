//
//  ViewController.m
//  OCUseSwiftDemo
//
//  Created by nixs on 2020/8/13.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "ViewController.h"
#import "OCUseSwiftDemo-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Person *p = [Person new];
    [p show];
}


@end
