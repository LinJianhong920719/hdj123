//
//  AdvertisementEntity.h
//  MailWorldClient
//
//  Created by 陈壮龙 on 16/1/5.
//  Copyright © 2016年 liyoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertisementEntity : NSObject

@property (nonatomic, strong) NSString *images;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;

- (id)initWithAttributes:(NSDictionary *)attributes;


@end
