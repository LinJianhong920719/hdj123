//
//  MainViewController.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/12.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "MainViewController.h"
#import "CustomNaviBarSearchController.h"
#import "ViewController.h"
#import "WHCircleImageView.h"
#import "MainViewCell.h"
#import "MainProductEntity.h"
#import "SearchViewController.h"

#define tableViewFrame2     CGRectMake(0, ViewOrignY, ScreenWidth, ScreenHeight-ViewOrignY-50)

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>{
     UIScrollView * adverView;
     UIPageControl * pageControl;
     UIView *topView;
    CGFloat     scrollViewBeginDraggingY;    //记录开始拖拽时的 scrollView.contentOffset.y
    CGFloat     scrollViewEndDraggingY;     //记录完成拖拽时的 scrollView.contentOffset.y
    BOOL GTTabBar_Current;      //GTTabBar是否当前选中的
    BOOL SCNavTabBar_Current;   //SCNavTabBar是否当前选中的
    NSInteger   currentItemIndex;
    NSMutableArray *pictureUrlArray;
    NSString *communityId;//小区id
    NSString *communityName;//小区名称
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,weak) NSTimer * timer;
@property (nonatomic,strong) NSMutableArray * adverData;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //通知 接收
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadIndexData) name:@"loadTableMsg"object:nil];
    //隐藏导航栏
    [self hideNaviBar:YES];
    
    [self loadIndexAddressMsg];
    GTTabBar_Current = YES;
    SCNavTabBar_Current = YES;
    
    _data = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTopNav{
    //自定义导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    topView.backgroundColor = BACK_DEFAULT;
    //定位
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH/3, 40)];
    addressView.backgroundColor = [UIColor clearColor];
    [topView addSubview:addressView];
    //定位image
    UIImageView *_loactionImageView = [[UIImageView alloc]init];
    [_loactionImageView setFrame:CGRectMake(14, 33, 10, 14)];
    [_loactionImageView setImage:[UIImage imageNamed:@"address"]];
    [addressView addSubview:_loactionImageView];
    
    //定位message
    UILabel *_loactionLabel = [[UILabel alloc]init];
    _loactionLabel.font = [UIFont systemFontOfSize:16];
    _loactionLabel.textColor = FONTS_COLOR51;
    if(communityName != nil){
     _loactionLabel.text = communityName;
    }else{
        _loactionLabel.text = @"定位中";
    }
        
    
    //根据lable的长度定义实际宽高
    CGSize labelSize = [_loactionLabel.text sizeWithFont:_loactionLabel.font
                                       constrainedToSize:CGSizeMake(FLT_MAX,FLT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
    [_loactionLabel setFrame:CGRectMake(viewRight(_loactionImageView)+5, 30, labelSize.width, labelSize.height)];
    [addressView addSubview:_loactionLabel];
    //定位image
    UIImageView *_loactionImageView1 = [[UIImageView alloc]init];
    [_loactionImageView1 setFrame:CGRectMake(viewRight(_loactionLabel)+5, 36, 8, 4)];
    [_loactionImageView1 setImage:[UIImage imageNamed:@"drop-down"]];
    [addressView addSubview:_loactionImageView1];
    
    
    //搜索
    UIImageView *_serachImage = [[UIImageView alloc]init];
    [_serachImage setFrame:CGRectMake(viewRight(addressView)+45, 28, DEVICE_SCREEN_SIZE_WIDTH-addressView.frame.size.width-50, 28)];
    NSLog(@"111:%f",DEVICE_SCREEN_SIZE_WIDTH/320);
    [_serachImage setImage:[UIImage imageNamed:@"search"]];
    _serachImage.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [_serachImage addGestureRecognizer:singleTap];
    [topView addSubview:_serachImage];
    
    [self.view addSubview:topView];
    [self.view bringSubviewToFront:topView];
}

- (void)initTableView {
    NSLog(@"ss:%lu",(unsigned long)[_data count]);
    
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
    
//    [_tableView registerClass:[ListShowCell class] forCellReuseIdentifier:LISTSHOW_CELL];
//    [self loadBanner];
   // [self initTableHeaderView];
    
    _tableView.tableFooterView = tableFooterView;
    _tableView.sectionHeaderHeight = 42;
    _tableView.sectionFooterHeight = 10;
    
//    _data = [[NSMutableArray alloc]init];
//    [self setupHeader];
//    [self loadTableViewData];
    [self tableViewToTop];
    [self loadBanner];
    
}


- (void)initTableHeaderView {
    
    //广告图数据
    NSLog(@"123:%@",pictureUrlArray);
    
    UIView * topsView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 170)];
    //广告图view
    WHCircleImageView *circleImageView = [[WHCircleImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 140) AndImageUrlArray:pictureUrlArray view:topsView];
    
    //公告view
    UIView *noticeView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(circleImageView), DEVICE_SCREEN_SIZE_WIDTH, 30)];
    noticeView.backgroundColor = [UIColor whiteColor];
    //公告image
    UIImageView *_noticeImageView = [[UIImageView alloc]init];
    [_noticeImageView setFrame:CGRectMake(6, 7, 20, 16)];
    [_noticeImageView setImage:[UIImage imageNamed:@"notice"]];
    [noticeView addSubview:_noticeImageView];
    //公告message
    UILabel *_noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(_noticeImageView)+5, 6, DEVICE_SCREEN_SIZE_WIDTH-_noticeImageView.frame.size.width-10, 18)];
    _noticeLabel.font = [UIFont systemFontOfSize:13];
    _noticeLabel.textColor = FONTS_COLOR102;
    _noticeLabel.text = @"公告公告公告公告公告公告公告公告公告公告公告公告公告公告公告公告公告公告公告";
    [noticeView addSubview:_noticeLabel];
    [topsView addSubview:noticeView];
     _tableView.tableHeaderView = topsView;
}
#pragma mark - SDRefresh

- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
//    [self loadData];
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:_tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            _pageno = 1;
//            [self loadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    //    [refreshHeader beginRefreshing];
}
//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
//cell高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewCell *cell = (MainViewCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
//    return 200;
}
//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 2;
    return [_data count];
}
//cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    NSLog(@"row:%ld",(long)row);
    
    static NSString *CellIdentifier = @"MainViewCell";
    MainViewCell *cell = (MainViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if ([_data count] > 0) {
        
        MainProductEntity *entity = [_data objectAtIndex:row];
        NSLog(@"advProductImage:%@",entity.advProductImage);
        //类型名称
        cell.titleName.text = entity.productTypeName;
        //类型商品图片
        if ([self isBlankString:entity.advProductImage]) {
            cell.advImage.image = [UIImage imageNamed:@"暂无图片"];
        }else{
        [cell.advImage sd_setImageWithURL:[NSURL URLWithString:entity.advProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
        }
        //第一个商品
        /*图片*/
        if ([self isBlankString:entity.fristProductImage]) {
            cell.fristProductImage.image = [UIImage imageNamed:@"暂无图片"];
        }else{
            [cell.fristProductImage sd_setImageWithURL:[NSURL URLWithString:entity.fristProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
        }
        if ([self isBlankString:entity.firstProductName]) {
            cell.firstProductName.text = @"敬请期待";
        }else{
          cell.firstProductName.text = entity.firstProductName;
        }
        
        if ([self isBlankString:entity.firstProductPirce]) {
            cell.firstProductPirce.text = @"￥0.00";
        }else{
            cell.firstProductPirce.text = entity.firstProductPirce;
        }
        
        
        //第二个商品
        /*图片*/
        if ([self isBlankString:entity.secondProductImage]) {
            cell.secondProductImage.image = [UIImage imageNamed:@"暂无图片"];
        }else{
            [cell.secondProductImage sd_setImageWithURL:[NSURL URLWithString:entity.secondProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
        }
        if ([self isBlankString:entity.secondProductName]) {
            cell.secondProductName.text = @"敬请期待";
        }else{
            cell.secondProductName.text = entity.secondProductName;
        }
        if ([self isBlankString:entity.secondProductPrice]) {
            cell.secondProductPrice.text = @"￥0.00";
        }else{
            cell.secondProductPrice.text = entity.secondProductPrice;
        }
        
        
        //第三个商品
        /*图片*/
        if ([self isBlankString:entity.thirdProductImage]) {
            cell.thirdProductImage.image = [UIImage imageNamed:@"暂无图片"];
        }else{
            [cell.thirdProductImage sd_setImageWithURL:[NSURL URLWithString:entity.thirdProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
        }
        if ([self isBlankString:entity.secondProductName]) {
            cell.thirdProductName.text = @"敬请期待";
        }else{
            cell.thirdProductName.text = entity.thirdProductName;
        }
        if ([self isBlankString:entity.secondProductName]) {
            cell.thirdProductPrice.text = @"￥0.00";
        }else{
            cell.thirdProductPrice.text = entity.thirdProductPrice;
        }
        
        
    }
    
    return cell;
}

// ----------------------------------------------------------------------------------------
// tableView是否允许置顶
// ----------------------------------------------------------------------------------------
- (void)tableViewToTop {
    if (GTTabBar_Current) {
        if (SCNavTabBar_Current) {
            _tableView.scrollsToTop = YES;
        } else {
            _tableView.scrollsToTop = NO;
        }
    } else {
        _tableView.scrollsToTop = NO;
    }
}
#pragma mark - UIScrollView

// ----------------------------------------------------------------------------------------
// 首次在某个方向上进行拖动时通知
// ----------------------------------------------------------------------------------------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    scrollViewBeginDraggingY = scrollView.contentOffset.y;
}

//完成拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    scrollViewEndDraggingY = scrollView.contentOffset.y;
}

// ----------------------------------------------------------------------------------------
// scrollView 滚动时通知
// ----------------------------------------------------------------------------------------
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    if (_historicalItemsIndex == currentItemIndex) {
//        if (scrollView.contentOffset.y < contentInsetY) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideDown" object:nil];
//            [UIView animateWithDuration:0.2 animations:^{
//                scrollView.frame = tableViewFrame;
//            } completion:^(BOOL finished){ }];
//        } else {
//            if (scrollView.contentOffset.y > scrollViewBeginDraggingY) {
//                //上拉
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideUp" object:nil];
//                [UIView animateWithDuration:0.2 animations:^{
//                    scrollView.frame = tableViewFrame2;
//                } completion:^(BOOL finished){ }];
//            }
//        }
//    }
//
//    
//}
//获取公告图片
-(void)loadBanner{
    NSLog(@"datasss:%@",[Tools stringForKey:TokenDatas]);
    pictureUrlArray = [[NSMutableArray alloc]init];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:TokenDatas],     @"token",
                         nil];
    
    NSString *xpoint = [NSString stringWithFormat:@"/Api/Ad/show?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        pictureUrlArray = [[NSMutableArray alloc]init];
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"获取失败!";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
            AppDelegate *ade = [[AppDelegate alloc] init];
            [ade getTokenMessage];
        }else{
            for(NSDictionary *advImg in [dic valueForKey:@"data"]){
                NSLog(@"image:%@",[advImg valueForKey:@"image"]);
                
                [pictureUrlArray addObject:[advImg valueForKey:@"image"]];
                NSLog(@"Array:%@",[advImg valueForKey:@"pictureUrlArray"]);
            }
            [self initTableHeaderView];
        }
  
    } fail:^(NSError *error) {
        
    }];
}

// 获取首页列表数据
// ----------------------------------------------------------------------------------------
- (void)loadIndexData {
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [Tools stringForKey:TokenDatas],                               @"token",
                          @"68",   @"comId",
                          nil];
    
    NSLog(@"dic:%@", dics);
    NSString *xpoint = @"/Api/Goods/showIndex?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        pictureUrlArray = [[NSMutableArray alloc]init];
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"获取失败!";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
            AppDelegate *ade = [[AppDelegate alloc] init];
            [ade getTokenMessage];
        }else{
            for(NSDictionary *productMsgList in [dic valueForKey:@"data"]){
                MainProductEntity *entity = [[MainProductEntity alloc]initWithAttributes:productMsgList];
                [_data addObject:entity];
                
            }
            NSLog(@"LIST:%@",_data);
            [self initTableView];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}
//获取首页地址信息
- (void)loadIndexAddressMsg {
    NSLog(@"CURRENT_LONGITUDE:%@",[Tools stringForKey:CURRENT_LONGITUDE]);
    NSLog(@"CURRENT_LATITUDE:%@",[Tools stringForKey:CURRENT_LATITUDE]);
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [Tools stringForKey:CURRENT_LONGITUDE],                               @"longitude",
                          [Tools stringForKey:CURRENT_LATITUDE],   @"latitude",
                          nil];
    
    NSLog(@"dic:%@", dics);
    NSString *xpoint = @"/Api/Community/show?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        pictureUrlArray = [[NSMutableArray alloc]init];
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"获取失败!";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
        }else{
            communityName =  [NSString stringWithFormat:@"%@",[[[dic valueForKey:@"data"] objectAtIndex:0]valueForKey:@"com_name"]];
            communityId =  [NSString stringWithFormat:@"%@",[[[dic valueForKey:@"data"] objectAtIndex:0]valueForKey:@"id"]];
            [self initTopNav];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

-(void)onClickImage{
    
    NSLog(@"图片被点击!");
    SearchViewController *searchView= [[SearchViewController alloc]init];
    //registeredView.title = @"快捷登录";
    searchView.hidesBottomBarWhenPushed = YES;
    searchView.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:searchView animated:YES];
}

@end
