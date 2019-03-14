//
//  RunTimePerson.h
//  NIiOS
//
//  Created by nixs on 2019/2/26.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RunTimePerson : NSObject
 //------1.动态方法解析(Dynamic Method Resolution)------
/**
 声明类方法,但未实现
 */
+(void)haveMeal:(NSString*)food;

/**
 声明实例方法,但未实现
 */
-(void)singSong:(NSString*)name;



//------2.消息接收者重定向------

/**
 类方法：参加考试
 */
+(void)takeExam:(NSString*)exam;

/**
 实例方法：学习知识
 */
-(void)learnKnowledge:(NSString*)course;

@end

