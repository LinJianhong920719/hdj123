//
//  CouponsViewController.h
//  ScrollViewVC
//
//  Created by TreeWriteMac on 16/6/21.
//  Copyright © 2016年 Raykin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CouponsViewController : UIViewController<UIScrollViewDelegate>
{
    NSArray  *_VCAry;
    NSArray  *_TitleAry;
    UIView   *_LineView;
    UIScrollView *_MeScroolView;
}
- (instancetype)initWithAddVCARY:(NSArray*)VCS TitleS:(NSArray*)TitleS;



@end
