//
//  JKViewController.m
//  JKPagingScrollView
//
//  Version 2.0
//
//  Created by Keisel Jonas on 12.07.12.
//  Copyright (c) 2012 Jonas Keisel. All rights reserved.
//

#import "JKViewController.h"
#import "JKPagingViewController.h"

@interface JKViewController () <JKPagingViewControllerDelegate, JKPagingViewControllerDataSource>

@property (strong, nonatomic) JKPagingViewController *pagingViewController;
@property (strong, nonatomic) NSMutableArray *colorArray;
@property (strong, nonatomic) NSMutableArray *viewControllerArray;

@end

@implementation JKViewController
@synthesize pagingView = _pagingView;
@synthesize pageControl = _pageControl;
@synthesize colorArray = _colorArray;
@synthesize viewControllerArray = _viewControllerArray;
@synthesize pagingViewController = _pagingViewController;

- (UIViewController *)viewControllerWithViewWithBackgroundColour:(UIColor *)colour
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = colour;
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.colorArray = [NSMutableArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor blackColor], [UIColor yellowColor], nil];
    self.viewControllerArray = [NSMutableArray array];
    
	self.pagingViewController = [[JKPagingViewController alloc] initWithView:self.pagingView andPageControl:self.pageControl];
    self.pagingViewController.delegate = self;
    self.pagingViewController.dataSource = self;
    
    for (int i = 0; i < 4; i++)
        [self.viewControllerArray addObject:[self viewControllerWithViewWithBackgroundColour:[self.colorArray objectAtIndex:self.pagingViewController.numberOfPages % self.colorArray.count]]];
    [self.pagingViewController reloadPages];
}

- (void)viewDidUnload
{
    [self setPagingView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (NSUInteger)numberOfPagesInPagingViewController:(JKPagingViewController *)pagingViewController
{
    return self.viewControllerArray.count;
}

- (UIViewController *)pagingViewController:(JKPagingViewController *)pagingViewController viewControllerAtIndex:(NSUInteger)index
{
    return [self.viewControllerArray objectAtIndex:index];
}

- (void)pagingController:(JKPagingViewController *)sender willChangeFromPage:(NSUInteger)from toPage:(NSUInteger)to
{
    NSLog(@"Changed from page %i to page %i", from, to);
}

- (IBAction)remove:(UIButton *)sender 
{
    [self.viewControllerArray removeObjectAtIndex:self.pagingViewController.currentPage];
    [self.pagingViewController reloadPages];
}

- (IBAction)add:(UIBarButtonItem *)sender 
{
    [self.viewControllerArray addObject:[self viewControllerWithViewWithBackgroundColour:[self.colorArray objectAtIndex:self.pagingViewController.numberOfPages % self.colorArray.count]]];
    [self.pagingViewController reloadPages];
}

- (IBAction)last:(UIBarButtonItem *)sender 
{
    [self.pagingViewController scrollToPage:self.pagingViewController.numberOfPages-1];
}
@end
