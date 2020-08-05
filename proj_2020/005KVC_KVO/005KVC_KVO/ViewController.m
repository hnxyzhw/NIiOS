//
//  ViewController.m
//  005KVC_KVO
//
//  Created by nixs on 2020/8/4.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"---KVC/KVO---");
    [self func_003];
    
}

-(void)func_003{
    Person *p = [Person new];
    NSLog(@"%s",object_getClassName(p));
    [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    NSLog(@"%s",object_getClassName(p));
    
    [p willChangeValueForKey:@"name"];
    p.name = @"蜡笔🖍小新";
    [p didChangeValueForKey:@"name"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"---监听值变化：%@",change);
}


-(void)func_002{
    Person *p = [Person new];
    //[p setValue:@"蜡笔小新剧场版" forKey:@"name"];
    //NSLog(@"p.name:%@",[p valueForKey:@"name"]);
}

-(void)func_001{
    Person *p = [Person new];
    [p setValue:@"蜡笔小新剧场版" forKey:@"name"];
    //NSLog(@"---name:%@",p.name);
}





@end
