//
//  JKPagingViewController.h
//  JKPagingViewController
//
//  Version 1.0
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
//-- JKPagingViewController - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//-- ----------------------------------------------------------------------------------------------------------------------

@interface JKPagingViewController : UIViewController

@property (strong, nonatomic)   UIPageControl     *pageControl;
@property (strong, nonatomic)   UIScrollView      *scrollView;
@property (readonly, nonatomic) NSMutableArray    *pagesArray;
@property (nonatomic)           CGFloat            spaceBetweenViews;
@property (readonly)            NSUInteger         numberOfPages;
@property (readonly)            UIViewController  *currentViewController;
@property (nonatomic)           NSUInteger         currentPage; // no animation upon change
@property (nonatomic)           BOOL               usePageControl; // YES by default -- if no && [pageControl isSubviewOfView:self.view] -> no pageControl
@property (weak, nonatomic)     id<JKPagingViewControllerDelegate> delegate;

// If pageControl equals nil, a new UIPageControl is initilized and put on self.view
- (id)initWithView:(UIView *)view andPageControl:(UIPageControl *)pageControl; // Designated Initilizer

- (void)addPageWithViewController:(UIViewController *)viewController;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;// zero-based index
- (void)removePageAtIndex:(NSUInteger)index;// zero-based index
- (BOOL)currentPageIsLastPage;
- (BOOL)currentPageIsFirstPage;
- (NSUInteger)pageForViewController:(UIViewController *)viewController;
- (void)removeAllPages;

- (void)scrollToPage:(NSUInteger)index; // zero-based index

@end