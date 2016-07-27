//
//  NetworkingRespond.h
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/9.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingRespond : NSObject

@property (nonatomic, strong) id result;
@property (nonatomic, assign) int success;
@property (nonatomic, strong) NSString *error_msg;

@end
