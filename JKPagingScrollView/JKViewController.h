//
//  JKViewController.h
//  JKPagingScrollView
//
//  Version 2.0
//
//  Created by Keisel Jonas on 12.07.12.
//  Copyright (c) 2012 Jonas Keisel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *pagingView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)remove:(UIBarButtonItem *)sender;
- (IBAction)add:(UIBarButtonItem *)sender;
- (IBAction)last:(UIBarButtonItem *)sender;

@end
