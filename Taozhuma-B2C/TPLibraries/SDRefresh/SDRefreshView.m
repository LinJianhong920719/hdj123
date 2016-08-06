//
//  SDRefreshView.m
//  SDRefreshView
//
//  Created by aier on 15-2-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/**
 
 *******************************************************
 *                                                      *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题    *
 * 您可以发邮件到gsdios@126.com 或者 到                       *
 * https://github.com/gsdios?tab=repositories 提交问题     *
 *                                                      *
 *******************************************************
 
 */
#import "SDRefreshView.h"
#import "UIView+SDExtension.h"

CGFloat const SDRefreshViewDefaultHeight = 70.0f-myHeight;
CGFloat const SDActivityIndicatorViewMargin = 50.0f;
CGFloat const SDTextIndicatorMargin = 20.0f;
CGFloat const SDTimeIndicatorMargin = 10.0f;

@implementation SDRefreshView
{
    UIImageView *_stateIndicatorView;
    UILabel *_textIndicator;
    UILabel *_timeIndicator;
    NSString *_lastRefreshingTimeString;
    SDRefreshViewStyle _refreshStyle;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (_refreshStyle == SDRefreshViewStyleClassical) {
            
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, -60-myHeight, bounds_width, 125)];
            [self addSubview:bgView];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((bounds_width-116)/2, 10, 116, 78)];
            [imageView setImage:[UIImage imageNamed:@"refreshImage.png"]];
            [bgView addSubview:imageView];
            
            UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
            activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [activity startAnimating];
            [self addSubview:activity];
            _activityIndicatorView = activity;
            
            // 状态提示图片
            UIImageView *stateIndicator = [[UIImageView alloc] init];
            stateIndicator.image = [UIImage imageNamed:@"arrowNew"];
            [self addSubview:stateIndicator];
            _stateIndicatorView = stateIndicator;
            _stateIndicatorView.bounds = CGRectMake(0, 0, 17, 17);
            
            // 状态提示label
            UILabel *textIndicator = [[UILabel alloc] init];
            textIndicator.bounds = CGRectMake(0, 0, 300, 30);
            textIndicator.textAlignment = NSTextAlignmentCenter;
            textIndicator.backgroundColor = [UIColor clearColor];
            textIndicator.font = [UIFont systemFontOfSize:14];
            textIndicator.textColor = [UIColor lightGrayColor];
            //        [self addSubview:textIndicator];
            _textIndicator = textIndicator;
            
            // 更新时间提示label
            UILabel *timeIndicator = [[UILabel alloc] init];
            timeIndicator.bounds = CGRectMake(0, 0, 160, 16);;
            timeIndicator.textAlignment = NSTextAlignmentCenter;
            timeIndicator.textColor = [UIColor lightGrayColor];
            timeIndicator.font = [UIFont systemFontOfSize:14];
            //        [self addSubview:timeIndicator];
            _timeIndicator = timeIndicator;
        }
    }
    return self;
}

+ (instancetype)refreshView
{
    return [[self alloc] init];
}

+ (instancetype)refreshViewWithStyle:(SDRefreshViewStyle)refreshViewStayle
{
    SDRefreshView *refresh = [self alloc];
    [refresh setRefreshStyle:refreshViewStayle];
    
    return [refresh init];
}

- (void)setRefreshStyle:(SDRefreshViewStyle)refreshStyle
{
    _refreshStyle = refreshStyle;
}

- (void)didMoveToSuperview
{
    self.bounds = CGRectMake(0, 0, bounds_width, SDRefreshViewDefaultHeight);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _activityIndicatorView.center = CGPointMake(bounds_width/2, SDKNavigationBarHeight-18);
    _stateIndicatorView.center = _activityIndicatorView.center;
    
    _textIndicator.center = CGPointMake(self.sd_width * 0.5, _activityIndicatorView.sd_height * 0.5 + SDTextIndicatorMargin);
    _timeIndicator.center = CGPointMake(self.sd_width * 0.5, self.sd_height - _timeIndicator.sd_height * 0.5 - SDTimeIndicatorMargin);
}

- (NSString *)lastRefreshingTimeString
{
    if (_lastRefreshingTimeString == nil) {
        return [self refreshingTimeString];
    }
    return _lastRefreshingTimeString;
}

- (void)addToScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    [_scrollView addSubview:self];
    [_scrollView addObserver:self forKeyPath:SDRefreshViewObservingkeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    // 默认是在NavigationController控制下，否则可以调用addToScrollView:isEffectedByNavigationController:(设值为NO) 即可
    _isEffectedByNavigationController = YES;
}

- (void)addToScrollView:(UIScrollView *)scrollView isEffectedByNavigationController:(BOOL)effectedByNavigationController
{
    [self addToScrollView:scrollView];
    _isEffectedByNavigationController = effectedByNavigationController;
    _originalEdgeInsets = scrollView.contentInset;
}

- (void)addTarget:(id)target refreshAction:(SEL)action
{
    _beginRefreshingTarget = target;
    _beginRefreshingAction = action;
}


// 获得在scrollView的contentInset原来基础上增加一定值之后的新contentInset
- (UIEdgeInsets)syntheticalEdgeInsetsWithEdgeInsets:(UIEdgeInsets)edgeInsets
{
    return UIEdgeInsetsMake(_originalEdgeInsets.top + edgeInsets.top, _originalEdgeInsets.left + edgeInsets.left, _originalEdgeInsets.bottom + edgeInsets.bottom, _originalEdgeInsets.right + edgeInsets.right);
}

- (void)setRefreshState:(SDRefreshViewState)refreshState
{
    _refreshState = refreshState;
    
    switch (refreshState) {
            // 进入刷新状态
        case SDRefreshViewStateRefreshing:
        {
            NSLog(@"contentInset.top:%f",self.scrollView.contentInset.top);
            _originalEdgeInsets = self.scrollView.contentInset;
            
            _scrollView.contentInset = [self syntheticalEdgeInsetsWithEdgeInsets:self.scrollViewEdgeInsets];
            
            [_activityIndicatorView startAnimating];
            _stateIndicatorView.hidden = YES;
            _activityIndicatorView.hidden = NO;
            _lastRefreshingTimeString = [self refreshingTimeString];
            _textIndicator.text = SDRefreshViewRefreshingStateText;
            
            if (self.beginRefreshingOperation) {
                self.beginRefreshingOperation();
            } else if (self.beginRefreshingTarget) {
                if ([self.beginRefreshingTarget respondsToSelector:self.beginRefreshingAction]) {
                    
                    // 屏蔽performSelector-leak警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self.beginRefreshingTarget performSelector:self.beginRefreshingAction];
                }
            }
        }
            break;
            
        case SDRefreshViewStateWillRefresh:
        {
            _textIndicator.text = SDRefreshViewWillRefreshStateText;
            [UIView animateWithDuration:0.3 animations:^{
                _stateIndicatorView.transform = CGAffineTransformMakeRotation(self.stateIndicatorViewWillRefreshStateTransformAngle);
            }];
        }
            break;
            
        case SDRefreshViewStateNormal:
        {
            [UIView animateWithDuration:0.3 animations:^{
                _stateIndicatorView.transform = CGAffineTransformMakeRotation(self.stateIndicatorViewNormalTransformAngle);
            }];
            _textIndicator.text = self.textForNormalState;
            
            _timeIndicator.text = [NSString stringWithFormat:@"最后更新：%@", [self lastRefreshingTimeString]];
            _stateIndicatorView.hidden = NO;
            [_activityIndicatorView stopAnimating];
            _activityIndicatorView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

- (void)setNormalStateOperationBlock:(RefreshViewOperationBlock)normalStateOperationBlock
{
    _normalStateOperationBlock = normalStateOperationBlock;
    _normalStateOperationBlock(self, 0);
}

- (void)endRefreshing
{
    [UIView animateWithDuration:0.6 animations:^{
        _scrollView.contentInset = _originalEdgeInsets;
    } completion:^(BOOL finished) {
        [self setRefreshState:SDRefreshViewStateNormal];
        if (self.isManuallyRefreshing) {
            self.isManuallyRefreshing = NO;
        }
    }];
}

// 更新时间
- (NSString *)refreshingTimeString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    return [formatter stringFromDate:date];
}

// 保留！
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ;
}

- (void)dealloc
{
    [self.superview removeObserver:self forKeyPath:SDRefreshViewObservingkeyPath];
}

@end