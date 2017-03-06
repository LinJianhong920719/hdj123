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

@property (nonatomic, strong) NSString *fourProductId;//第四个产品id
@property (nonatomic, strong) NSString *fourProductImage;//第四个产品图片
@property (nonatomic, strong) NSString *fourProductName;//第四个产品名称
@property (nonatomic, strong) NSString *fourProductPrice;//第四个产品价格

@property (nonatomic, strong) NSString *fiveProductId;//第五个产品id
@property (nonatomic, strong) NSString *fiveProductImage;//第五个产品图片
@property (nonatomic, strong) NSString *fiveProductName;//第五个产品名称
@property (nonatomic, strong) NSString *fiveProductPrice;//第五个产品价格

@property (nonatomic, strong) NSString *sixProductId;//第六个产品id
@property (nonatomic, strong) NSString *sixProductImage;//第六个产品图片
@property (nonatomic, strong) NSString *sixProductName;//第六个产品名称
@property (nonatomic, strong) NSString *sixProductPrice;//第六个产品价格

@property (nonatomic, strong) NSString *sevenProductId;//第七个产品id
@property (nonatomic, strong) NSString *sevenProductImage;//第七个产品图片
@property (nonatomic, strong) NSString *sevenProductName;//第七个产品名称
@property (nonatomic, strong) NSString *sevenProductPrice;//第七个产品价格

@property (nonatomic, strong) NSString *eightProductId;//第八个产品id
@property (nonatomic, strong) NSString *eightProductImage;//第八个产品图片
@property (nonatomic, strong) NSString *eightProductName;//第八个产品名称
@property (nonatomic, strong) NSString *eightProductPrice;//第八个产品价格

@property (nonatomic, strong) NSString *nineProductId;//第九个产品id
@property (nonatomic, strong) NSString *nineProductImage;//第九个产品图片
@property (nonatomic, strong) NSString *nineProductName;//第九个产品名称
@property (nonatomic, strong) NSString *nineProductPrice;//第九个产品价格

- (id)initWithAttributes:(NSDictionary *)attributes;


@end
