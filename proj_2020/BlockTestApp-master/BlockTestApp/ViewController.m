//
//  ViewController.m
//  BlockTestApp
//
//  Created by ChenMan on 2018/4/23.
//  Copyright © 2018年 cimain. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "TestCycleRetain.h"
#import "CaculateMaker.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self testTestCycleRetain];
    //[self func_004];
    CaculateMaker *caculaterMaker = [[CaculateMaker alloc] init];
    
    NSLog(@"---计算结果：%.2lf",caculaterMaker.add(23).add(18).result);
}
//block作为返回值
//-(return_type(^)(var_type))methodName{
//    return ^return_type(var_type parm){
//
//    };
//}

-(void)func_005{
    //block作为返回值
    
    
}
//- (MASConstraint * (^)(id))equalTo {
//    return ^id(id attribute) {
//        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
//    };
//}
//
//- (MASConstraint * (^)(id, NSLayoutRelation))equalToWithRelation {
//    return ^id(id attribute, NSLayoutRelation relation) {
//        if ([attribute isKindOfClass:NSArray.class]) {
//            NSAssert(!self.hasLayoutRelation, @"Redefinition of constraint relation");
//            NSMutableArray *children = NSMutableArray.new;
//            for (id attr in attribute) {
//                MASViewConstraint *viewConstraint = [self copy];
//                viewConstraint.secondViewAttribute = attr;
//                [children addObject:viewConstraint];
//            }
//            MASCompositeConstraint *compositeConstraint = [[MASCompositeConstraint alloc] initWithChildren:children];
//            compositeConstraint.delegate = self.delegate;
//            [self.delegate constraint:self shouldBeReplacedWithConstraint:compositeConstraint];
//            return compositeConstraint;
//        } else {
//            NSAssert(!self.hasLayoutRelation || self.layoutRelation == relation && [attribute isKindOfClass:NSValue.class], @"Redefinition of constraint relation");
//            self.layoutRelation = relation;
//            self.secondViewAttribute = attribute;
//            return self;
//        }
//    };
//}


-(void)func_004{
//    return_type(^blockName)(var_type) = ^return_type(var_type varName){
//
//    };
    void(^globalBlockInMemory)(int number) = ^(int number){
        printf("---%d\n",number);
    };
    globalBlockInMemory(10);
}

-(void)func_003{
    /**
     约定：用法中的符号含义列举如下：

     return_type 表示返回的对象/关键字等(可以是void，并省略)
     blockName 表示block的名称
     var_type 表示参数的类型(可以是void，并省略)
     varName 表示参数名称
     
     //标准声明与定义
     return_type (^blockName)(var_type) = ^return_type(var_type varName){
         
     };
     blockName(var);
            
     //当返回类型为void 可省略
     return_type(^blockName)(var_type) = ^void(var_type varName){
         
     };
     return_type(^blockName)(var_type) = ^(var_type varName){
         
     };
     //当参数类型为void
     return_type(^blockName)(void) = ^return_type(void){
         
     };
     
     return_type(^blockName)(void) = ^return_type{
         
     };
     //当返回类型和参数都为void
     return_type(^blockName)(var_type) = ^return_type(var_type varName){
         
     };
     void(^blockName)(void) = ^void(void){
         
     };
     void(^blockName)(void) = ^{
         
     };
     //匿名block
     ^return_type(var_type varName){
         
     };
     */
    
    //typedef return_type (^blockName)(var_type);
    
}

-(void)func_002{
    __block int val = 10;
    void (^blk)(void) = ^{
        printf("val = %d\n",val);
    };
    val = 2;
    blk();
}

-(void)func_001{
    int val = 10;
    void (^blk)(void) = ^{
        printf("val = %d\n",val);
    };
    val = 2;
    blk();
}

#pragma mark - testBlockForHeapOfARC
-(void)testBlockForHeapOfARC{
    int val =10;
    typedef void (^blk_t)(void);
    blk_t block = ^{
        NSLog(@"blk0:%d",val);
    };
    block();
}

#pragma mark - testBlockForHeap0 - crash
-(NSArray *)getBlockArray0{
    int val =10;
    return [NSArray arrayWithObjects:
            ^{NSLog(@"blk0:%d",val);},
            ^{NSLog(@"blk1:%d",val);},nil];
}


-(void)testBlockForHeap0{
    
    NSArray *tempArr = [self getBlockArray0];
    NSMutableArray *obj = [tempArr mutableCopy];
    typedef void (^blk_t)(void);
    blk_t block = (blk_t){[obj objectAtIndex:0]};
    block();
}


#pragma mark - testBlockForHeap1
-(void)testBlockForHeap1{
    
    NSArray *tempArr = [self getBlockArray1];
    NSMutableArray *obj = [tempArr mutableCopy];
    typedef void (^blk_t)(void);
    blk_t block = (blk_t){[obj objectAtIndex:0]};
    block();
}

-(NSArray *)getBlockArray1{
    int val =10;
    return [NSArray arrayWithObjects:
            [^{NSLog(@"blk0:%d",val);} copy],
            [^{NSLog(@"blk1:%d",val);} copy],nil];
}

#pragma mark - testBlockForHeap2
- (void)testBlockForHeap2{
    
    NSMutableArray *array = [NSMutableArray array];
    [self addBlockToArray:array];
    typedef void (^blk_t)(void);
    blk_t block = (blk_t){[array objectAtIndex:0]};
    block();
}

- (void)addBlockToArray:(NSMutableArray *)array {

    int val =10;
    [array addObjectsFromArray:@[
         ^{NSLog(@"blk0:%d",val);},
         ^{NSLog(@"blk1:%d",val);}]];
}

#pragma mark - testTestCycleRetain
- (void)testTestCycleRetain{
    TestCycleRetain * obj = [[TestCycleRetain alloc] init];
    obj.myblock();
    obj = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
