//
//  GBTopLineViewModel.m
//  淘宝垂直跑马灯广告
//
//  Created by 张国兵 on 15/8/28.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "GBTopLineViewModel.h"

@implementation GBTopLineViewModel

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        self.title = [dictionary valueForKey:@"title"];
        self.image = [dictionary valueForKey:@"image"];
        self.intro = [dictionary valueForKey:@"intro"];
        self.type  = [dictionary valueForKey:@"type"];
    }
    return self;
}

@end
