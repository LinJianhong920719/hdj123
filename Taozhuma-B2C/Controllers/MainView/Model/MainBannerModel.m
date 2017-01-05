//
//  MainBannerModel.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 17/1/4.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "MainBannerModel.h"

@implementation MainBannerModel

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        self.banner_title = [dictionary valueForKey:@"title"];
        self.banner_image = [dictionary valueForKey:@"image"];
        self.banner_intro = [dictionary valueForKey:@"intro"];
        self.banner_type  = [dictionary valueForKey:@"type"];
    }
    return self;
}

@end
