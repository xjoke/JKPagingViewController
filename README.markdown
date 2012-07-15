# JKPagingViewController
by Jonas Keisel

## Getting started

This project includes a demo application (both for iPhone and iPad, though there is no difference), showing hot to create and configure an example JKPagingViewController.

### Creating the User Interface

1. Drag a UIView from the Utilities-Panel onto the Storyboard
2. Wire it up with an `IBOutlet` in your `UIViewController`
3. Optional: If you want a `UIPageControl` somewhere special, put one on your Storyboard and wire it up as well

### Setting up a JKPagingViewController

	JKPagingViewController *pagingViewController = [[JKPagingViewController alloc]  initWithView:self.pagingView andPageControl:self.pageControl];
	pagingViewController.dataSource = self;

The pageControl parameter may be nil. If this is the case, a `UIPageControl` is added automatically at the bottom of the view. To suppress a `UIPageControl`being shown automatically, just add this line:

	pagingViewController.usePageControl = NO;

### Providing data for the JKPagingViewController

The JKPagingViewController receives its data via a data-source-protocol.

	@interface MyViewController : NSObject <JKPagingViewControllerDataSource>

These Methods are required:

	- (NSUInteger)numberOfPagesInPagingViewController:(JKPagingViewController *)pagingViewController;
	- (UIViewController *)pagingViewController:(JKPagingViewController *)pagingViewController viewControllerAtIndex:(NSUInteger)index;

### Getting informed as soon as the page is changed

For this to happen, you have to set a delegate:

	pagingViewController.delegate = self;

Of course your UIViewController (or whichever class you choose to be the delegate) has to conform to a protocol:

	@interface MyViewController : NSObject <JKPagingViewControllerDataSource, JKPagingViewControllerDelegate>

These optional methods are called by the JKPagingViewController

	- (void)pagingController:(JKPagingViewController *)sender willChangeFromPage:(NSUInteger)from toPage:(NSUInteger)to;

##License

JKPagingViewController is released under its own license (which is included with the source code).