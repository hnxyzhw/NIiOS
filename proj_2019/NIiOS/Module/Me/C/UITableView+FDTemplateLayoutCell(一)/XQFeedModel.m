//
//  XQFeedModel.m
//  NIiOS
//
//  Created by nixs on 2019/3/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "XQFeedModel.h"

@implementation XQFeedModel
+ (instancetype)feedWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super init]) {
        
        self.title = dictionary[@"title"];
        self.content = dictionary[@"content"];
        self.username = dictionary[@"username"];
        self.time = dictionary[@"time"];
        self.imageName = dictionary[@"imageName"];
        self.isOpening = NO;
    }
    return self;
}
@end

