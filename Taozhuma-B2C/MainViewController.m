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


#import "GBTopLineViewModel.h"
#import "GBTopLineView.h"
#import "ProductDetailViewController.h"

#define kMidViewWidth   250
#define kMidViewHeight  50
#define tableViewFrame2     CGRectMake(0, ViewOrignY, ScreenWidth, ScreenHeight-ViewOrignY-50)

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIScrollView * adverView;
    UIPageControl * pageControl;
    UIView *topView;
    
    NSInteger   currentItemIndex;
    NSMutableArray *pictureUrlArray;
    NSMutableArray *noticeArray;
    NSString *communityId;//小区id
    NSString *communityName;//小区名称
    MBProgressHUD *hud;
    WHCircleImageView *circleImageView;
    UIView * topsView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,weak) NSTimer * timer;
@property (nonatomic,strong) NSMutableArray * adverData;
@property (nonatomic, strong) NSMutableArray *data;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property (nonatomic,strong) GBTopLineView *TopLineView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //通知 接收
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mineView:) name:@"refAddress"object:nil];
    
    //隐藏导航栏
    [self hideNaviBar:YES];
    
    _data = [[NSMutableArray alloc]init];
    
    [self loadBanner];
    
    [self initTableView];
    
    _dataArr=[[NSMutableArray alloc]init];
    
}

- (void)mineView:(NSNotification*)notification {
    
    [self loadIndexAddressMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTopNav {
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
    if (communityName != nil) {
        _loactionLabel.text = communityName;
    } else {
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
        [self setupHeader];
    //    [self loadTableViewData];
    
}


- (void)initTableHeaderView {
    
    //广告图数据
    NSLog(@"123:%@",pictureUrlArray);
    
    topsView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 170)];
    //广告图view
    circleImageView = [[WHCircleImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 140) AndImageUrlArray:pictureUrlArray view:topsView];
    [self createTopLineView];
    [self getData];

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
                        [self loadIndexData];
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
            cell.firstProductPirce.text = [NSString stringWithFormat:@"￥%@",entity.firstProductPirce];
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
            cell.secondProductPrice.text = [NSString stringWithFormat:@"￥%@",entity.secondProductPrice];
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
            
            cell.thirdProductPrice.text = [NSString stringWithFormat:@"￥%@",entity.thirdProductPrice];
        }
        
        [cell.moreBtn addTarget:self action:@selector(moreClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.firstProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.firstProductBtn.tag = entity.advProductId.intValue;
        
        [cell.secondProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.secondProductBtn.tag = entity.fristProductId.intValue;
        
        [cell.thirdProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.thirdProductBtn.tag = entity.secondProductId.intValue;
        
        [cell.fourProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.fourProductBtn.tag = entity.thirdProductId.intValue;
        
        
    }
    
    return cell;
}



//点击更多跳转的页面
- (IBAction)moreClicked:(id)sender {
    //通知 发出
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refSelectedIndex" object:nil];
}
- (IBAction)productClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    ProductDetailViewController *productDetailView= [[ProductDetailViewController alloc]init];
    productDetailView.goodId = btn.tag;
    productDetailView.title = @"商品详情";
    productDetailView.hidesBottomBarWhenPushed = YES;
    productDetailView.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:productDetailView animated:YES];
    
}
//获取公告图片
- (void)loadBanner {
    
    pictureUrlArray = [[NSMutableArray alloc]init];
    noticeArray = [[NSMutableArray alloc]init];
    
    NSString *xpoint = [NSString stringWithFormat:@"/Api/Ad/show?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:nil success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        
        pictureUrlArray = [[NSMutableArray alloc]init];
        if ([statusMsg intValue] == 4001) {
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        } else {
            
            for(NSDictionary *advImg in [dic valueForKey:@"data"]){
                NSLog(@"image:%@",[advImg valueForKey:@"image"]);
                
                [pictureUrlArray addObject:[advImg valueForKey:@"image"]];
                [noticeArray addObject:[advImg valueForKey:@"intro"]];
                
                NSLog(@"Array123:%@",[advImg valueForKey:@"pictureUrlArray"]);
            }
            
            [self initTableHeaderView];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

// 获取首页列表数据
// ----------------------------------------------------------------------------------------
- (void)loadIndexData {
    [_data removeAllObjects];
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          @"200",   @"comId",
                          nil];
    
    NSString *xpoint = @"/Api/Goods/showIndex?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        NSLog(@"statusMsg:%@",statusMsg);
        
        pictureUrlArray = [[NSMutableArray alloc]init];
        
        if ([statusMsg intValue] == 201) {
            //弹框提示获取失败
            [self showHUDText:@"暂无数据"];
            
        }else if ([statusMsg intValue] == 4001) {
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        } else if([statusMsg intValue] == 200){
            
            NSArray *data = [dic valueForKey:@"data"];
            
//            if (![Tools isBlankString:(NSString *)data]) {
            if ([data count] > 0) {
                for (NSDictionary *productMsgList in data) {
                    MainProductEntity *entity = [[MainProductEntity alloc]initWithAttributes:productMsgList];
                    [_data addObject:entity];
                }
                
                NSLog(@"LIST:%@",_data);
                [_tableView reloadData];
            }
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

//获取首页地址信息
- (void)loadIndexAddressMsg {
    
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [Tools stringForKey:CURRENT_LONGITUDE],  @"longitude",
                          [Tools stringForKey:CURRENT_LATITUDE],   @"latitude",
                          nil];
    
    NSString *xpoint = @"/Api/Community/show?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        } else {
            
            NSArray *data = [dic valueForKey:@"data"];
            communityName = [data[0] valueForKey:@"com_name"];
            communityId = [data[0] valueForKey:@"id"];
            
            [self initTopNav];
            [self loadIndexData];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

-(void)onClickImage{
    
    NSLog(@"图片被点击!");
        SearchViewController *searchView= [[SearchViewController alloc]init];
        searchView.hidesBottomBarWhenPushed = YES;
        searchView.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:searchView animated:YES];
}

#pragma mark-创建头条视图
-(void)createTopLineView{
    
    _TopLineView = [[GBTopLineView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 30)];
    _TopLineView.center = CGPointMake(DEVICE_SCREEN_SIZE_WIDTH/2.0, 154);
    NSLog(@"ss:%f",DEVICE_SCREEN_SIZE_HEIGHT/2.0-130);
    _TopLineView.backgroundColor = [UIColor whiteColor];
    __weak __typeof(self)weakSelf = self;
    _TopLineView.clickBlock = ^(NSInteger index){
        GBTopLineViewModel *model = weakSelf.dataArr[index];
        NSLog(@"%@,%@",model.type,model.title);
    };
    
    [topsView addSubview:_TopLineView];
    
}
#pragma mark-获取数据
- (void)getData
{
    NSMutableArray *arr3 = [[NSMutableArray alloc]init];
    for (int j = 0; j<noticeArray.count; j++) {
        [arr3 addObject:@""];
    }

    for (int i=0; i<noticeArray.count; i++) {
        GBTopLineViewModel *model = [[GBTopLineViewModel alloc]init];
        model.type = arr3[i];
        model.title = noticeArray[i];
        [_dataArr addObject:model];
    }
    [_TopLineView setVerticalShowDataArr:_dataArr];
}

@end
