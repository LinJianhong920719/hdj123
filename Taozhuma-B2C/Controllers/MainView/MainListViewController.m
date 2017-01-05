//
//  MainListViewController.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 17/1/4.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "MainListViewController.h"
#import "MainGoodsViewController.h"
#import "MainTouchTableTableView.h"
#import "MYSegmentView.h"
#import "MainProductEntity.h"
#import "MainViewCell.h"
#import "WHCircleImageView.h"
#import "SDCycleScrollView.h"
#import "GBTopLineView.h"
#import "MainBannerModel.h"
#import "GBTopLineViewModel.h"
#import "MainNavBar.h"

#import "ChooseAdressListViewController.h"
#import "PayFailViewController.h"

@interface MainListViewController () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>

/** 自定义导航栏 */
@property (nonatomic, strong) MainNavBar *navBar;

/** 主列表 */
@property (nonatomic, strong) MainTouchTableTableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *m_dataArray;

/** 联动视图 */
@property (nonatomic, strong) MYSegmentView *segView;

/** 轮播视图 */
@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic, strong) NSMutableArray *bannerData;

/** 广播视图 */
@property (nonatomic, strong) GBTopLineView *toplineView;
@property (nonatomic, strong) NSMutableArray *toplineData;

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

@property (nonatomic, strong) NSString *communityId;

@end

@implementation MainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNaviBar];
    
    [self.view addSubview:self.mainTableView];
    
    [self loadData];
    
    [self loadBannerData];
    
    [self setupHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerNotification];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  注册通知
 */
- (void)registerNotification {
    //联动通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkage:) name:GoTop object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkage:) name:LeaveTop object:nil];
    
    //获取首页地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexAddressMsg) name:@"refAddress" object:nil];
    //选择小区后的回调刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refCommunity:) name:@"refCommunity" object:nil];
}

- (void)linkage:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

- (void)indexAddressMsg {
    [_navBar setLoactionName:[Tools objectForKey:COMMUNITYNAME]];
}

- (void)refCommunity:(NSNotification*)notification {
    //获取到传递的小区id
    self.communityId = [notification object];
    [self indexAddressMsg];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:MainGoods_ReloadData object:nil];
}

#pragma mark - 导航设置

- (void)setNaviBar {
    //隐藏导航栏
    [self hideNaviBar:YES];
    
    _navBar = [[MainNavBar alloc]init];
    _navBar.frame = CGRectMake(0, 0, ScreenWidth, 64);
    [self.view addSubview:_navBar];
    
    __block typeof(self)wself = self;
    _navBar.loactionClickBlock = ^() {
        [wself chooseAdr];
    };
    _navBar.searchClickBlock = ^() {
        [wself onClickImage];
    };
    
    [self indexAddressMsg];
}

- (void)chooseAdr {
    DLog(@"选择地址");
    ChooseAdressListViewController *vc = [[ChooseAdressListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onClickImage {
    DLog(@"图片被点击!");
    PayFailViewController *vc = [[PayFailViewController alloc]initWithNibName:@"PayFailViewController" bundle:[NSBundle mainBundle]];
    vc.title = @"支付失败";
    [self.navigationController pushViewController:vc animated:YES];
    //勿删
    //    SearchViewController *vc = [[SearchViewController alloc]init];
    //    vc.hidesBottomBarWhenPushed = YES;
    //    vc.navigationController.navigationBarHidden = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat tabOffsetY = [_mainTableView rectForSection:2].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY >= tabOffsetY - 1) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    } else {
        _isTopIsCanNotMoveTabView = NO;
    }
    
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:GoTop object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if (_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView) {
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}

#pragma mark - UITableView

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth,ScreenHeight - 114)style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.directionalLockEnabled = YES;
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _mainTableView.sectionHeaderHeight = 0;
        _mainTableView.sectionFooterHeight = 0;
        
        _mainTableView.tableHeaderView = self.cycleView;
    }
    return _mainTableView;
}

- (NSMutableArray *)m_dataArray {
    if (!_m_dataArray) {
        _m_dataArray = [[NSMutableArray alloc]init];
    }
    return _m_dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0: {
            return 1;
        }   break;
        case 1: {
            return _m_dataArray.count;
        }   break;
        case 2: {
            return 1;
        }   break;
        default: {
            return 0;
        }   break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            return self.toplineView.height;
        }   break;
        case 1: {
            MainViewCell *cell = (MainViewCell *)[self tableView:_mainTableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }   break;
        case 2: {
            return ScreenHeight-114;
        }   break;
        default: {
            return 0;
        }   break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0: {
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            [cell.contentView addSubview:self.toplineView];
            
            return cell;
            
        }   break;
        case 1: {
            
            MainViewCell *cell = (MainViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.viewController = self;
            
            MainProductEntity *model = [_m_dataArray objectAtIndex:indexPath.row];
            
            [cell configWith:model];
            
            return cell;
            
        }   break;
        case 2: {
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            [cell.contentView addSubview:self.segView];
            
            return cell;
            
        }   break;
        default: {
            return nil;
        }   break;
    }

}

#pragma mark - MYSegmentView

- (MYSegmentView *)segView {
    if (!_segView) {
        
        MainGoodsViewController *vc = [[MainGoodsViewController alloc]init];
        
        NSArray *controllers = @[vc];
        
        MYSegmentView *rcs = [[MYSegmentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-114) controllers:controllers titleArray:nil viewController:self lineSize:CGSizeMake(0, 0) segmentHeight:0];
        
        _segView = rcs;
    }
    return _segView;
}


#pragma mark - SDCycleScrollView

- (NSMutableArray *)bannerData {
    if (!_bannerData) {
        _bannerData = [[NSMutableArray alloc]init];
    }
    return _bannerData;
}

- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, turn5(140)) delegate:self placeholderImage:[UIImage imageNamed:@"loading-3"]];
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleView.currentPageDotColor = [UIColor redColor];
        _cycleView.autoScrollTimeInterval = 5.0;
        _cycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _cycleView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    MainBannerModel *model = [_bannerData objectAtIndex:index];
    DLog(@"点击banner : %ld  title ---> %@", index, model.banner_title);
}

#pragma mark - GBTopLineView

- (NSMutableArray *)toplineData {
    if (!_toplineData) {
        _toplineData = [[NSMutableArray alloc]init];
    }
    return _toplineData;
}

- (GBTopLineView *)toplineView {
    if (!_toplineView) {
        _toplineView = [[GBTopLineView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        _toplineView.backgroundColor = [UIColor whiteColor];
        
        __weak __typeof(self)weakSelf = self;
        _toplineView.clickBlock = ^(NSInteger index) {
            GBTopLineViewModel *model = weakSelf.toplineData[index];
            DLog(@"点击消息 : %ld  intro ---> %@", index, model.intro);
        };
    }
    return _toplineView;
}

#pragma mark - SDRefresh

- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:_mainTableView];
    
    refreshHeader.beginRefreshingOperation = ^{
        [self loadData];
        [self loadBannerData];
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
    
    _refreshHeader = refreshHeader;
}

- (void)dealloc {
    [self.refreshHeader removeFromSuperview];
}

#pragma mark - 接口访问

/**
 列表数据
 */
- (void)loadData {

    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          @"185",   @"comId",
                          nil];
    
    NSString *xpoint = @"/Api/Goods/showIndex?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSInteger statusMsg = [[dic valueForKey:@"status"]integerValue];
        
        if (statusMsg == 201) {
            //弹框提示获取失败
            [self showHUDText:@"暂无数据"];
            
        } else if (statusMsg == 4001) {
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        } else if(statusMsg == 200) {
            
            NSArray *data = [dic valueForKey:@"data"];
            
            if (data && [data count]) {
                
                [self.m_dataArray removeAllObjects];
                
                for (NSDictionary *productMsgList in data) {
                    MainProductEntity *entity = [[MainProductEntity alloc]initWithAttributes:productMsgList];
                    [_m_dataArray addObject:entity];
                }
                NSLog(@"LIST:%@",_m_dataArray);
                
                [_mainTableView reloadData];
            }
            
        }
        
        [self.refreshHeader endRefreshing];
    } fail:^(NSError *error) {
        [self.refreshHeader endRefreshing];
    }];
    
}

/**
 轮播数据
 */
- (void)loadBannerData {
    
    NSString *xpoint = [NSString stringWithFormat:@"/Api/Ad/show?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:nil success:^(id response) {
        
        NSDictionary *dic = response;
        NSInteger statusMsg = [[dic valueForKey:@"status"]integerValue];
        
        if (statusMsg == 4001) {
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        } else {
            
            [self.bannerData removeAllObjects];
            [self.toplineData removeAllObjects];
            
            NSArray *array = [dic valueForKey:@"data"];
            
            for (NSDictionary *dic in array) {
                MainBannerModel *model = [[MainBannerModel alloc]initWithDictionary:dic];
                [_bannerData addObject:model];
                
                GBTopLineViewModel *lineModel = [[GBTopLineViewModel alloc]initWithDictionary:dic];
                [_toplineData addObject:lineModel];
            }
            
            [self.toplineView setVerticalShowDataArr:_toplineData];
            self.cycleView.imageURLStringsGroup = [array valueForKey:@"image"];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

@end
