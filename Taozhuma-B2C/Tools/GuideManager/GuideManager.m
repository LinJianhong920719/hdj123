//
//  GuideManager.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/10.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "GuideManager.h"

static NSString *identifier = @"Cell";

@interface GuideViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation GuideViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self myInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self myInit];
    }
    return self;
}

- (void)myInit {
    
    self.layer.masksToBounds = YES;
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = ScreenRect;
    self.imageView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIColor *color = COLOR_EB4B82;
    
    button.hidden = YES;
    [button setFrame:CGRectMake(0, 0, turn6s(150), turn6s(44))];
    [button setTitle:@"点击进入" forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button.layer setCornerRadius:6];
    [button.layer setBorderColor:color.CGColor];
    [button.layer setBorderWidth:1.5f];
    [button setBackgroundColor:[UIColor whiteColor]];
    
    self.button = button;
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.button];
    
    [self.button setCenter:CGPointMake(ScreenWidth / 2, ScreenHeight - turn6s(44)*1.5)];
}

@end


@interface GuideManager ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UICollectionView *view;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation GuideManager

+ (instancetype)shared {
    static id __staticObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __staticObject = [GuideManager new];
    });
    return __staticObject;
}

- (UICollectionView *)view {
    if (_view == nil) {
        
        CGRect screen = [UIScreen mainScreen].bounds;
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = screen.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _view = [[UICollectionView alloc] initWithFrame:screen collectionViewLayout:layout];
        _view.bounces = NO;
        _view.backgroundColor = [UIColor whiteColor];
        _view.showsHorizontalScrollIndicator = NO;
        _view.showsVerticalScrollIndicator = NO;
        _view.pagingEnabled = YES;
        _view.dataSource = self;
        _view.delegate = self;
        
        [_view registerClass:[GuideViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _view;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, 0, ScreenWidth, 44.0f);
        _pageControl.center = CGPointMake(ScreenWidth / 2, ScreenHeight - 60);
    }
    return _pageControl;
}

- (void)showGuideViewWithImages:(NSArray *)images {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //根据版本号来区分是否要显示引导图
    BOOL show = [ud boolForKey:[NSString stringWithFormat:@"Guide_%@", version]];
    
    if (!show && self.window == nil) {
    
        self.images = images;
        self.pageControl.numberOfPages = images.count;
        self.window = [UIApplication sharedApplication].keyWindow;
        
        [self.window addSubview:self.view];
//        [self.window addSubview:self.pageControl];
        
        [ud setBool:YES forKey:[NSString stringWithFormat:@"Guide_%@", version]];
        [ud synchronize];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GuideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *path = [self.images objectAtIndex:indexPath.row];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    CGSize size = [self adapterSizeImageSize:img.size compareSize:ScreenRect.size];
    
    //自适应图片位置,图片可以是任意尺寸,会自动缩放.
    cell.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    cell.imageView.image = [UIImage imageWithContentsOfFile:path];
    cell.imageView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    
    if (indexPath.row == self.images.count - 1) {
        [cell.button setHidden:NO];
        [cell.button addTarget:self action:@selector(nextButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [cell.button setHidden:YES];
    }
    
    return cell;
}

- (CGSize)adapterSizeImageSize:(CGSize)is compareSize:(CGSize)cs {
    CGFloat w = cs.width;
    CGFloat h = cs.width / is.width * is.height;
    
    if (h < cs.height) {
        w = cs.height / h * w;
        h = cs.height;
    }
    return CGSizeMake(w, h);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = (scrollView.contentOffset.x / ScreenWidth);
}

- (void)nextButtonHandler:(id)sender {
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self setWindow:nil];
        [self setView:nil];
    }];
}

@end