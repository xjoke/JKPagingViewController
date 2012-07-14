//
//  JKPagingViewController.h
//  JKPagingViewController
//
//  Version 2.0
//
//  Created by Keisel Jonas on 12.07.12.
//  Copyright (c) 2012 Jonas Keisel. All rights reserved.
//

#import <UIKit/UIKit.h>

//-- ----------------------------------------------------------------------------------------------------------------------
//-- JKPagingViewControllerDelegate - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//-- ----------------------------------------------------------------------------------------------------------------------

@class JKPagingViewController;
@protocol JKPagingViewControllerDelegate <NSObject>

@optional
- (void)pagingController:(JKPagingViewController *)sender willChangeFromPage:(NSUInteger)from toPage:(NSUInteger)to;

@end

//-- ----------------------------------------------------------------------------------------------------------------------
//-- JKPagingViewControllerDataSource - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//-- ----------------------------------------------------------------------------------------------------------------------

@class JKPagingViewController;
@protocol JKPagingViewControllerDataSource <NSObject>

@required
- (NSUInteger)numberOfPagesInPagingViewController:(JKPagingViewController *)pagingViewController;
- (UIViewController *)pagingViewController:(JKPagingViewController *)pagingViewController viewControllerAtIndex:(NSUInteger)index; // zero-based index

@optional
//- (CGFloat)spaceBetweenPagesForPagingViewController:(JKPagingViewController *)pagingViewController;

@end

//-- ----------------------------------------------------------------------------------------------------------------------
//-- JKPagingViewController - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//-- ----------------------------------------------------------------------------------------------------------------------

@interface JKPagingViewController : UIViewController

@property (strong, nonatomic)   UIPageControl *pageControl;
@property (strong, nonatomic)   UIScrollView  *scrollView;
@property (nonatomic)           BOOL           usePageControl; // YES by default -- if no && [pageControl isSubviewOfView:self.view] -> no pageControl
@property (readonly, nonatomic) CGFloat        spaceBetweenPages; // functionallity is not implemented, yet
@property (readonly, nonatomic) NSUInteger     numberOfPages;
@property (readonly, nonatomic) NSUInteger     currentPage; // zero-based index
@property (weak, nonatomic)     id<JKPagingViewControllerDelegate> delegate;
@property (weak, nonatomic)     id<JKPagingViewControllerDataSource> dataSource;

// If pageControl equals nil, a new UIPageControl is initilized and put on self.view
- (id)initWithView:(UIView *)view andPageControl:(UIPageControl *)pageControl; // Designated Initilizer

- (void)reloadPages;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index; // zero-based index

- (void)scrollToPage:(NSUInteger)index; // zero-based index
- (void)scrollToPage:(NSUInteger)index animated:(BOOL)animated;

@end