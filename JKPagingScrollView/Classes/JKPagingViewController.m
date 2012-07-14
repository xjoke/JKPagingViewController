//
//  JKPagingViewController.m
//  JKPagingViewController
//
//  Version 2.0
//
//  Created by Keisel Jonas on 12.07.12.
//  Copyright (c) 2012 Jonas Keisel. All rights reserved.
// 

#import "JKPagingViewController.h"

//-- ----------------------------------------------------------------------------------------------------------------------
//-- UIView+Subview - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//-- ----------------------------------------------------------------------------------------------------------------------

#pragma mark - UIView+Subview

@implementation UIView (Subview)

- (BOOL) isSubviewFromView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if (v == self)
            return YES;
        else
            [self isSubviewFromView:v];
    }
    return NO;
}

@end

//-- ----------------------------------------------------------------------------------------------------------------------
//-- JKPagingViewController - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//-- ----------------------------------------------------------------------------------------------------------------------

#pragma mark - JKPagingViewController (Private Interface)

@interface JKPagingViewController () <UIScrollViewDelegate>

@property (nonatomic) BOOL pageControlBeingUsed;
@property (nonatomic) NSInteger tmpPage;

@end

#pragma mark - JKPagingViewController

#define KEY_PATH_VIEW_FRAME                 @"view.frame"
#define KEY_PATH_SCROLLVIEW_FRAME           @"scrollView.frame"
#define KEY_PATH_DATASOURCE                 @"dataSource"
#define KEY_PATH_PAGECONTROL_CURRENT_PAGE   @"pageControl.currentPage"

@implementation JKPagingViewController

#pragma mark Properties
@synthesize tmpPage = _tmpPage;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize usePageControl = _usePageControl;
@synthesize spaceBetweenPages = _spaceBetweenPages;
@synthesize pageControlBeingUsed = _pageControlBeingUsed;

#pragma mark Initialization
- (id)initWithView:(UIView *)view andPageControl:(UIPageControl *)pageControl
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.tmpPage = -1;
        self.usePageControl = YES;
        [self addObserver:self forKeyPath:KEY_PATH_VIEW_FRAME options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:KEY_PATH_SCROLLVIEW_FRAME options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:KEY_PATH_DATASOURCE options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:KEY_PATH_PAGECONTROL_CURRENT_PAGE options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        self.view = view;

        self.pageControl = pageControl;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
        [self recalculateAll];
    }
    
    return self;
}

#pragma mark Getter / Setter

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (_scrollView != scrollView && scrollView) {
        [_scrollView removeFromSuperview];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        [self recalculateAll];
    }
}

- (void)setPageControl:(UIPageControl *)pageControl
{
    if (self.pageControl != pageControl || !self.pageControl) {
        [_pageControl removeFromSuperview];
        if (pageControl) {
            _pageControl = pageControl;
        }
        else {
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
            [self.view addSubview:self.pageControl];
        }
        _pageControl.numberOfPages = 0;
        [self recalculatePageControlCenter];
        [self recalculateScrollViewFrame];
    }
}

- (void)setUsePageControl:(BOOL)usePageControl
{
    if (usePageControl == NO) {
        if ([self.pageControl isSubviewFromView:self.view])
            [self.pageControl removeFromSuperview];
    }
    else {
        if (self.pageControl.superview == nil)
            [self.view addSubview:self.pageControl];
    }
    [self recalculateScrollViewFrame];
}

#pragma mark Observation

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:KEY_PATH_VIEW_FRAME]) {
        [self recalculatePageControlCenter];
        [self recalculateScrollViewFrame];
    }
    else if ([keyPath isEqualToString:KEY_PATH_SCROLLVIEW_FRAME]) {
        [self recalculateViewControllerFrames];
    }
    else if ([keyPath isEqualToString:KEY_PATH_DATASOURCE]) {
        [self reloadPages];
    }
    else if ([keyPath isEqualToString:KEY_PATH_PAGECONTROL_CURRENT_PAGE]) {
        NSNumber *old = [change objectForKey:@"old"];
        NSNumber *new = [change objectForKey:@"new"];
        if ([old isKindOfClass:[NSNumber class]] && [new isKindOfClass:[NSNumber class]]) {
            if ([old isEqualToNumber:new] == NO) {
                [self scrollToPage:[new integerValue]];
                if ([self.delegate respondsToSelector:@selector(pagingController:willChangeFromPage:toPage:)]) {
                    [self.delegate pagingController:self willChangeFromPage:[old integerValue] toPage:[new integerValue]];
                }
            }
        }
    }
}

#pragma mark Frame Calculations

- (void)recalculateAll
{
    [self recalculatePageControlCenter];
    [self recalculateScrollViewFrame];
    [self recalculateViewControllerFrames];
}

- (void)recalculateViewControllerFrames
{
    int i, numberOfPages = self.numberOfPages;
    for (i = 0; i < numberOfPages; i++) {
        UIViewController *viewController = [self viewControllerAtIndex:i];
        if ([viewController.view isSubviewFromView:self.scrollView] == NO)
            [self.scrollView addSubview:viewController.view];
        CGRect newFrame = self.scrollView.frame;
        newFrame.origin.x = i*self.scrollView.bounds.size.width + i*self.spaceBetweenPages;
        viewController.view.frame = newFrame;
    }
    self.scrollView.contentSize = CGSizeMake(i*self.scrollView.bounds.size.width + i*self.spaceBetweenPages, self.scrollView.frame.size.height);
}

- (void)recalculatePageControlCenter
{
    if ([self.pageControl isSubviewFromView:self.view]) {
        CGPoint newCenter;
        newCenter.x = self.view.bounds.size.width / 2;
        newCenter.y = self.view.bounds.size.height - self.pageControl.frame.size.height / 2;
        self.pageControl.center = newCenter;
    }
}

- (void)recalculateScrollViewFrame
{
    CGRect newFrame = self.view.bounds;
    if ([self.pageControl isSubviewFromView:self.view]) {
        newFrame.size.height -= self.pageControl.bounds.size.height;
    }
    self.scrollView.frame = newFrame;
}

#pragma mark Managing View Controllers

- (void)reloadPages
{
    self.pageControl.numberOfPages = self.numberOfPages;
    [self removeAllViewFromScrollView];
    [self recalculateViewControllerFrames];
}

- (CGFloat)spaceBetweenPages
{
//    if ([self.dataSource respondsToSelector:@selector(spaceBetweenPagesForPagingViewController:)])
//        return [self.dataSource spaceBetweenPagesForPagingViewController:self];
    return 0;
}

- (NSUInteger)numberOfPages
{
    return [self.dataSource numberOfPagesInPagingViewController:self];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return [self.dataSource pagingViewController:self viewControllerAtIndex:index];
}

- (NSUInteger)currentPage
{
    return self.pageControl.currentPage;
}

- (void)removeAllViewFromScrollView
{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.pageControlBeingUsed){
        CGFloat pageWidth = self.scrollView.frame.size.width + self.spaceBetweenPages;
        self.tmpPage = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlBeingUsed = NO;
    
    if (self.tmpPage != -1) {
        self.pageControl.currentPage = self.tmpPage;
        self.tmpPage = -1;
    }
}

#pragma mark Scrolling

- (void)scrollToPage:(NSUInteger)index
{
    [self scrollToPage:index animated:YES];
}

- (void)scrollToPage:(NSUInteger)index animated:(BOOL)animated
{
    CGFloat pageWidth = self.scrollView.frame.size.width + self.spaceBetweenPages;
    [self.scrollView scrollRectToVisible:CGRectMake(index*pageWidth, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:animated];
    self.pageControl.currentPage = index;
    self.pageControlBeingUsed = YES;
}

@end