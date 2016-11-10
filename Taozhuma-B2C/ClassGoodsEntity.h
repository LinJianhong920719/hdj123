//
//  ClassGoodsEntity.h
//  商品大分类entity
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassGoodsEntity : NSObject

@property (nonatomic, strong) NSString *catId;
@property (nonatomic, strong) NSString *catName;
@property (nonatomic, strong) NSString *catPid;
@property (nonatomic, strong) NSString *catImage;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
