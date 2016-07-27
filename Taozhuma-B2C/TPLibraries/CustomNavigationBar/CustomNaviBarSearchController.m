//
//  CustomNaviBarSearchController.m
//  CustomNavigationBarDemo
//
//  Created by jimple on 14-1-6.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import "CustomNaviBarSearchController.h"
#import "CustomViewController.h"
#import "CustomNaviBarView.h"
#import "GlobalDefine.h"
#import "AppConfig.h"

#define RECT_NaviBar                            Rect(0.0f, NaviBarOrignY, ScreenWidth, NaviBarHeight)
#define RECT_SearchBarFrame                     Rect(20.0f, 7.0f, [CustomNaviBarView rightBtnFrame].origin.x-22.0f, 30)
#define RECT_SearchQrcodeFrame                  Rect(50.0f, 7.0f, ScreenWidth - 100.0f, 30)
#define RECT_SearchBarCoverCancelBtnFrame       Rect(60.0f, 0.0f, ScreenWidth - 120.0f, NaviBarHeight)
#define RECT_CancelBtnFrame                     Rect([CustomNaviBarView rightBtnFrame].origin.x, 0.0f, [CustomNaviBarView rightBtnFrame].size.width, NaviBarHeight)

#define RECT_TypeBtnFrame                     Rect(2, 0.0f, [CustomNaviBarView rightBtnFrame].size.width, NaviBarHeight)
#define RECT_ZXingBtnFrame                     Rect([CustomNaviBarView rightBtnFrame].origin.x, 0.0f, [CustomNaviBarView rightBtnFrame].size.width, NaviBarHeight)
#define RECT_StatusBarBtnFrame                 Rect(0.0f, -20.0f, [[UIScreen mainScreen] bounds].size.width, 20.0f)


@interface CustomNaviBarSearchController ()
<
    UISearchBarDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, readonly, weak) CustomViewController *m_viewCtrlParent;
@property (nonatomic, readonly) UIView *m_viewNaviBar;
@property (nonatomic, readonly) UISearchBar *m_searchBar;
@property (nonatomic, readonly) UIImageView *m_viewBlackCover;
@property (nonatomic, readonly) UIImageView *m_imgLogo;
@property (nonatomic, readonly) UIButton *m_btnCancel;
@property (nonatomic, readonly) UIButton *m_btnType;
@property (nonatomic, readonly) UIButton *m_btnZXing;
@property (nonatomic, readonly) UIButton *m_btnStatusBar;
@property (nonatomic, readonly) UITableView *m_tableView;

@property (nonatomic, readonly) BOOL m_bIsFixation;
@property (nonatomic, readonly) BOOL m_bIsCoverTitleView;
@property (nonatomic, readonly) BOOL m_bIsSearch;
@property (nonatomic, readonly) BOOL m_bIsWorking;
@property (nonatomic, readonly) NSArray *m_arrRecent;

@property (nonatomic, readonly) UIImage *m_imgBlurBg;

@end

@implementation CustomNaviBarSearchController
@synthesize delegate;
@synthesize m_viewNaviBar = _viewNaviBar;
@synthesize m_viewCtrlParent = _viewCtrlParent;
@synthesize m_searchBar = _searchBar;
@synthesize m_viewBlackCover = _viewBlackCover;
@synthesize m_imgLogo = _imgLogo;
@synthesize m_btnCancel = _btnCancel;
@synthesize m_btnType = _btnType;
@synthesize m_btnZXing = _btnZXing;
@synthesize m_btnStatusBar = _btnStatusBar;
@synthesize m_tableView = _tableView;
@synthesize m_bIsFixation = _bIsFixation;
@synthesize m_bIsWorking = _bIsWorking;
@synthesize m_arrRecent = _arrRecent;
@synthesize m_bIsCoverTitleView = _bIsCoverTitleView;
@synthesize m_bIsSearch = _bIsSearch;
@synthesize m_imgBlurBg = _imgBlurBg;

- (id)initWithParentViewCtrl:(CustomViewController *)viewCtrl
{
    self = [super init];
    if (self)
    {
        APP_ASSERT(viewCtrl);
        _viewCtrlParent = viewCtrl;
        
        [self initUI];
        
    }else{}
    return self;
}

- (void)dealloc
{
    
}

- (void)initUI
{
    APP_ASSERT(_viewCtrlParent);
    _viewNaviBar = [[UIView alloc] initWithFrame:RECT_NaviBar];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:RECT_SearchBarCoverCancelBtnFrame];
    _searchBar.placeholder = @"搜索商品";
    _searchBar.backgroundImage = [UIImage imageNamed:@"Transparent"];
    _searchBar.layer.cornerRadius = 15;
    _searchBar.layer.borderColor = [[UIColor whiteColor]CGColor];
    _searchBar.layer.borderWidth = 1;
    _searchBar.delegate = self;
    
    _btnCancel = [CustomNaviBarView createNormalNaviBarBtnByTitle:@"取消" target:self action:@selector(btnCancel:)];
    _btnCancel.frame = RECT_CancelBtnFrame;
    _btnCancel.hidden = YES;
    
    //左侧导航栏按钮
    _btnType = [CustomNaviBarView createNormalNaviBarBtnByTitle:@"" target:self action:@selector(btnType:)];
    [_btnType setBackgroundImage:[UIImage imageNamed:@"NaviBtn_Login"] forState:UIControlStateNormal];
    _btnType.frame = RECT_TypeBtnFrame;
    
    //右侧导航栏按钮
    _btnZXing = [CustomNaviBarView createNormalNaviBarBtnByTitle:@"" target:self action:@selector(btnZXing:)];
    [_btnZXing setBackgroundImage:[UIImage imageNamed:@"NaviBtn_Search"] forState:UIControlStateNormal];
    _btnZXing.frame = RECT_ZXingBtnFrame;
    
    //状态栏添加按钮 默认隐藏
    _btnStatusBar = [CustomNaviBarView createNormalNaviBarBtnByTitle:@"" target:self action:@selector(btnZXing:)];
    _btnStatusBar.frame = RECT_StatusBarBtnFrame;
    
    //appLogo
    _imgLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NaviBar_Logo"]];
    [_imgLogo setFrame:CGRectMake((ScreenWidth-84)/2, (NaviBarHeight-24)/2, 84, 24)];
    _imgLogo.hidden = YES;
    
    [_viewNaviBar addSubview:_imgLogo];
    [_viewNaviBar addSubview:_searchBar];
    [_viewNaviBar addSubview:_btnCancel];
    [_viewNaviBar addSubview:_btnType];
    [_viewNaviBar addSubview:_btnZXing];
    
    _viewBlackCover = [[UIImageView alloc] initWithFrame:_viewCtrlParent.view.bounds];
    _viewBlackCover.backgroundColor = [UIColor clearColor];
    _viewBlackCover.userInteractionEnabled = YES;
    _viewBlackCover.backgroundColor = RGBA(0.0f, 0.0f, 0.0f, 0.8f);
    
    UITapGestureRecognizer *tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapToClose:)];
    [_viewBlackCover addGestureRecognizer:tapToClose];
}

- (void)resetPlaceHolder:(NSString *)strMsg
{
    _searchBar.placeholder = strMsg;
}

- (void)showTempSearchCtrl
{
    [_viewCtrlParent naviBarAddCoverView:_viewNaviBar];
    _bIsFixation = NO;
    _bIsCoverTitleView = NO;
    
    [self startSearch];
}

- (void)showHomeNavigation
{
    [_viewCtrlParent naviBarAddCoverView:_viewNaviBar];
    _imgLogo.hidden = NO;
    _searchBar.hidden = YES;
    _btnType.hidden = YES;
    _btnZXing.hidden = NO;
    _bIsFixation = NO;
    _bIsCoverTitleView = NO;
    _bIsSearch = YES;
}

- (void)showSearchNavigation
{
    [_viewCtrlParent naviBarAddCoverView:_viewNaviBar];
    _searchBar.frame = RECT_SearchQrcodeFrame;
    _btnType.hidden = NO;
    [_btnType setBackgroundImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    _btnZXing.hidden = YES;
    _bIsFixation = NO;
    _bIsCoverTitleView = NO;
    _bIsSearch = YES;
}

- (void)showFixationSearchCtrl
{
    [_viewCtrlParent naviBarAddCoverView:_viewNaviBar];
    
    _bIsFixation = YES;
    _bIsCoverTitleView = NO;
}

- (void)showFixationSearchCtrlOnTitleView
{
    _viewNaviBar.frame = [CustomNaviBarView titleViewFrame];
    _searchBar.frame = _viewNaviBar.bounds;
    [_viewCtrlParent naviBarAddCoverViewOnTitleView:_viewNaviBar];
    
    _bIsFixation = YES;
    _bIsCoverTitleView = YES;
}

- (void)startSearch
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeKeys" object:nil];
    [self startWorking];
}

- (void)removeSearchCtrl
{
    [self removeFromParent];
}

- (void)setRecentKeyword:(NSArray *)arrRecentKeyword
{
    if (arrRecentKeyword)
        
    {
        _arrRecent = [NSArray arrayWithArray:arrRecentKeyword];
    }
    else
    {
        _arrRecent = nil;
    }
    
    if (_tableView)
    {
        [_tableView reloadData];
    }else{}
}

- (void)setKeyword:(NSString *)strKeyword
{
    if (_searchBar)
    {
        [_searchBar setText:strKeyword];
    }else{}
}

#pragma mark -
- (void)startWorking
{
    _btnCancel.hidden = NO;
    if (_bIsCoverTitleView)
    {
        _viewNaviBar.frame = RECT_NaviBar;
        _searchBar.frame = RECT_SearchBarFrame;
    }
    else
    {
        _searchBar.frame = RECT_SearchBarFrame;
    }
    
    _viewBlackCover.alpha = 0.0f;
//    [_viewCtrlParent.view addSubview:_viewBlackCover];
    [UIView animateWithDuration:0.4f animations:^()
     {
         _viewBlackCover.alpha = 1.0f;
     }completion:^(BOOL f){}];
    
    if (![_searchBar isFirstResponder])
    {
        [_searchBar becomeFirstResponder];
    }else{}
    
    [self showRecentTable:YES];
    
    [_viewCtrlParent bringNaviBarToTopmost];
    
    _bIsWorking = YES;
}

- (void)endWorking
{
    _btnCancel.hidden = YES;
    if (_bIsCoverTitleView)
    {
        _viewNaviBar.frame = [CustomNaviBarView titleViewFrame];
        _searchBar.frame = _viewNaviBar.bounds;
    }
    else
    {
        _searchBar.frame = RECT_SearchBarCoverCancelBtnFrame;
    }
    
    if ([_searchBar isFirstResponder])
    {
        [_searchBar resignFirstResponder];
    }else{}
    [_viewBlackCover removeFromSuperview];
    
    [self showRecentTable:NO];
    
    _bIsWorking = NO;
}

- (void)btnType:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(naviBarSearchCtrlType:)])
    {
        [delegate naviBarSearchCtrlType:self];
    }else{}
}

- (void)btnZXing:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(naviBarSearchCtrlZXing:)])
    {
        [delegate naviBarSearchCtrlZXing:self];
    }else{}
}

- (void)btnCancel:(id)sender
{
    _searchBar.text = @"";
    [self endWorking];
    
    if (delegate && [delegate respondsToSelector:@selector(naviBarSearchCtrlCancel:)])
    {
        [delegate naviBarSearchCtrlCancel:self];
    }else{}
}

- (void)removeFromParent
{
    if ([_searchBar isFirstResponder])
    {
        [_searchBar resignFirstResponder];
    }else{}
    
    [_viewCtrlParent naviBarRemoveCoverView:_viewNaviBar];
    [_viewBlackCover removeFromSuperview];
}

- (void)handleTapToClose:(UIGestureRecognizer *)gesture
{
    [self endWorking];
    
    if (delegate && [delegate respondsToSelector:@selector(naviBarSearchCtrlCancel:)])
    {
        [delegate naviBarSearchCtrlCancel:self];
    }else{}
}

- (void)showRecentTable:(BOOL)bIsShow
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeKeys" object:nil];
    if (bIsShow && _arrRecent && (_arrRecent.count > 0))
    {
        if (!_tableView)
        {
            _tableView = [[UITableView alloc] initWithFrame:_viewCtrlParent.view.bounds style:UITableViewStylePlain];
            [_viewCtrlParent.view addSubview:_tableView];
            [UtilityFunc resetScrlView:_tableView contentInsetWithNaviBar:YES tabBar:NO];
            
            UIView *footer = [[UIView alloc] initWithFrame:Rect(0.0f, 0.0f, ScreenWidth, 240.0f)];
            footer.backgroundColor = [UIColor clearColor];
            _tableView.tableFooterView = footer;
            UIButton *btnClearSearchRecord = [UIButton buttonWithType:UIButtonTypeCustom];
            btnClearSearchRecord.frame = Rect(0.0f, 20.0f, footer.frame.size.width, 50.0f);
            [btnClearSearchRecord setTitle:@"清除搜索记录" forState:UIControlStateNormal];
            [btnClearSearchRecord setTitleColor:RGB_TextLightGray forState:UIControlStateNormal];
            [btnClearSearchRecord setTitleColor:RGB_TextAppOrange forState:UIControlStateHighlighted];
            [btnClearSearchRecord addTarget:self action:@selector(btnClearSearchRecord:) forControlEvents:UIControlEventTouchUpInside];
            [footer addSubview:btnClearSearchRecord];
            
            _tableView.backgroundColor = RGBA(235.0f, 235.0f, 235.0f, 1.0f);
            
            _tableView.delegate = self;
            _tableView.dataSource = self;
        }else{}
        _tableView.hidden = NO;
        
        _tableView.frame = Rect(_tableView.frame.origin.x, _tableView.frame.origin.y+_tableView.frame.size.height, _tableView.frame.size.width, _tableView.frame.size.height);
        [UIView animateWithDuration:0.3f animations:^()
         {
             _tableView.frame = _viewCtrlParent.view.bounds;
         }];
    }
    else
    {
        if (_tableView)
        {
            [_tableView removeFromSuperview];
            _tableView = nil;
        }else{}
    }
}

- (void)btnClearSearchRecord:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(naviBarSearchCtrlClearKeywordRecord:)])
    {
        [delegate naviBarSearchCtrlClearKeywordRecord:self];
        [self loadKeyData];
    }else{APP_ASSERT_STOP}
}

- (void)loadKeyData {
    [Tools saveObject:@"" forKey:SaveData_SearchRecords];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeKeys" object:nil];
}

+ (void)setSearch:(NSString *)search forKey:(NSString *)key{
    NSString *arrayStr;
    NSMutableArray *arrayMutable = [[NSMutableArray alloc]init];
    [arrayMutable removeAllObjects];
    NSArray *array = [[NSArray alloc]init];
    
    if ([Tools stringForKey:key].length > 0) {
        array = [[Tools stringForKey:key] componentsSeparatedByString:NSLocalizedString(@",", nil)];
    }
    
    arrayMutable = [NSMutableArray arrayWithArray:array];
    
    if ([arrayMutable containsObject:search]) {
        [arrayMutable removeObject:search];
        [arrayMutable addObject:search];
    } else {
        [arrayMutable addObject:search];
    }
    NSArray* reversedArray = [[arrayMutable reverseObjectEnumerator] allObjects];
    arrayStr = [reversedArray componentsJoinedByString:@","];
    [Tools saveObject:arrayStr forKey:key];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text)
    {
        NSString *strKeyword = [[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] copy];
        if (strKeyword.length > 0)
        {
            searchBar.text = @"";
            [self endWorking];
            
            if (delegate && [delegate respondsToSelector:@selector(naviBarSearchCtrl:searchKeyword:)])
            {
                [delegate naviBarSearchCtrl:self searchKeyword:strKeyword];
            }else{}
        }
        else
        {
            searchBar.text = @"";
        }
    }else{APP_ASSERT_STOP}
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self startSearch];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger iCount = _arrRecent ? _arrRecent.count : 0;
    
    return iCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchTypeCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = RGB_TextDarkGray;
    cell.textLabel.font = [UIFont systemFontOfSize:SIZE_TextLarge];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *strKeyword = _arrRecent[indexPath.row];
    cell.textLabel.text = strKeyword;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strKeyword = _arrRecent[indexPath.row];
    [_searchBar setText:strKeyword];
}










@end
