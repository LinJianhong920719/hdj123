//
//  MainBannerModel.h
//  Taozhuma-B2C
//
//  Created by yusaiyan on 17/1/4.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainBannerModel : NSObject

/** 标题 */
@property (strong, nonatomic) NSString *banner_title;

/** 图片 */
@property (strong, nonatomic) NSString *banner_image;

/** 简介 */
@property (strong, nonatomic) NSString *banner_intro;

/** 类型 */
@property (strong, nonatomic) NSString *banner_type;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
