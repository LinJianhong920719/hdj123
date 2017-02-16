//
//  OrderListViewController.h
//  ScrollViewVC
//
//  Created by TreeWriteMac on 16/6/21.
//  Copyright © 2016年 Raykin. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderListViewController : BaseViewController <UIScrollViewDelegate>
{
    NSArray  *_VCAry;
    NSArray  *_TitleAry;
    UIView   *_LineView;
    UIScrollView *_MeScroolView;
}
@property (nonatomic, assign) NSInteger i;

- (void)initWithAddVCARY:(NSArray*)VCS TitleS:(NSArray*)TitleS;

@end
