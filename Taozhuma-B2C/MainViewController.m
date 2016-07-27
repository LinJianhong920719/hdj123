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

#define tableViewFrame2     CGRectMake(0, ViewOrignY, ScreenWidth, ScreenHeight-ViewOrignY-50)

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>{
     UIScrollView * adverView;
     UIPageControl * pageControl;
     UIView *topView;
    CGFloat     scrollViewBeginDraggingY;    //记录开始拖拽时的 scrollView.contentOffset.y
    CGFloat     scrollViewEndDraggingY;     //记录完成拖拽时的 scrollView.contentOffset.y
    BOOL GTTabBar_Current;      //GTTabBar是否当前选中的
    BOOL SCNavTabBar_Current;   //SCNavTabBar是否当前选中的
    NSInteger   currentItemIndex;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,weak) NSTimer * timer;
@property (nonatomic,strong) NSMutableArray * adverData;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏导航栏
    [self hideNaviBar:YES];
    
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
    _loactionLabel.text = @"北京天安门";
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
    [_serachImage setFrame:CGRectMake(viewRight(addressView)+45, 28, DEVICE_SCREEN_SIZE_WIDTH-addressView.frame.size.width-70, 28)];
    NSLog(@"111:%f",DEVICE_SCREEN_SIZE_WIDTH/320);
    [_serachImage setImage:[UIImage imageNamed:@"search"]];
    [topView addSubview:_serachImage];
    
    [self.view addSubview:topView];
    [self.view bringSubviewToFront:topView];
    GTTabBar_Current = YES;
    SCNavTabBar_Current = YES;
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView {
    
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
    
    [self initTableHeaderView];
    
    _tableView.tableFooterView = tableFooterView;
    _tableView.sectionHeaderHeight = 42;
    _tableView.sectionFooterHeight = 10;
    
//    _data = [[NSMutableArray alloc]init];
    [self setupHeader];
//    [self loadTableViewData];
    [self tableViewToTop];
    
}


- (void)initTableHeaderView {
    //广告图数据
    NSArray *testArr = @[@"http://www.taozhuma.com/upfiles/product/20160429032809931486.jpg",@"http://imgsrc.baidu.com/forum/pic/item/0e2442a7d933c895d8064c31d11373f08202007b.jpg",@"http://d.3987.com/Qhyrz_130520/004.jpg"];
    UIView * topsView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 170)];
    //广告图view
    WHCircleImageView *circleImageView = [[WHCircleImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 140) AndImageUrlArray:testArr view:topsView];
    
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
    return 10;
}
//cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger row = [indexPath row];
    
    
    static NSString *CellIdentifier = @"MainViewCell";
    MainViewCell *cell = (MainViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_historicalItemsIndex == currentItemIndex) {
        if (scrollView.contentOffset.y < contentInsetY) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideDown" object:nil];
            [UIView animateWithDuration:0.2 animations:^{
                scrollView.frame = tableViewFrame;
            } completion:^(BOOL finished){ }];
        } else {
            if (scrollView.contentOffset.y > scrollViewBeginDraggingY) {
                //上拉
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SlideUp" object:nil];
                [UIView animateWithDuration:0.2 animations:^{
                    scrollView.frame = tableViewFrame2;
                } completion:^(BOOL finished){ }];
            }
        }
    }

    
}


@end
