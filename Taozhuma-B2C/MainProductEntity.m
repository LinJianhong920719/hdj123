//
//  MainProductEntity.m
//  MailWorldClient
//
//
//  Copyright © 2016年 liyoro. All rights reserved.
//

#import "MainProductEntity.h"
#import "GoodsEntity.h"


@implementation MainProductEntity

@synthesize productTypeName;
@synthesize proArray;
@synthesize productContext;

@synthesize advProductId;//类型产品图片id
@synthesize advProductImage;//类型产品图片

@synthesize fristProductId;//第一个产品图片id
@synthesize fristProductImage;//第一个产品图片
@synthesize firstProductName;//第一个产品名称
@synthesize firstProductPirce;//第一个产品价格

@synthesize secondProductId;//第二个产品图片id
@synthesize secondProductImage;//第二个产品图片
@synthesize secondProductName;//第二个产品名称
@synthesize secondProductPrice;//第二个产品价格

@synthesize thirdProductId;//第叁个产品图片id
@synthesize thirdProductImage;//第叁个产品图片
@synthesize thirdProductName;//第叁个产品名称
@synthesize thirdProductPrice;//第叁个产品价格

@synthesize fourProductId;//第四个产品id
@synthesize fourProductImage;//第四个产品图片
@synthesize fourProductName;//第四个产品名称
@synthesize fourProductPrice;//第四个产品价格

@synthesize fiveProductId;//第五个产品id
@synthesize fiveProductImage;//第五个产品图片
@synthesize fiveProductName;//第五个产品名称
@synthesize fiveProductPrice;//第五个产品价格

@synthesize sixProductId;//第六个产品id
@synthesize sixProductImage;//第六个产品图片
@synthesize sixProductName;//第六个产品名称
@synthesize sixProductPrice;//第六个产品价格

@synthesize sevenProductId;//第七个产品id
@synthesize sevenProductImage;//第七个产品图片
@synthesize sevenProductName;//第七个产品名称
@synthesize sevenProductPrice;//第七个产品价格

@synthesize eightProductId;//第八个产品id
@synthesize eightProductImage;//第八个产品图片
@synthesize eightProductName;//第八个产品名称
@synthesize eightProductPrice;//第八个产品价格

@synthesize nineProductId;//第九个产品id
@synthesize nineProductImage;//第九个产品图片
@synthesize nineProductName;//第九个产品名称
@synthesize nineProductPrice;//第九个产品价格


- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    productTypeName = [attributes valueForKey:@"cat_name"];
    productContext = [attributes valueForKey:@"context"];
    advProductId = [attributes valueForKey:@"cat_id"];
    
    proArray = [[NSMutableArray alloc]init];
    
    advProductImage =  [attributes valueForKey:@"cat_image"];
    
    if([productContext count] == 0){
        
        fristProductId = @"";
        fristProductImage = @"";
        firstProductName = @"";
        firstProductPirce = @"";
        
        secondProductId = @"";
        secondProductImage = @"";
        secondProductName = @"";
        secondProductPrice = @"";
        
        thirdProductId = @"";
        thirdProductImage = @"";
        thirdProductName = @"";
        thirdProductPrice = @"";
        
    }
    else if([productContext count] == 1){
        
        fristProductId = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"id"];
        fristProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_image"];
        firstProductName = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_name"];
        firstProductPirce = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_price"];
        
        secondProductId = @"";
        secondProductImage = @"";
        secondProductName = @"";
        secondProductPrice = @"";
        
        thirdProductId = @"";
        thirdProductImage = @"";
        thirdProductName = @"";
        thirdProductPrice = @"";
        
        
    }
    else if([productContext count] == 2){
        
        fristProductId = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"id"];
        fristProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_image"];
        firstProductName = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_name"];
        firstProductPirce = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_price"];
        
        secondProductId = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"id"];
        secondProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_image"];
        secondProductName = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_name"];
        secondProductPrice = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_price"];
        
        thirdProductId = @"";
        thirdProductImage = @"";
        thirdProductName = @"";
        thirdProductPrice = @"";
        
    }
    else if([productContext count] == 3){
        
        fristProductId = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"id"];
        fristProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_image"];
        firstProductName = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_name"];
        firstProductPirce = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_price"];
        
        secondProductId = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"id"];
        secondProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_image"];
        secondProductName = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_name"];
        secondProductPrice = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_price"];
        
        thirdProductId = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"id"];
        thirdProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"good_image"];
        thirdProductName =[[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"good_name"];
        thirdProductPrice = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"good_price"];
        
        
    }
//    else if([productContext count] == 4){
//        
//        fristProductId = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"id"];
//        fristProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_image"];
//        firstProductName = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_name"];
//        firstProductPirce = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_price"];
//        
//        secondProductId = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"id"];
//        secondProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_image"];
//        secondProductName = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_name"];
//        secondProductPrice = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_price"];
//        
//        thirdProductId = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"id"];
//        thirdProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"good_image"];
//        thirdProductName =[[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"good_name"];
//        thirdProductPrice = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"good_price"];
//        
//        fourProductId = [[[attributes valueForKey:@"context"]objectAtIndex:3]valueForKey:@"id"];
//        fourProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:3]valueForKey:@"good_image"];
//        fourProductName =[[[attributes valueForKey:@"context"]objectAtIndex:3]valueForKey:@"good_name"];
//        fourProductPrice = [[[attributes valueForKey:@"context"]objectAtIndex:3]valueForKey:@"good_price"];
//        
//        
//    }

    
    return self;
}
@end
