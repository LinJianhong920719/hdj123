//
//  ClassifyModel.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/8/19.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "ClassifyModel.h"

@implementation ClassifyModel

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        self.cat_id     = [dictionary valueForKey:@"id"];
        self.cat_name   = [dictionary valueForKey:@"cat_name"];
        self.cat_pid    = [dictionary valueForKey:@"cat_pid"];
        self.subclass   = [dictionary valueForKey:@"l_data"];
        
        self.cat_s_name = [dictionary valueForKey:@"cat_s_name"];
        self.cat_s_id   = [dictionary valueForKey:@"cat_s_id"];
        self.cat_s_pid  = [dictionary valueForKey:@"cat_s_pid"];
        self.cat_s_image = [dictionary valueForKey:@"image"];
    }
    return self;
}

@end
