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


- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    productTypeName = [attributes valueForKey:@"cat_name"];
//    productId = [[attributes valueForKey:@"context"] valueForKey:@"id"];
    productContext = [attributes valueForKey:@"context"];

    
    proArray = [[NSMutableArray alloc]init];
//    for (NSDictionary *temList in productContext) {
//        GoodsEntity *entity = [[GoodsEntity alloc]initWithAttributes:temList];
//        [proArray addObject:entity];
//    }

    
    if([productContext count] == 0){
        advProductId = @"";
        advProductImage = @"";
        
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
        advProductId = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"id"];
        advProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_image"];
        
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
    else if([productContext count] == 2){
        advProductId = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"id"];
        advProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_image"];
        
        fristProductId = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"id"];
        fristProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_image"];
        firstProductName = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_name"];
        firstProductPirce = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_price"];
        
        secondProductId = @"";
        secondProductImage = @"";
        secondProductName = @"";
        secondProductPrice = @"";
        
        thirdProductId = @"";
        thirdProductImage = @"";
        thirdProductName = @"";
        thirdProductPrice = @"";
    }
    else if([productContext count] == 3){
        advProductId = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"id"];
        advProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_image"];
        
        fristProductId = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"id"];
        fristProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_image"];
        firstProductName = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_name"];
        firstProductPirce = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_price"];
        
        secondProductId = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"id"];
        secondProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"good_image"];
        secondProductName = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"good_name"];
        secondProductPrice = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"good_price"];
        
        thirdProductId = @"";
        thirdProductImage = @"";
        thirdProductName = @"";
        thirdProductPrice = @"";
    }
    else if([productContext count] == 4){
        advProductId = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"id"];
        advProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:0]valueForKey:@"good_image"];
        
        fristProductId = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"id"];
        fristProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_image"];
        firstProductName = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_name"];
        firstProductPirce = [[[attributes valueForKey:@"context"]objectAtIndex:1]valueForKey:@"good_price"];
        
        secondProductId = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"id"];
        secondProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"good_image"];
        secondProductName = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"good_name"];
        secondProductPrice = [[[attributes valueForKey:@"context"]objectAtIndex:2]valueForKey:@"good_price"];
        
        thirdProductId = [[[attributes valueForKey:@"context"]objectAtIndex:3]valueForKey:@"id"];
        thirdProductImage = [[[attributes valueForKey:@"context"]objectAtIndex:3]valueForKey:@"good_image"];
        thirdProductName =[[[attributes valueForKey:@"context"]objectAtIndex:3]valueForKey:@"good_name"];
        thirdProductPrice = [[[attributes valueForKey:@"context"]objectAtIndex:3]valueForKey:@"good_price"];
    }

    
    return self;
}
@end
