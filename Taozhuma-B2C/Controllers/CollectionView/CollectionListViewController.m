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
}

@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, strong) NSString *sorting;
@property (nonatomic, strong) NSString *classify;
@property (nonatomic, strong) NSString *activity;
@property (nonatomic,retain)CLLocationManager *locationManager;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

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
    [_data removeAllObjects];
    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initUI];

    
}

#pragma mark - 初始化UI界面

- (void)initUI {
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ViewOrignY, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];

    
    _tableView.tableFooterView = tableFooterView;
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
    [refreshHeader beginRefreshing];
}

- (void)dealloc
{
    [self.refreshHeader removeFromSuperview];
}

#pragma mark - 加载数据

//读取数据
// 获取首页列表数据
// ----------------------------------------------------------------------------------------
- (void)loadData {
    [_data removeAllObjects];
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [Tools stringForKey:KEY_USER_ID],   @"userId",
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

// 手指离开屏幕时通知
-(void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"historyY:%f",self._tableView.contentOffset.y);
}


//scrollView滚动时通知
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //下拉自动刷新
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat collectionViewY = _tableView.contentSize.height - _tableView.frame.size.height;
    if (collectionViewY > 0 && contentOffsetY > 0) {
        if(contentOffsetY >= (collectionViewY - 200)){
            if (pageType == 1) {
                pageType = 0;
                pageno ++;
                [self loadData];
            }
        }
    }
    
}

//scrollView滚动到顶部
- (void)scrollToTheTop {
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

// 指示当用户点击状态栏后，滚动视图是否能够滚动到顶部。
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}

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
    UIButton *btn = (UIButton *)sender;

    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [NSString stringWithFormat: @"%ld", (long)btn.tag],   @"goodId",
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
            [_tableView reloadData];
        }
        
        
    } fail:^(NSError *error) {
        
    }];
    
}

////删除cell
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
////删除cell
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    TakeOutEntity *entitys = [_data objectAtIndex:[indexPath row]];
//    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
//                         [Tools stringForKey:KEY_USER_ID],               @"uid",
//                         @"cancel",     @"act",
//                         @"e3dc653e2d68697346818dfc0b208322",       @"key",
//                         @"1",@"type",
//                         entitys.shopId,@"val",
//                         nil];
//    NSLog(@"%@",dic);
//    NSString *xpoint = FAVXPOINT;
//    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//        if (error) {
//            [HUD removeFromSuperview];
//            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"删除失败,请稍后重试";
//            hud.yOffset = -50.f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
//        } else {
//            [HUD removeFromSuperview];
//            if (respond.result == YES) {
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"删除成功";
//                hud.yOffset = -50.f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:1];
//                
//                [_data removeObjectAtIndex:indexPath.row];
//                //去除cell
//                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            } else {
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.detailsLabelText = respond.error_msg;
//                hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
//                hud.yOffset = -50.f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:2];
//            }
//            
//        }
//    }];
//    
//}

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

//收藏与取消收藏操作
- (void)doCollectMethod {
    
    
}

@end