//
//  ProductEntity.h
//
//  Created by yusaiyan on 15/8/11.
//  Copyright (c) 2015年 lixinfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductEntity : NSObject
@property (nonatomic, strong) NSString *pID;//分类中的商品id
@property (nonatomic, strong) NSString *productID;//商品id
@property (nonatomic, strong) NSString *productName;//商品名称
@property (nonatomic, strong) NSString *productImage;//商品图片
@property (nonatomic, strong) NSString *productPrice;//商品价格

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
