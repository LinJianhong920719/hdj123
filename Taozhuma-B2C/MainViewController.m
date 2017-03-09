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
#import "HotProductEntity.h"
#import "HotProCollectionViewCell.h"
#import "ChooseAdressListViewController.h"
#import "PaySuccessViewController.h"
#import "PayFailViewController.h"

#define kMidViewWidth   250
#define kMidViewHeight  50
#define tableViewFrame2     CGRectMake(0, ViewOrignY, ScreenWidth, ScreenHeight-ViewOrignY-50)

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    UIImageView *_loactionImageView;
    UILabel *_loactionLabel;
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
    UIView * footsView;
    NSMutableArray *hotProArray;
    HotProductEntity *hotProductEntity;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,weak) NSTimer * timer;
@property (nonatomic,strong) NSMutableArray * adverData;
@property (nonatomic, strong) NSMutableArray *data;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property (nonatomic, strong) NSMutableArray *hotPro_data;
@property (nonatomic,strong) GBTopLineView *TopLineView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取首页地址
    [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(indexAddressMsg)
                                                   name:@"refAddress"
                                                 object:nil];
    //选择小区后的回调刷新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refCommunity:)
                                                 name:@"refCommunity"
                                               object:nil];
    
    _data = [[NSMutableArray alloc]init];
    _hotPro_data = [[NSMutableArray alloc]init];
    _dataArr=[[NSMutableArray alloc]init];


    //隐藏导航栏
    [self hideNaviBar:YES];
    
    //自定义导航栏
    [self initTopNav];
    
    //tableView视图
    [self initTableView];
    
    /*======= 接口数据获取 ========*/
    [self indexAddressMsg]; //  导航栏数据
    [self loadBanner];  //首页轮播图数据
    [self loadIndexData]; //首页tableView视图数据
    [self loadhotPro];  //首页热卖商品数据
    
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"refAddress" object:nil];
    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"refCommunity" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -UI界面
//自定义导航栏
- (void)initTopNav {
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    topView.backgroundColor = BACK_DEFAULT;
    
    //定位
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH/3, 40)];
    addressView.backgroundColor = [UIColor clearColor];
    [topView addSubview:addressView];
    
    //定位image
    _loactionImageView = [[UIImageView alloc]init];
    [_loactionImageView setFrame:CGRectMake(14, 33, 10, 14)];
    [_loactionImageView setImage:[UIImage imageNamed:@"address"]];
    [addressView addSubview:_loactionImageView];
    
    //定位message
    _loactionLabel = [[UILabel alloc]init];
    _loactionLabel.font = [UIFont systemFontOfSize:16];
    _loactionLabel.textColor = FONTS_COLOR51;
    if (communityName != nil) {
        _loactionLabel.text = communityName;
    } else {
        _loactionLabel.text = @"定位中";
    }
    
    [_loactionLabel setFrame:CGRectMake(viewRight(_loactionImageView)+5, 34, 100*PROPORTION, 15)];
    [addressView addSubview:_loactionLabel];
    //定位image
    UIImageView *_loactionImageView1 = [[UIImageView alloc]init];
    [_loactionImageView1 setFrame:CGRectMake(viewRight(_loactionLabel)+5, 36, 8, 4)];
    [_loactionImageView1 setImage:[UIImage imageNamed:@"drop-down"]];
    [addressView addSubview:_loactionImageView1];
    
    //定位按钮
    UIButton *addressBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH/3, 40)];
    addressBut.backgroundColor = [UIColor clearColor];
    [topView addSubview:addressBut];
    [addressBut addTarget:self action:@selector(chooseAdr) forControlEvents:UIControlEventTouchUpInside];
    
    //搜索
    UIImageView *_serachImage = [[UIImageView alloc]init];
    [_serachImage setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-160, 28, 150, 24)];
    [_serachImage setImage:[UIImage imageNamed:@"search"]];
    _serachImage.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [_serachImage addGestureRecognizer:singleTap];
    [topView addSubview:_serachImage];
    
    [self.view addSubview:topView];
    [self.view bringSubviewToFront:topView];
    
}

- (void)initTableView {

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ViewOrignY, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _tableView.sectionHeaderHeight = 42;
    _tableView.sectionFooterHeight = 100;
    
    [self setupHeader]; //下拉刷新
    
}
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

- (void)initTableHeaderView {
    
    //广告图数据
    
    topsView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 170)];
    //广告图view
    circleImageView = [[WHCircleImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 140) AndImageUrlArray:pictureUrlArray view:topsView];
    //跑马灯轮播UI
    [self createTopLineView];
    //跑马灯轮播数据
    [self getData];

    _tableView.tableHeaderView = topsView;
}

-(void)initTableFooterView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT+400) collectionViewLayout:flowLayout];//初始化，并设置布局方式
    _collectionView.backgroundColor = BGCOLOR_DEFAULT;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;//隐藏滚动条
    
    [_collectionView registerNib:[UINib nibWithNibName:@"HotProCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotProCollectionViewCell"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];//注册头/尾视图
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
    
    
    _tableView.tableFooterView = _collectionView;
}


#pragma mark -下拉刷新

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
            [self loadhotPro];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
        [refreshHeader beginRefreshing];
}

#pragma mark-TableView委托事件
//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
//cell高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewCell *cell = (MainViewCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}
//cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    NSLog(@"row:%ld",(long)row);
    
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
        
        [cell.classBtn addTarget:self action:@selector(moreClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.firstProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.firstProductBtn.tag = entity.advProductId.intValue;
        
        [cell.secondProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.secondProductBtn.tag = entity.fristProductId.intValue;
        
        [cell.thirdProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.thirdProductBtn.tag = entity.secondProductId.intValue;
        
//        [cell.fourProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
//        cell.fourProductBtn.tag = entity.thirdProductId.intValue;
        
        
    }
    
    return cell;
}

#pragma mark -- CollectView事件委托
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _hotPro_data.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifiers = @"HotProCollectionViewCell";
//    HotProCollectionViewCell *cell = (HotProCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    HotProCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifiers forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if(indexPath.row< _hotPro_data.count) {
        
        hotProductEntity= _hotPro_data[indexPath.row];
        
    }
//    HotProductEntity *hotProductEntity = [_hotPro_data objectAtIndex:[indexPath row]];
    if ([self isBlankString:hotProductEntity.goodImage]) {
        cell.hotProImage.image = [UIImage imageNamed:@"暂无图片"];
    }else{
        [cell.hotProImage sd_setImageWithURL:[NSURL URLWithString:hotProductEntity.goodImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    if ([self isBlankString:hotProductEntity.goodName]) {
        cell.hotProName.text = @"敬请期待";
    }else{
        cell.hotProName.text = hotProductEntity.goodName;
    }
    
    if ([self isBlankString:hotProductEntity.goodPrice]) {
        cell.hotProPrice.text = @"￥0.00";
    }else{
        cell.hotProPrice.text = [NSString stringWithFormat:@"￥%@",hotProductEntity.goodPrice];
    }
//DEVICE_SCREEN_SIZE_WIDTH, [_hotPro_data count]*178*PROPORTION
//    [_collectionView setFrame:CGRectMake(_collectionView.frame.origin.x, _collectionView.frame.origin.y, DEVICE_SCREEN_SIZE_WIDTH, [_hotPro_data count]/2*220*PROPORTION)];
    return cell;
}



//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(145*PROPORTION, 220);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}



//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%zi组，%zi行",indexPath.section,indexPath.item);

    HotProductEntity *hotProductEntity = [_hotPro_data objectAtIndex:indexPath.item];
 
    ProductDetailViewController *productDetailView= [[ProductDetailViewController alloc]init];
    productDetailView.goodId = [hotProductEntity.hid intValue];
    productDetailView.title = @"商品详情";
    productDetailView.hidesBottomBarWhenPushed = YES;
    productDetailView.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:productDetailView animated:YES];

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={DEVICE_SCREEN_SIZE_WIDTH,26};
    return size;
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={DEVICE_SCREEN_SIZE_WIDTH,20};
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind==UICollectionElementKindSectionHeader) {
        //根据类型以及标识获取注册过的头视图,
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        for (UIView *view in headerView.subviews) {
            [view removeFromSuperview];
        }
        UIImageView *hotProImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,10,ScreenWidth, 11)];
        hotProImg.image = [UIImage imageNamed:@"pro-hot"];
        [headerView addSubview:hotProImg];
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView" forIndexPath:indexPath];
        UIButton *moreHotPro = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 20)];
        [moreHotPro setTitle:@"点击查看全部商品>" forState:UIControlStateNormal];
        [moreHotPro setTitleColor:FONTS_COLOR153 forState:UIControlStateNormal];
        moreHotPro.titleLabel.font =[UIFont systemFontOfSize:12.0f];
        [footerView addSubview:moreHotPro];
        return footerView;
    }
}

#pragma mark -点击事件
//点击更多跳转的页面
- (IBAction)moreClicked:(id)sender {
    //通知 发出
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refSelectedIndex" object:nil];
}
//点击商品跳转商品详情页面
- (IBAction)productClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    ProductDetailViewController *productDetailView= [[ProductDetailViewController alloc]init];
    productDetailView.goodId = btn.tag;
    productDetailView.title = @"商品详情";
    productDetailView.hidesBottomBarWhenPushed = YES;
    productDetailView.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:productDetailView animated:YES];
    
}
//
-(void)chooseAdr{
    NSLog(@"选择地址");
    ChooseAdressListViewController *chooseAdressListView= [[ChooseAdressListViewController alloc]init];
    chooseAdressListView.hidesBottomBarWhenPushed = YES;
    chooseAdressListView.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:chooseAdressListView animated:YES];
}
-(void)onClickImage{
    
    NSLog(@"图片被点击!");
    PayFailViewController *sc1= [[PayFailViewController alloc]initWithNibName:@"PayFailViewController" bundle:[NSBundle mainBundle]];
    sc1.title = @"支付失败";
    [self.navigationController pushViewController:sc1 animated:YES];
    //勿删
//    SearchViewController *searchView= [[SearchViewController alloc]init];
//    searchView.hidesBottomBarWhenPushed = YES;
//    searchView.navigationController.navigationBarHidden = YES;
//    [self.navigationController pushViewController:searchView animated:YES];
}
#pragma mark -接口数据
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
                
//                NSLog(@"Array123:%@",[advImg valueForKey:@"pictureUrlArray"]);
            }
            
            [self initTableHeaderView];
            
        }
        
    } fail:^(NSError *error) {
        
    }];
}

//获取热卖商品图片
- (void)loadhotPro {
    [_hotPro_data removeAllObjects];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                          @"185",   @"comId",
                          nil];
    NSString *xpoint = [NSString stringWithFormat:@"/Api/Goods/HotSell?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        
        hotProArray = [[NSMutableArray alloc]init];
        if ([statusMsg intValue] == 4001) {
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        } if([statusMsg intValue] == 200) {
            for (NSDictionary *hotProMsgList in [dic valueForKey:@"data"]) {
               HotProductEntity *hotProductEntity = [[HotProductEntity alloc]initWithAttributes:hotProMsgList];
                [_hotPro_data addObject:hotProductEntity];
                [self initTableFooterView];
            }
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];
}

// 获取首页列表数据
// ----------------------------------------------------------------------------------------
- (void)loadIndexData {
    [_data removeAllObjects];
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          @"185",   @"comId",
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
                [_data removeAllObjects];
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
- (void)indexAddressMsg {
    NSLog(@"COMMUNITYNAME:%@",[Tools objectForKey:COMMUNITYNAME]);
  _loactionLabel.text = [Tools objectForKey:COMMUNITYNAME];
}


//选择小区后回调刷新
- (void) refCommunity:(NSNotification*) notification{
    communityId = [notification object];//获取到传递的小区id
    [self indexAddressMsg]; //  导航栏数据
    [self loadIndexData]; //首页tableView视图数据
    [self loadhotPro];  //首页热卖商品数据
    
}


//获取轮播信息
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
