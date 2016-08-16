//
//  AdvertisementEntity.h
//  MailWorldClient
//

//  Copyright © 2016年 liyoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainProductEntity : NSObject

@property (nonatomic, strong) NSString *productTypeName;//类型名称
@property (nonatomic, strong) NSMutableArray *proArray;
@property (nonatomic, strong) NSArray *productContext;

@property (nonatomic, strong) NSString *advProductId;//类型产品图片id
@property (nonatomic, strong) NSString *advProductImage;//类型产品图片

@property (nonatomic, strong) NSString *fristProductId;//第一个产品图片id
@property (nonatomic, strong) NSString *fristProductImage;//第一个产品图片
@property (nonatomic, strong) NSString *firstProductName;//第一个产品名称
@property (nonatomic, strong) NSString *firstProductPirce;//第一个产品价格

@property (nonatomic, strong) NSString *secondProductId;//第二个产品图片id
@property (nonatomic, strong) NSString *secondProductImage;//第二个产品图片
@property (nonatomic, strong) NSString *secondProductName;//第二个产品名称
@property (nonatomic, strong) NSString *secondProductPrice;//第二个产品价格

@property (nonatomic, strong) NSString *thirdProductId;//第叁个产品图片id
@property (nonatomic, strong) NSString *thirdProductImage;//第叁个产品图片
@property (nonatomic, strong) NSString *thirdProductName;//第叁个产品名称
@property (nonatomic, strong) NSString *thirdProductPrice;//第叁个产品价格

- (id)initWithAttributes:(NSDictionary *)attributes;


@end
