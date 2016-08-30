//
//  ClassifyModel.h
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/8/19.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifyModel : NSObject

@property (nonatomic, strong) NSString *cat_id;
@property (nonatomic, strong) NSString *cat_name;
@property (nonatomic, strong) NSString *cat_pid;

@property (nonatomic, strong) NSArray *subclass;

@property (nonatomic, strong) NSString *cat_s_name;
@property (nonatomic, strong) NSString *cat_s_id;
@property (nonatomic, strong) NSString *cat_s_pid;
@property (nonatomic, strong) NSString *cat_s_image;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
