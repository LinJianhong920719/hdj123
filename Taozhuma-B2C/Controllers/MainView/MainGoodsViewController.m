//
//  MainGoodsViewController.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 17/1/4.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "MainGoodsViewController.h"
#import "JLWaterfallFlowLayout.h"
#import "HotProductEntity.h"
#import "MainGoodsViewCell.h"
#import "ProductDetailViewController.h"

@interface MainGoodsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, JLWaterfallFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *m_collectionView;
@property (nonatomic, strong) NSMutableArray *m_dataArray;
@property (nonatomic, assign) NSInteger pageno;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@property (nonatomic, strong) UIImageView *hotIV;

@end

@implementation MainGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNaviBar];
    
    [self loadData];
    
    [self setupFooter];
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
    //数据刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:MainGoods_ReloadData object:nil];
}

- (void)reloadData:(NSNotification*)notification {
    [self loadData];
}

#pragma mark - 导航设置

- (void)setNaviBar {
    //隐藏导航栏
    [self hideNaviBar:YES];
}

#pragma mark - 接口访问

- (void)loadData {
    
    if (!_pageno) {
        _pageno = 1;
    }
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         @"185", @"comId",
                         [NSNumber numberWithInteger:_pageno], @"pager",
                         nil];
    NSString *xpoint = [NSString stringWithFormat:@"/Api/Goods/HotSell?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        NSInteger statusMsg = [[dic valueForKey:@"status"]integerValue];
        
        if (statusMsg == 4001) {
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        } else if (statusMsg == 200) {
            
            dispatch_async(global_quque, ^{
                
                if (_pageno == 1) {
                    [self.m_dataArray removeAllObjects];
                }

                NSArray *array = [dic valueForKey:@"data"];
                
                for (NSDictionary *dic in array) {
                    HotProductEntity *model = [[HotProductEntity alloc]initWithAttributes:dic];
                    [_m_dataArray addObject:model];
                }
                
                dispatch_async(main_queue, ^{
                    [self.m_collectionView reloadData];
                });
            });
            
        }
        
        [self.refreshFooter endRefreshing];
    } fail:^(NSError *error) {
        [self.refreshFooter endRefreshing];
    }];
}


#pragma mark - UICollectionView

- (UICollectionView *)m_collectionView {
    if (!_m_collectionView) {
        
        JLWaterfallFlowLayout *flowLayout = [[JLWaterfallFlowLayout alloc] init];
        flowLayout.colMargin = 10;//间距
        flowLayout.rowMargin = 10;//间距
        flowLayout.colCount = 2;//控制列数
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);//视图边界
        flowLayout.delegate = self;
        
        _m_collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-114) collectionViewLayout:flowLayout];
        _m_collectionView.dataSource = self;
        _m_collectionView.delegate   = self;
        _m_collectionView.showsVerticalScrollIndicator = NO;
        _m_collectionView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_m_collectionView];
        
        [_m_collectionView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
        
        [_m_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
        [_m_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reusableView"];
    }
    return _m_collectionView;
}

- (void)loadNewData {
    _pageno = 1;
    [self loadData];
}

- (void)loadMoreData {
    _pageno ++;
    [self loadData];
}

- (NSMutableArray *)m_dataArray {
    if (!_m_dataArray) {
        _m_dataArray = [[NSMutableArray alloc]init];
    }
    return _m_dataArray;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _m_dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MainGoodsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    HotProductEntity *model = [_m_dataArray objectAtIndex:[indexPath item]];
    [cell setCellData:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"点击了第%@item",@(indexPath.row));
    
    HotProductEntity *hotProductEntity = [_m_dataArray objectAtIndex:indexPath.item];
    
    ProductDetailViewController *vc = [[ProductDetailViewController alloc]init];
    vc.goodId = [hotProductEntity.hid intValue];
    vc.title = @"商品详情";
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark JLWaterfallFlowLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JLWaterfallFlowLayout *)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    return width + 70;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(JLWaterfallFlowLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(JLWaterfallFlowLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 1);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        
        self.hotIV.centerY = headerView.centerY;
        [headerView addSubview:self.hotIV];
        
        reusableView = headerView;
        
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        
        reusableView = footerView;
    
    }
    return reusableView;
}

- (UIImageView *)hotIV {
    if (!_hotIV) {
        _hotIV = [[UIImageView alloc]init];
        _hotIV.frame = CGRectMake(10, 10, ScreenWidth - 20, 12);
        _hotIV.contentMode = UIViewContentModeScaleAspectFill;
        _hotIV.image = [UIImage imageNamed:@"pro-hot"];
        _hotIV.backgroundColor = self.view.backgroundColor;
    }
    return _hotIV;
}

#pragma mark - SDRefresh

- (void)setupFooter {
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.m_collectionView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh {
    _pageno ++;
    [self loadData];
}

- (void)dealloc {
    [self.refreshFooter removeFromSuperview];
}

@end
