//
//  WHCircleImageView.m
//  WHCircleImageView测试
//
//  Created by wanghao on 16/3/9.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import "WHCircleImageView.h"
#import "WHCirCleImageViewCell.h"
#import "UIImageView+WebCache.h"

//多少秒翻动一次图片
#define changeImageTime 3
//pageControl的中心点位置
#define pageControlPosition CGPointMake(CGRectGetMaxX(frame)/2, CGRectGetMaxY(frame)-20)

@interface WHCircleImageView ()<UICollectionViewDelegate,UICollectionViewDataSource>
//接受传来的ImageUrlArray
@property(nonatomic,strong)NSArray *ImageUrlArray;
//存储下载的图片
@property(nonatomic,strong)NSArray *imageViewArray;
// 当前显示图片的索引
@property (nonatomic, assign) NSInteger currentIndex;
//提供一个timer，让其自动循环播放
@property(nonatomic,strong)NSTimer *timer;
//全局属性图片滚动到的位置
@property (nonatomic,assign)NSInteger index;

@property (nonatomic,strong)UIPageControl * page;
@end

@implementation WHCircleImageView


-(instancetype)initWithFrame:(CGRect)frame AndImageUrlArray:(NSArray *)ImageUrlArray view:(UIView *)view{
    
    //创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
    NSLog(@"gao:%f",frame.size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //创建collectionView
    self = [[WHCircleImageView alloc] initWithFrame:frame collectionViewLayout:layout];
    //注册cell
    [self registerClass:[WHCirCleImageViewCell class] forCellWithReuseIdentifier:@"circle"];
    
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;

    self.delegate =self;
    self.dataSource = self;

    [self addTimer];
    
    self.index = self.ImageUrlArray.count*30;
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.index inSection:0];
    
    //默认一开始滚动到第1000张图片的位置
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

    self.ImageUrlArray = ImageUrlArray;
    
    //添加pageController
    UIPageControl * page = [self createPage];
    
    //根据图片张数获取page的宽高
    CGSize  pageSize = [page sizeForNumberOfPages:self.ImageUrlArray.count];
    page.frame = CGRectMake(0, 0, pageSize.width, frame.size.height);
    NSLog(@"gao1:%f",frame.size.height);
    page.center = pageControlPosition;
    self.page = page;
   
    
    [view addSubview:self];
    [view addSubview:page];
    return self;
}

//计时器的方法 自动滚动图片
-(void)changeImage
{
    //调用计时器方法是 让图片索引++ 滚动图片
    self.index++;
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:self.index inSection:0];
    
    [self scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    self.page.currentPage = self.index%self.imageViewArray.count;
}

// MARK:数据源方法



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 2000;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WHCirCleImageViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"circle" forIndexPath:indexPath];
    
    //取出图片赋值给cell
    cell.UrlimageView = self.imageViewArray[indexPath.item%self.imageViewArray.count];
    
    return cell;
}
//当手指拖动图片时
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self deleteTimer];
}

//滚动结束之后发送通知 让控制器接收通知 设置page的当前页数
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    
    self.index = index;
    
    self.page.currentPage = self.index%self.imageViewArray.count;
    
    [self addTimer];
}
-(void)addTimer
{
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:changeImageTime target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
    //添加到运行循环
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    self.timer = timer;
}

-(void)deleteTimer
{
    [self.timer invalidate];
    
    self.timer = nil;
}

//创建pageControl
-(UIPageControl *)createPage
{
    //初始化方法
    UIPageControl * page = [[UIPageControl alloc]init];
    
    page.currentPage = 0;
    
    page.numberOfPages = self.ImageUrlArray.count;
    
    page.currentPageIndicatorTintColor = [UIColor yellowColor];
    
    page.pageIndicatorTintColor = [UIColor whiteColor];
    
    return page;
    
}

//当手指拖动图片时
//懒加载
-(NSArray *)imageViewArray{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.ImageUrlArray.count];
    for (int i = 0; i < [_ImageUrlArray count]; i++) {
        NSString *imageUrl = self.ImageUrlArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        [tempArray addObject:imageView];
    }
    
    return tempArray;
}
@end
