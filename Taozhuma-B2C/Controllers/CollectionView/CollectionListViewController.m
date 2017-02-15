//
//  CollectionListViewController.m
//  我的收藏
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import "CollectionListViewController.h"
#import "ProductEntity.h"
#import "ProductCell.h"
#import "ProductDetailViewController.h"


@interface CollectionListViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate> {
    UIView *banner;
    CGFloat historyY;
    CGFloat recordY;
    NSInteger pageType;
    NSInteger pageno;
    NSMutableArray *_data;
    NSArray *typeArray;
    CLLocationManager *locationmanager;
    NSString* goodId;
}

@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, strong) NSString *sorting;
@property (nonatomic, strong) NSString *classify;
@property (nonatomic, strong) NSString *activity;
@property (nonatomic,retain)CLLocationManager *locationManager;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation CollectionListViewController
@synthesize _tableView;

- (void)loadView {
    [super loadView];
    self.title = @"我的收藏";
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self loadData];
    
    
    _data = [[NSMutableArray alloc]init];
    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initUI];
    [self setupHeader];
    [self setupFooter];
}

#pragma mark - 初始化UI界面

- (void)initUI {
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 1)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    _tableView.tableFooterView = tableFooterView;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ViewOrignY, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT-ViewOrignY) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _tableView.showsVerticalScrollIndicator = NO;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    //    _tableView.tableFooterView = tableFooterView;
    _tableView.sectionHeaderHeight = 42;
    _tableView.sectionFooterHeight = 10;
    
    [self setupHeader];
}

#pragma mark - 刷新

- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    [refreshHeader addToScrollView:_tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            pageno = 1;
            [self loadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    //    [refreshHeader beginRefreshing];
}
- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        pageno ++;
        [self loadData];
        [self.refreshFooter endRefreshing];
    });
}
- (void)dealloc
{
    [self.refreshHeader removeFromSuperview];
    [self.refreshFooter removeFromSuperview];
}

#pragma mark - 加载数据

//读取数据
// 获取首页列表数据
// ----------------------------------------------------------------------------------------
- (void)loadData {
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [Tools stringForKey:KEY_USER_ID],   @"userId",
                          [NSNumber numberWithInteger:pageno],@"pager",
                          nil];
    
    NSString *xpoint = @"/Api/User/showCollect?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        NSLog(@"statusMsg:%@",statusMsg);
        if ([statusMsg intValue] == 201) {
            //弹框提示获取失败
            [self showHUDText:@"暂无数据"];
            
        }else if ([statusMsg intValue] == 4001) {
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        } else {
            
            NSArray *data = [dic valueForKey:@"data"];
            NSLog(@"data:%@",data);
            
            if ([data count] > 0) {
                for (NSDictionary *productMsgList in data) {
                    ProductEntity *entity = [[ProductEntity alloc]initWithAttributes:productMsgList];
                    [_data addObject:entity];
                }
                
                NSLog(@"LIST:%@",_data);
                [_tableView reloadData];
            }
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}




#pragma mark - UIScrollView
//
//// 手指离开屏幕时通知
//-(void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
////    NSLog(@"historyY:%f",self._tableView.contentOffset.y);
//}
//
//
////scrollView滚动时通知
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    //下拉自动刷新
//    CGFloat contentOffsetY = scrollView.contentOffset.y;
//    CGFloat collectionViewY = _tableView.contentSize.height - _tableView.frame.size.height;
//    if (collectionViewY > 0 && contentOffsetY > 0) {
//        if(contentOffsetY >= (collectionViewY - 200)){
//            if (pageType == 1) {
//                pageType = 0;
//                pageno ++;
//                [self loadData];
//            }
//        }
//    }
//
//}

//scrollView滚动到顶部
//- (void)scrollToTheTop {
//    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//}
//
//// 指示当用户点击状态栏后，滚动视图是否能够滚动到顶部。
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
//    return YES;
//}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = (ProductCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ProductCell";
    ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    if ([_data count] > 0) {
        ProductEntity *entity = [_data objectAtIndex:[indexPath row]];
        
        cell.productName.text = [NSString stringWithFormat:@"%@",entity.productName];
        cell.productPrice.text = [NSString stringWithFormat:@"￥%@",entity.productPrice];
        if ([self isBlankString:entity.productImage]) {
            cell.productImage.image = [UIImage imageNamed:@"暂无图片"];
        }else{
            [cell.productImage sd_setImageWithURL:[NSURL URLWithString:entity.productImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
        }
        cell.addCart.hidden = YES;
        [cell.delCollect addTarget:self action:@selector(delCollectClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.delCollect.tag = entity.productID.intValue;
    }
    return cell;
}
//取消收藏按钮
- (IBAction)delCollectClicked:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    goodId = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消该商品"message:@"是否要取消收藏" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag=100;
    [alert show];
    
}



//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    
    ProductEntity *entity = [_data objectAtIndex:row];
    
    
    ProductDetailViewController * disheView = [[ProductDetailViewController alloc]init];
    disheView.goodId = entity.productID.intValue;
    disheView.title = @"商品详情";
    disheView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:disheView animated:YES];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  goodId,   @"goodId",
                                  [Tools stringForKey:KEY_USER_ID],  @"userId",
                                  @"move",@"mode",
                                  nil];
            
            NSString *xpoint = [NSString stringWithFormat:@"/Api/User/collectGoods?"];
            NSLog(@"dics:%@",dics);
            [HYBNetworking updateBaseUrl:SERVICE_URL];
            [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
                
                NSDictionary *dic = response;
                NSString *statusMsg = [dic valueForKey:@"status"];
                
                if ([statusMsg intValue] == 4001) {
                    //弹框提示获取失败
                    [self showHUDText:@"操作失败!"];
                    
                }else if ([statusMsg intValue] == 201){
                    [self showHUDText:@"暂无数据"];
                }else if ([statusMsg intValue] == 4002){
                    [self showHUDText:@"暂无数据"];
                }else {
                    [self showHUDText:@"操作成功"];
                    [_data removeAllObjects];
                    [self loadData];
                }
                
                
            } fail:^(NSError *error) {
                
            }];
        }
    }
    
}

//收藏与取消收藏操作
- (void)doCollectMethod {
    
    
}

@end
