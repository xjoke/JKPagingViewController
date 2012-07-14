//
//  JKViewController.m
//  JKPagingScrollView
//
//  Version 1.0
//
//  Created by Keisel Jonas on 12.07.12.
//  Copyright (c) 2012 Jonas Keisel. All rights reserved.
//

#import "JKViewController.h"
#import "JKPagingViewController.h"

@interface JKViewController () <JKPagingViewControllerDelegate>

@property (strong, nonatomic) JKPagingViewController *pagingViewController;
@property (strong, nonatomic) NSMutableArray *colorArray;

@end

@implementation JKViewController
@synthesize pagingView = _pagingView;
@synthesize pageControl = _pageControl;
@synthesize colorArray = _colorArray;
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
	self.pagingViewController = [[JKPagingViewController alloc] initWithView:self.pagingView andPageControl:self.pageControl];
    self.pagingViewController.spaceBetweenViews = 0;
    self.pagingViewController.delegate = self;
    self.colorArray = [NSMutableArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor blackColor], [UIColor yellowColor], nil];
    for (UIColor *colour in self.colorArray)
        [self.pagingViewController addPageWithViewController:[self viewControllerWithViewWithBackgroundColour:colour]];
    self.pagingViewController.currentPage = 1;
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

- (void)pagingController:(JKPagingViewController *)sender willChangeFromPage:(NSUInteger)from toPage:(NSUInteger)to
{
    NSLog(@"Changed from page %i to page %i", from, to);
}

- (IBAction)remove:(UIButton *)sender 
{
    [self.pagingViewController removePageAtIndex:self.pagingViewController.currentPage];
}

- (IBAction)add:(UIBarButtonItem *)sender 
{
    [self.pagingViewController addPageWithViewController:[self viewControllerWithViewWithBackgroundColour:[self.colorArray objectAtIndex:self.pagingViewController.numberOfPages % self.colorArray.count]]];
}

- (IBAction)last:(UIBarButtonItem *)sender 
{
    [self.pagingViewController scrollToPage:self.pagingViewController.numberOfPages-1];
}
@end
