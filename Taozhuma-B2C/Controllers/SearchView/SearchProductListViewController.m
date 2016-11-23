//
//  SearchProductListViewController.m
//
//  Created by yusaiyan on 15/8/11.
//  Copyright (c) 2015年 lixinfan. All rights reserved.
//

#import "SearchProductListViewController.h"
#import "ProductCell.h"
#import "ProductEntity.h"
#import "ProductDetailViewController.h"
#import "SearchViewController.h"

#define Reality_viewHeight ScreenHeight-ViewOrignY-40-50
#define Reality_viewWidth ScreenWidth

@interface SearchProductListViewController () <UITableViewDataSource,UITableViewDelegate>{
    UIImageView *secondImage;
    UIImageView *thirdImage;
    UIImageView *firstImage;
    NSString *tagOrder;
    UIView *topView;
    UILabel *firstLabel;
    UILabel *secondLabel;
    UILabel *thirdLabel;
    NSString *sortStr;
}

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic, assign) NSInteger pageno;
@property (nonatomic, assign) NSInteger sort;
@end

@implementation SearchProductListViewController
@synthesize mTableView = _mTableView;
@synthesize data = _data;
@synthesize pageno = _pageno;
@synthesize sort = _sort;
@synthesize content;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideNaviBar:YES];
    [self initTopNav];
    [self initUI];
    [self loadData];
    [self setupHeader];
//    [self setupFooter];
    _sort = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化UI

-(void)initTopNav{
    //自定义导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    topView.backgroundColor = BACK_DEFAULT;
    //返回
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 23, 28, 33)];
//    [backButton setBackgroundColor:[UIColor blueColor]];
    [backButton setImage:[UIImage imageNamed:@"header_back"] forState:UIControlStateNormal];//设置按钮的图片
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10) ];//将按钮的上下左右都缩进8个单位
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];//为按钮增加时间侦听
    [topView addSubview:backButton];

    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(viewRight(backButton)+10, 24, DEVICE_SCREEN_SIZE_WIDTH, 30)];
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 10, 10)];
    [searchImageView setImage:[UIImage imageNamed:@"icon_search"]];
    [searchView addSubview:searchImageView];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(searchImageView)+5, 0, 200, 30)];

    searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchBtn setTitleColor:FONTS_COLOR102 forState:UIControlStateNormal];
    [searchBtn setTitle:@"请输入商品名称" forState:UIControlStateNormal];
    searchBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;//设置文字位置
    [searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    
    [topView addSubview:searchView];
    
    [self.view addSubview:topView];
    [self.view bringSubviewToFront:topView];
}

- (void)initUI {
    
    _data = [[NSMutableArray alloc]init];
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 94, Reality_viewWidth, ScreenHeight-100) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.scrollsToTop = YES;
    _mTableView.backgroundColor = self.view.backgroundColor;
    _mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_mTableView];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Reality_viewWidth, 1)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    _mTableView.tableFooterView = tableFooterView;
    
//    [self loadData];
    //筛选View
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ViewOrignY, Reality_viewWidth, 30)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    //分割线
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewBottom(view), Reality_viewWidth, 1)];
    line.backgroundColor = [UIColor colorWithRed:238/255.0f green:239/255.0f blue:239/255.0f alpha:1];
    [self.view addSubview:line];
    
    
    //第一个view
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Reality_viewWidth/3, 30)];
    firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Reality_viewWidth/3, 30)];
    firstLabel.text = @"综合排序";
    firstLabel.textColor = [UIColor redColor];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.font = [UIFont systemFontOfSize:10];
    [firstView addSubview:firstLabel];

    [view addSubview:firstView];
    
    UIImageView *oneLine = [[UIImageView alloc]initWithFrame:CGRectMake(viewRight(firstLabel)+0.5, 5, 1, 20)];
    oneLine.backgroundColor = [UIColor colorWithRed:238/255.0f green:239/255.0f blue:239/255.0f alpha:1];
    [view addSubview:oneLine];
    
    UIButton *firstButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Reality_viewWidth/3, 30)];
    firstButton.tag = 1001;
    [firstButton addTarget:self action:@selector(dragInside:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:firstButton];
    
    //第二个view
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(Reality_viewWidth/3+1, 0, Reality_viewWidth/3, 30)];
    secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, secondView.frame.size.width/3*2-10, 30)];
    secondLabel.text = @"按价格";
    secondLabel.textAlignment = NSTextAlignmentRight;
    secondLabel.font = [UIFont systemFontOfSize:10];
    [secondView addSubview:secondLabel];
    
    secondImage = [[UIImageView alloc]initWithFrame:CGRectMake(viewRight(secondLabel)+5, 10, 5, 10)];
    [secondImage setImage:[UIImage imageNamed:@"sort"]];
    [secondView addSubview:secondImage];
    UIImageView *twoLine = [[UIImageView alloc]initWithFrame:CGRectMake(Reality_viewWidth/3*2, 5, 1, 20)];
    twoLine.backgroundColor = [UIColor colorWithRed:238/255.0f green:239/255.0f blue:239/255.0f alpha:1];
    [view addSubview:twoLine];
    [view addSubview:secondView];
    
    UIButton *secondButton = [[UIButton alloc]initWithFrame:CGRectMake(Reality_viewWidth/3+10, 0, Reality_viewWidth/3, 30)];
    secondButton.tag = 1002;
    [secondButton addTarget:self action:@selector(dragInside:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:secondButton];
    
    
    //第三个view
    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(Reality_viewWidth/3*2+1, 0, Reality_viewWidth/3, 30)];
//    thirdView.backgroundColor = [UIColor grayColor];
    thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, thirdView.frame.size.width/3*2-10, 30)];
    thirdLabel.text = @"按销量";
    thirdLabel.textAlignment = NSTextAlignmentRight;
    thirdLabel.font = [UIFont systemFontOfSize:10];
    [thirdView addSubview:thirdLabel];
    
    
    thirdImage = [[UIImageView alloc]initWithFrame:CGRectMake(viewRight(thirdLabel)+5, 10, 5, 10)];
    [thirdImage setImage:[UIImage imageNamed:@"sort"]];
    [thirdView addSubview:thirdImage];
    
    
    [view addSubview:thirdView];
    
    UIButton *thirdButton = [[UIButton alloc]initWithFrame:CGRectMake(Reality_viewWidth/3*2+10, 0, Reality_viewWidth/3, 30)];
    thirdButton.tag = 1003;
    [thirdButton addTarget:self action:@selector(dragInside:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:thirdButton];
    
    
}

//按钮点击方法
-(IBAction)dragInside:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1001) {
        NSLog(@"_sort:%ld",(long)_sort);
        [firstLabel setTextColor:[UIColor redColor]];
        [secondLabel setTextColor:FONTS_COLOR102];
        [thirdLabel setTextColor:FONTS_COLOR102];
        
        [secondImage setImage:[UIImage imageNamed:@"sort"]];
        [thirdImage setImage:[UIImage imageNamed:@"sort"]];

        [self loadData];
    }
    else if (btn.tag == 1002) {
        NSLog(@"_sort:%ld",(long)_sort);
        [firstLabel setTextColor:FONTS_COLOR102];
        [thirdImage setImage:[UIImage imageNamed:@"sort"]];
        if(_sort == 3){
            _sort = 4;
            [secondLabel setTextColor:[UIColor redColor]];
            [secondImage setImage:[UIImage imageNamed:@"sort_down"]];
        }else if(_sort == 4){
            _sort = 3;
            [secondLabel setTextColor:[UIColor redColor]];
            [secondImage setImage:[UIImage imageNamed:@"sort_up"]];
        }else{
            _sort = 3;
            [secondLabel setTextColor:[UIColor redColor]];
            [secondImage setImage:[UIImage imageNamed:@"sort_up"]];
        }
        
        [self loadData];
    }
    else if (btn.tag == 1003) {
        NSLog(@"_sort:%ld",(long)_sort);
        [firstLabel setTextColor:FONTS_COLOR102];
        [secondImage setImage:[UIImage imageNamed:@"sort"]];
        if(_sort == 5){
            _sort = 6;
            [thirdLabel setTextColor:[UIColor redColor]];
            [thirdImage setImage:[UIImage imageNamed:@"sort_down"]];
        }else if(_sort == 6){
            _sort = 5;
            [thirdLabel setTextColor:[UIColor redColor]];
            [thirdImage setImage:[UIImage imageNamed:@"sort_up"]];
        }else{
            _sort = 5;
            [thirdLabel setTextColor:[UIColor redColor]];
            [thirdImage setImage:[UIImage imageNamed:@"sort_up"]];
            
        }
        [self loadData];
        
    }
    
}

#pragma mark - 加载数据

- (void)loadData {
    if(_sort == 1){
        sortStr = @"";
    }else if(_sort == 3){
        sortStr = @"priceAsc";
    }else if (_sort == 4){
        sortStr = @"priceDesc";
    }else if(_sort == 4){
        sortStr = @"priceAsc";
    }else if (_sort == 4){
        sortStr = @"priceDesc";
    }
    NSLog(@"content:%@",content);
    NSLog(@"userId:%@",[Tools stringForKey:KEY_USER_ID]);
    NSLog(@"sort:%@",sortStr);
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         content,     @"content",
                         [Tools stringForKey:KEY_USER_ID],@"userId",
                         sortStr,@"sort",
                         nil];
    
    NSString *path = [NSString stringWithFormat:@"/Api/Goods/searchGoods?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        NSLog(@"response:%@",response);
        NSString *statusMsg = [dic valueForKey:@"status"];
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"获取失败!";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
        }if([statusMsg intValue] == 201){
            //弹框提示获取失败
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"无数据";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
        }if([statusMsg intValue] == 4002){
            [self showHUDText:@"获取失败!"];
        }else{
            [_data removeAllObjects];
            if([[dic valueForKey:@"data"] count] > 0 && [dic valueForKey:@"data"] != nil){
                for(NSDictionary *proDiction in [dic valueForKey:@"data"]){
                    
                    ProductEntity *entity = [[ProductEntity alloc]initWithAttributes:proDiction];
                    [_data addObject:entity];
                    
                }
                [_mTableView reloadData];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"无数据";
                hud.yOffset = -50.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
            }
            
        }

    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - SDRefresh

- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    [refreshHeader addToScrollView:_mTableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageno = 1;
            [self loadData];
//            [_mTableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}
-(void)refeshOrder{
    _pageno = 1;
//    [self loadData];
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_mTableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _pageno ++;
//        [self loadData];
        [self.refreshFooter endRefreshing];
    });
}

- (void)dealloc
{
    [self.refreshHeader removeFromSuperview];
    [self.refreshFooter removeFromSuperview];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = (ProductCell *)[self tableView:_mTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        cell.addCart.tag = [entity.productID integerValue];
        [cell.addCart addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.delCollect.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductEntity *entity = [_data objectAtIndex:[indexPath row]];
    NSLog(@"productID:%@",entity.productID);
    ProductDetailViewController *productDetailView= [[ProductDetailViewController alloc]init];
    productDetailView.goodId = entity.productID.integerValue;
    productDetailView.title = @"商品详情";
    productDetailView.hidesBottomBarWhenPushed = YES;
    productDetailView.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:productDetailView animated:YES];
    [_mTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)backClick:(id)sender {
    // 返回上页
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    ProductDetailViewController *productDetailView= [[ProductDetailViewController alloc]init];
    productDetailView.goodId = btn.tag;
    productDetailView.title = @"商品详情";
    productDetailView.hidesBottomBarWhenPushed = YES;
    productDetailView.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:productDetailView animated:YES];
    
}
- (IBAction)searchBtnClicked:(id)sender {
    SearchViewController *searchView= [[SearchViewController alloc]init];
    searchView.hidesBottomBarWhenPushed = YES;
    searchView.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
