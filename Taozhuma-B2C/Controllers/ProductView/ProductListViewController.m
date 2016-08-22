////
////  ProductListViewController.m
////
////  Created by yusaiyan on 15/8/11.
////  Copyright (c) 2015年 lixinfan. All rights reserved.
////
//
//#import "ProductListViewController.h"
//#import "ProductCell.h"
//#import "ProductEntity.h"
//
//#define Reality_viewHeight ScreenHeight-ViewOrignY-40-50
//#define Reality_viewWidth ScreenWidth
//
//@interface ProductListViewController () <UITableViewDataSource,UITableViewDelegate>{
//    UIImageView *secondImage;
//    UIImageView *thirdImage;
//    UIImageView *firstImage;
//    NSString *tagOrder;
//}
//
//@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
//@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
//@property (nonatomic, strong) NSMutableArray* data;
//@property (nonatomic, assign) NSInteger pageno;
//@property (nonatomic, assign) NSInteger sort;
//@end
//
//@implementation ProductListViewController
//@synthesize mTableView = _mTableView;
//@synthesize data = _data;
//@synthesize pageno = _pageno;
//@synthesize sort = _sort;
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self hideNaviBar:YES];
//    [self initUI];
//    [self loadData];
//    [self setupHeader];
//    [self setupFooter];
//    _sort = 1;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - 初始化UI
//
//- (void)initUI {
//    
//    _data = [[NSMutableArray alloc]init];
//    
//    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, Reality_viewWidth, Reality_viewHeight-30) style:UITableViewStylePlain];
//    _mTableView.delegate = self;
//    _mTableView.dataSource = self;
//    _mTableView.scrollsToTop = YES;
//    _mTableView.backgroundColor = self.view.backgroundColor;
//    _mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    [self.view addSubview:_mTableView];
//    
//    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Reality_viewWidth, 1)];
//    [tableFooterView setBackgroundColor:[UIColor clearColor]];
//    _mTableView.tableFooterView = tableFooterView;
//    
//    [self loadData];
//    //筛选View
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Reality_viewWidth, 30)];
//    view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:view];
//    //分割线
//    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, Reality_viewWidth, 1)];
//    line.backgroundColor = [UIColor colorWithRed:238/255.0f green:239/255.0f blue:239/255.0f alpha:1];
//    [self.view addSubview:line];
//    
//    
//    //第一个view
//    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, Reality_viewWidth/3, 30)];
//    firstImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 15, 15)];
//    [firstImage setImage:[UIImage imageNamed:@"wm-085"]];
//    [firstView addSubview:firstImage];
//    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(firstImage)+5, 5, firstView.frame.size.width-firstImage.frame.size.width-20, 20)];
//    firstLabel.text = @"下单时间↑↓";
//    firstLabel.font = [UIFont systemFontOfSize:10];
//    [firstView addSubview:firstLabel];
//
//    [view addSubview:firstView];
//    
//    UIButton *firstButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Reality_viewWidth/3, 30)];
//    firstButton.tag = 1001;
//    [firstButton addTarget:self action:@selector(dragInside:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:firstButton];
//    
//    //第二个view
//    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(Reality_viewWidth/3+10, 0, Reality_viewWidth/3, 30)];
//    secondImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 15, 15)];
//    [secondImage setImage:[UIImage imageNamed:@"wm-086"]];
//    [secondView addSubview:secondImage];
//    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(secondImage)+5, 5, secondView.frame.size.width-secondImage.frame.size.width-20, 20)];
//    secondLabel.text = @"距离↑↓";
//    secondLabel.font = [UIFont systemFontOfSize:10];
//    [secondView addSubview:secondLabel];
//    
//    [view addSubview:secondView];
//    
//    UIButton *secondButton = [[UIButton alloc]initWithFrame:CGRectMake(Reality_viewWidth/3+10, 0, Reality_viewWidth/3, 30)];
//    secondButton.tag = 1002;
//    [secondButton addTarget:self action:@selector(dragInside:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:secondButton];
//    
//    
//    //第三个view
//    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(Reality_viewWidth/3*2+10, 0, Reality_viewWidth/3, 30)];
//    thirdImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 15, 15)];
//    [thirdImage setImage:[UIImage imageNamed:@"wm-086"]];
//    [thirdView addSubview:thirdImage];
//    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(thirdImage)+5, 5, thirdView.frame.size.width-thirdImage.frame.size.width-20, 20)];
//    thirdLabel.text = @"送达时间↑↓";
//    thirdLabel.font = [UIFont systemFontOfSize:10];
//    [thirdView addSubview:thirdLabel];
//    
//    [view addSubview:thirdView];
//    
//    UIButton *thirdButton = [[UIButton alloc]initWithFrame:CGRectMake(Reality_viewWidth/3*2+10, 0, Reality_viewWidth/3, 30)];
//    thirdButton.tag = 1003;
//    [thirdButton addTarget:self action:@selector(dragInside:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:thirdButton];
//    
//    
//}
//
////按钮点击方法
//-(IBAction)dragInside:(id)sender {
//    
//    UIButton *btn = (UIButton *)sender;
//    if (btn.tag == 1001) {
//        NSLog(@"_sort:%ld",(long)_sort);
//        [firstImage setImage:[UIImage imageNamed:@"wm-085"]];
//        [secondImage setImage:[UIImage imageNamed:@"wm-086"]];
//        [thirdImage setImage:[UIImage imageNamed:@"wm-086"]];
//        if(_sort == 1){
//            _sort = 2;
//            _pageno = 0;
//        }else if(_sort == 2){
//            _sort = 1;
//            _pageno = 0;
//        }else{
//            _sort = 1;
//        }
//        [self loadData];
//    }
//    else if (btn.tag == 1002) {
//         NSLog(@"_sort:%ld",(long)_sort);
//        [firstImage setImage:[UIImage imageNamed:@"wm-086"]];
//        [secondImage setImage:[UIImage imageNamed:@"wm-085"]];
//        [thirdImage setImage:[UIImage imageNamed:@"wm-086"]];
//        if(_sort == 3){
//            _sort = 4;
//            _pageno = 0;
//        }else if(_sort == 4){
//            _sort = 3;
//            _pageno = 0;
//        }else{
//            _sort = 3;
//            
//        }
//            
//        [self loadData];
//    }
//    else if (btn.tag == 1003) {
//         NSLog(@"_sort:%ld",(long)_sort);
//        [firstImage setImage:[UIImage imageNamed:@"wm-086"]];
//        [secondImage setImage:[UIImage imageNamed:@"wm-086"]];
//        [thirdImage setImage:[UIImage imageNamed:@"wm-085"]];
//        if(_sort == 5){
//            _sort = 6;
//            _pageno = 0;
//        }else if(_sort == 6){
//            _sort = 5;
//            _pageno = 0;
//        }else{
//            _sort = 5;
//           
//        }
//        [self loadData];
//
//    }
//    
//}
//
//#pragma mark - 加载数据
//
//- (void)loadData {
//    
////    if (_sort == 0) {
////        _sort = 1;
////    }
//    
//    if (_pageno == 0) {
//        _pageno = 1;
//    }
//    NSLog(@"KEY_STORE_ID:%@",[Tools stringForKey:KEY_STORE_ID]);
//    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
//                          @"e3dc653e2d68697346818dfc0b208322",      @"key",
//                          @"get_new_list",                           @"act",
//                          [Tools stringForKey:KEY_STORE_ID],        @"sid",
//                          [NSNumber numberWithInteger:_sort],       @"sort",
//                          [NSNumber numberWithInteger:_pageno],     @"page",
//                          nil];
//    NSString *xpoint = ORDERXPOINT;
//    NSLog(@"dics:%@",dics);
//    [MailWorldRequest requestWithParams:dics xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//        if (error) {
//        } else {
//            
//            if (respond.respondArray > 0) {
//                
//                if (_pageno == 1) {
//                    [_data removeAllObjects];
//                }
//                
//                for (NSDictionary *dic in respond.respondArray) {
//                    OrderEntity *entity = [[OrderEntity alloc]initWithAttributes:dic];
//                    [_data addObject:entity];
//                }
//                
//                [_mTableView reloadData];
//            } else {
//                
//                ProgressHUD *hud = [[ProgressHUD alloc]init];
//                [hud afterDelay:1];
//                
//                if (_pageno > 1) {
//                    [hud showError:@"没有更多"];
//                }
//                
//            }
//        }
//    }];
//}
//
//#pragma mark - SDRefresh
//
//- (void)setupHeader
//{
//    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
//    
//    [refreshHeader addToScrollView:_mTableView];
//    
//    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
//    refreshHeader.beginRefreshingOperation = ^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            _pageno = 1;
//            [self loadData];
//            [_mTableView reloadData];
//            [weakRefreshHeader endRefreshing];
//        });
//    };
//    
//    // 进入页面自动加载一次数据
//    [refreshHeader beginRefreshing];
//}
//-(void)refeshOrder{
//    _pageno = 1;
//    [self loadData];
//}
//
//- (void)setupFooter
//{
//    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
//    [refreshFooter addToScrollView:_mTableView];
//    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
//    _refreshFooter = refreshFooter;
//}
//
//- (void)footerRefresh
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _pageno ++;
//        [self loadData];
//        [self.refreshFooter endRefreshing];
//    });
//}
//
//- (void)dealloc
//{
//    [self.refreshHeader removeFromSuperview];
//    [self.refreshFooter removeFromSuperview];
//}
//
//#pragma mark - UITableView
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NewOrderCell *cell = (NewOrderCell *)[self tableView:_mTableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _data.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"NewOrderCell";
//    NewOrderCell *cell = (NewOrderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewOrderCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
//    
//    if ([_data count] > 0) {
//        OrderEntity *entity = [_data objectAtIndex:[indexPath row]];
//        
//        cell.orderTitle.text = [NSString stringWithFormat:@"%@",entity.order_snID];
//        cell.orderTime.text = [NSString stringWithFormat:@"%@",entity.add_time];
//        
//        cell.orderPrice.text = [NSString stringWithFormat:@"¥%@",entity.all_price];
//         CGSize priceSize = [cell.orderPrice.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.orderPrice.font} context:nil].size;
//
//        cell.orderPrice.frame = CGRectMake(Reality_viewWidth-priceSize.width-15, cell.orderPrice.frame.origin.y, priceSize.width + 10, 30);
//        cell.orderPrice.textColor = PROJECT_COLORS;
//        
//        cell.orderNum.text = [NSString stringWithFormat:@"%@份/",entity.all_number];
//         CGSize numeSize = [cell.orderNum.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.orderNum.font} context:nil].size;
//        cell.orderNum.frame = CGRectMake(cell.orderPrice.frame.origin.x-numeSize.width, cell.orderNum.frame.origin.y, numeSize.width + 10, 30);
//        
//        cell.confirmBtn.tag = [entity.orderID integerValue];
////        [cell.confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
////        cell.confirmBtn.layer.borderWidth = 1;
//        [cell.confirmBtn setTitle:@"未处理" forState:UIControlStateNormal];
//        [cell.confirmBtn setTitleColor:PROJECT_COLORS forState:UIControlStateNormal];
//        cell.confirmBtn.enabled = NO;
//        cell.confirmBtn.layer.borderColor = [PROJECT_COLORS CGColor];
//        
////        cell.refuseBtn.tag = [entity.orderID integerVa lue];
////        [cell.refuseBtn addTarget:self action:@selector(refuseClick:) forControlEvents:UIControlEventTouchUpInside];
////        cell.refuseBtn.layer.borderWidth = 1;
////        cell.refuseBtn.layer.borderColor = [[UIColor redColor] CGColor];
//    }
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    OrderEntity *entity = [_data objectAtIndex:[indexPath row]];
//    
//    OrderDetailsViewController *detailsView = [[OrderDetailsViewController alloc]init];
//    detailsView.orderID = entity.orderID;
//    detailsView.title = @"订单详情";
//    detailsView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailsView animated:YES];
//    
//    [_mTableView deselectRowAtIndexPath:indexPath animated:YES];
//}
/////** 拒绝订单 */
////- (IBAction)refuseClick:(id)sender {
////    UIButton *btn = (UIButton *)sender;
////    //    OrderEntity *entity = [_data objectAtIndex:btn.tag];
////    tagOrder = @"1";
////    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否拒绝订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拒绝", nil];
////    alert.tag = btn.tag;
////    [alert show];
////}
/////** 确认发货 */
////- (IBAction)confirmClick:(id)sender {
////    UIButton *btn = (UIButton *)sender;
//////    OrderEntity *entity = [_data objectAtIndex:btn.tag];
////    tagOrder = @"2";
////    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否确认送餐" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"送餐", nil];
////    alert.tag = btn.tag;
////    [alert show];
////}
//
////- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
////    if([tagOrder isEqualToString:@"1"]) {
////        /*
////         此处写拒绝订单接口代码
////         */
////        
////        if (buttonIndex == 1) {
////
////            NSString *orderId = [NSString stringWithFormat:@"%ld",(long)alertView.tag];
////            
////            NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
////                                  @"e3dc653e2d68697346818dfc0b208322",           @"key",
////                                  @"edit",                                         @"act",
////                                  [Tools stringForKey:KEY_STORE_ID],              @"sid",
////                                  orderId,                                          @"oid",
////                                  @"4",                                             @"status",
////                                  nil];
////            NSString *xpoint = @"order.php?";
////            
////            [MailWorldRequest requestWithParams:dics xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
////                if (error) {
////                } else {
////                    ProgressHUD *hud = [[ProgressHUD alloc]init];
////                    [hud afterDelay:1];
////                    
////                    if (respond.result == 1) {
////                        [hud showSuccess:respond.error_msg];
////                        [_data removeAllObjects];
////                        [_mTableView reloadData];
////                        _pageno = 1;
////                        [self loadData];
////                        
////                        
////                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDeliveryOrder" object:nil];
////                    } else {
////                        [hud showError:respond.error_msg];
////                    }
////                }
////            }];
////            
////        }
////        NSLog(@"拒绝订单");
////    }else if([tagOrder isEqualToString:@"2"]) {
////        if (buttonIndex == 1) {
////            
////            //        OrderEntity *entity = [_data objectAtIndex:alertView.tag];
////            NSString *orderId = [NSString stringWithFormat:@"%ld",(long)alertView.tag];
////            
////            NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
////                                  @"e3dc653e2d68697346818dfc0b208322",           @"key",
////                                  @"edit",                                         @"act",
////                                  [Tools stringForKey:KEY_STORE_ID],              @"sid",
////                                  orderId,                                          @"oid",
////                                  @"2",                                             @"status",
////                                  nil];
////            NSString *xpoint = @"order.php?";
////            
////            [MailWorldRequest requestWithParams:dics xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
////                if (error) {
////                } else {
////                    ProgressHUD *hud = [[ProgressHUD alloc]init];
////                    [hud afterDelay:1];
////                    
////                    if (respond.result == 1) {
////                        [hud showSuccess:respond.error_msg];
////                        
////                        //                    [_data removeObjectAtIndex:alertView.tag];
////                        //                    [_mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
////                        [_data removeAllObjects];
////                        [_mTableView reloadData];
////                        _pageno = 1;
////                        [self loadData];
////                        
////                        
////                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDeliveryOrder" object:nil];
////                    } else {
////                        [hud showError:respond.error_msg];
////                    }
////                }
////            }];
////            
////        }
////
////    }
////}
//
//@end
