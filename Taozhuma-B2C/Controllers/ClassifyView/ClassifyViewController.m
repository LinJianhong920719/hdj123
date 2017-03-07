//
//  ViewController.m
//  CollectionView
//
//  Created by Gnnt on 16/3/30.
//  Copyright © 2016年 Gnnt. All rights reserved.
//

#import "ClassifyViewController.h"
#import "CollectionViewCell.h"
#import "ClassifyModel.h"

#import "HYBNetworking.h"
#import "AppConfig.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ClassProductListViewController.h"
#import "ClassGoodsEntity.h"
#import "SearchViewController.h"

@interface ClassifyViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *category_arr;
    NSMutableArray *commodity_arr;
    NSMutableArray *cartGooods_arr;
    UICollectionView *_collectionView;
    UITableView *_tableView;
    BOOL _isRelate;
    NSString *token;
    NSString *catId;
    UIView *topView;
    UIButton *but;
    UITextField *searchLabel;
}

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    catId = @"1";
    [self hideNaviBarLeftBtn:YES];
    //隐藏导航栏
    [self hideNaviBar:YES];
    //初始化UI视图
    [self initTopNav];
//    [self setNaviBarTitle:@"商品分类"];
    
    [Tools getTokenMessage];
    token = [Tools stringForKey:TokenDatas];
    
    //    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    //    self.view.backgroundColor = [UIColor clearColor];
    //    self.navigationController.navigationBar.translucent = NO;
    //    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    category_arr = [[NSMutableArray alloc]init];
    commodity_arr = [[NSMutableArray alloc]init];
    cartGooods_arr = [[NSMutableArray alloc]init];
    
    [self TableView];
    [self CollectionView];
    [self getCarGoods];
    [self getClassMessage];
    
}
//初始化头部导航栏
-(void)initTopNav{
    //自定义导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    topView.backgroundColor = BACK_DEFAULT;
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 24, DEVICE_SCREEN_SIZE_WIDTH, 30)];
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(120*PROPORTION, 10, 10, 10)];
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
//获取大分类信息
- (void)getCarGoods {
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         @"0",      @"catId",
                         nil];
    
    NSString *path = [NSString stringWithFormat:@"/Api/Goods/getCat?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSString *status = [response valueForKey:@"status"];
        NSString *message = [response valueForKey:@"message"];
        NSArray *data = [response valueForKey:@"data"];
        NSLog(@"datas:%@",data);
        if([status intValue] == 4001){
            
            //弹框提示获取失败
            [self showHUDText:message];
            
            //重获数据
            [self getCarGoods];
            
        } else {
            
//            [cartGooods_arr removeAllObjects];
            
            for (NSDictionary *dic in data) {
                ClassGoodsEntity *classGoodsEntity = [[ClassGoodsEntity alloc]initWithAttributes:dic];
                [cartGooods_arr addObject:classGoodsEntity];

            }
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

//获取分类信息
- (void)getClassMessage {
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         catId,      @"catId",
                         token,     @"token",
                         nil];
    
    NSString *path = [NSString stringWithFormat:@"/Api/Goods/getCatInfo?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSString *status = [response valueForKey:@"status"];
        NSString *message = [response valueForKey:@"message"];
        NSArray *data = [response valueForKey:@"data"];
        
        if([status intValue] == 4001){
            
            //弹框提示获取失败
            [self showHUDText:message];
            
            //重获数据
            [self getClassMessage];
            
        } else {
            
            [category_arr removeAllObjects];
            [commodity_arr removeAllObjects];
            
            for (NSDictionary *dic in data) {
                ClassifyModel *model = [[ClassifyModel alloc]initWithDictionary:dic];
                [category_arr addObject:model];
                
                NSMutableArray *array = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in model.subclass) {
                    ClassifyModel *modelSub = [[ClassifyModel alloc]initWithDictionary:dic];
                    [array addObject:modelSub];
                }
                [commodity_arr addObject:array];
                [_collectionView reloadData];
            }
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}


- (UITableView *)TableView {
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ViewOrignY+1, [UIScreen mainScreen].bounds.size.width/4-9, [UIScreen mainScreen].bounds.size.height-110) style:UITableViewStylePlain];
        //_tableView.backgroundColor = [UIColor redColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        _tableView.scrollEnabled = YES;//能滑动
        _tableView.showsVerticalScrollIndicator = NO;//隐藏滚动条
        [self.view addSubview:_tableView];
        
        //去除tableView底部多余分割线
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
        tableFooterView.backgroundColor = [UIColor colorWithRed:238/255.0f green:239/255.0f blue:239/255.0f alpha:1];
        _tableView.tableFooterView = tableFooterView;
    }
    return _tableView;
}

- (UICollectionView *)CollectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/4, ViewOrignY+1, [UIScreen mainScreen].bounds.size.width*3/4-10, [UIScreen mainScreen].bounds.size.height - 110) collectionViewLayout:layout];//初始化，并设置布局方式
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;//隐藏滚动条
        //
        //        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];//注册UICollectionViewCell，这是固定格式，也是必须要实现的
        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:[NSBundle mainBundle]];
        [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CollectionViewCell"];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];//注册头/尾视图
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //设置组数，不写该方法默认是一组
    return category_arr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ClassifyModel *model = [category_arr objectAtIndex:section];
    return model.subclass.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"CollectionViewCell";//注意，此处的identifier要与注册cell时使用的标识保持一致
    
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSInteger section = [indexPath section];
    NSInteger row     = [indexPath row];
    
    ClassifyModel *model = [commodity_arr[section] objectAtIndex:row];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [cell.collectImage sd_setImageWithURL:[NSURL URLWithString:model.cat_s_image] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
//    cell.collectImage.image = [UIImage imageNamed:@"login_bg.png"];
    cell.collectName.text = model.cat_name;
    cell.userInteractionEnabled = YES;
    
    return cell;
    
}

//如果用头视图的方法进行相关联会出现，透视图的分类标题不能显示在可视范围
//设置头视图的尺寸，如果想要使用头视图，则必须实现该方法

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    // return CGSizeMake(WIDTH*3/4, 30);
    return CGSizeMake([UIScreen mainScreen].bounds.size.width*3/4, 40);//在此如果将头视图的尺寸设置为（0，0）则左侧的tableView的分类cell不会根据collectionView的滑动而滑到相应的分类的cell。
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    //根据类型以及标识获取注册过的头视图,
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    
    for (UIView *view in headerView.subviews) {
        [view removeFromSuperview];
    }
    
    ClassifyModel *model = [category_arr objectAtIndex:[indexPath section]];
    
    headerView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
    
    label.text = model.cat_s_name;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:10];
    
    [headerView addSubview:label];
    
    return headerView;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width/4.0-5, self.view.frame.size.width/4.0*1.1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //设置组距离上向左右的间距
    return UIEdgeInsetsMake(1, 0, 1, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    //两个item的列间距
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    //如果一组中有多行item，设置行间距
    return 0;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cartGooods_arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    ClassGoodsEntity *entity = [cartGooods_arr objectAtIndex:[indexPath row]];
//    NSLog(@"TENAME:%@",entity.catName);
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f  blue:102/255.0f  alpha:1];
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:255/255.0f green:214/255.0f  blue:0/255.0f  alpha:1];
    cell.textLabel.text = entity.catName;
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBackgroundView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1];
    selectedBackgroundView.alpha = 0.8;
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 40)];
    lineLabel.backgroundColor = [UIColor colorWithRed:255/255.0f green:214/255.0f  blue:0/255.0f  alpha:1];
    [selectedBackgroundView addSubview:lineLabel];
    cell.selectedBackgroundView = selectedBackgroundView;//自定义cell选中时的背景
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%zi组，%zi行",indexPath.section,indexPath.item);
//     ClassifyModel *model = [category_arr objectAtIndex:[indexPath row]];
    ClassifyModel *model = [category_arr objectAtIndex:[indexPath section]];
    
    NSLog(@"cat_name:%@",[[model.subclass objectAtIndex:indexPath.item]valueForKey:@"cat_name"]);
    NSLog(@"id:%@",[[model.subclass objectAtIndex:indexPath.item]valueForKey:@"id"]);
    
    ClassProductListViewController *detailsView = [[ClassProductListViewController alloc]init];
    detailsView.catId = [[model.subclass objectAtIndex:indexPath.item]valueForKey:@"id"];
    detailsView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsView animated:YES];

}

// tableview cell 选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassGoodsEntity *entity = [cartGooods_arr objectAtIndex:[indexPath row]];
    catId = entity.catId;
    NSLog(@"productID:%@",entity.catId);

    [self getClassMessage];
//    if (tableView == _tableView) {
//        _isRelate = NO;
//        [self.TableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
//        //将CollectionView的滑动范围调整到tableView相对应的cell的内容
//        _tableView.sectionIndexColor = [UIColor redColor];
//        [self.CollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.row] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
//        [self.CollectionView setContentOffset:CGPointMake(self.CollectionView.contentOffset.x, self.CollectionView.contentOffset.y-42)];
//        
//    }
}
//将显示视图
//-(void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
//    if (_isRelate) {
//        
//        NSInteger topcellsection = [[[collectionView indexPathsForVisibleItems]firstObject]section];
//        if (collectionView == _collectionView) {
//            [self.TableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topcellsection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//            
//        }
//    }
//}
//将结束显示视图
//-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
//    if (_isRelate) {
//        NSInteger itemsection = [[[collectionView indexPathsForVisibleItems]firstObject]section];
//        if (collectionView == _collectionView) {
//            
//            //当collectionView滑动时，tableView的cell自动选中相应的分类
//            [self.TableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:itemsection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//        }
//        
//    }
//}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isRelate = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    //进入页面时默认选择tableView的第一个选项
    NSIndexPath * selIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//跳转到搜索页面
- (IBAction)searchBtnClicked:(id)sender {
    SearchViewController *searchView= [[SearchViewController alloc]init];
    searchView.hidesBottomBarWhenPushed = YES;
    searchView.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:searchView animated:YES];
    
}
@end
