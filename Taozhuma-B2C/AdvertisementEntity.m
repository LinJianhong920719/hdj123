//
//  AdvertisementEntity.m
//  MailWorldClient
//
//  Created by 陈壮龙 on 16/1/5.
//  Copyright © 2016年 liyoro. All rights reserved.
//

#import "AdvertisementEntity.h"


@implementation AdvertisementEntity

@synthesize images;
@synthesize url;
@synthesize title;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    images = [attributes valueForKey:@"images"];
    url = [attributes valueForKey:@"url"];
    title = [attributes valueForKey:@"title"];
    return self;
}
@end
