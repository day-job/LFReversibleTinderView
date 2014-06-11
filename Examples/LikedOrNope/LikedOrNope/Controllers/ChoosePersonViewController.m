//
// ChoosePersonViewController.m
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ChoosePersonViewController.h"
#import "Person.h"
#import "MDCSwipeToChoose.h"

#if 0
@interface LFReversibleTinderSubview: MDCSwipeToChooseView
@end
@implementation LFReversibleTinderSubview
@end

@interface LFReversibleTinderView: UIView <MDCSwipeToChooseDelegate>
@property (nonatomic) int index;
@property (nonatomic) int count;
// contains LFReversibleTinderSubview
@property (nonatomic, strong) NSArray*	swipe_views;	
//@property (nonatomic, strong) id		delegate;
@end

@implementation LFReversibleTinderView

#if 0
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.swipe_views = [NSMutableArray new];
		self.clipsToBounds = NO;
		//self.userInteractionEnabled = YES;
		//self.backgroundColor = [UIColor blueColor];
	}
	return self;
}
#endif

- (void)setSwipe_views:(NSArray*)views
{
	self.clipsToBounds = NO;
	//self.swipe_views = views;
	//[self.swipe_views setArray:views];

	self.index = 0;
	self.count = views.count;
	srandomdev();
	for (int i = 0; i < views.count; i++)
	{
		LFReversibleTinderSubview* view = views[i];
		LFReversibleTinderSubview* view_previous = nil;
		if (i > 0)
			view_previous = views[i - 1];

		MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
		//options.delegate = self.delegate;
		options.delegate = self;
		options.threshold = 160.f;
		options.previousView = view_previous;
		options.isLast = (i == (views.count - 1)) ? YES : NO;
		options.size = CGSizeMake(view.frame.size.width, view.frame.size.height);

		//	rotate
		float f = (float)random() / (float)RAND_MAX;
		f = f / 5.0 - 0.1;
		view.frame = CGRectMake( (self.frame.size.width - view.frame.size.width) / 2,
				(self.frame.size.height - view.frame.size.height) / 2,
				view.frame.size.width,
				view.frame.size.height);
		view.transform = CGAffineTransformMakeRotation(f);
		view.options = options;
		[view setupSwipeToChoose];

		if (view_previous)
			[self insertSubview:view belowSubview:view_previous];
		else
			[self addSubview:view];
	}
}

- (NSArray*)swipe_views
{
	NSLog(@"DEBUG LFReversibleTinderView: getter doesn't work for swipe_views, please retain your own copy");
	return nil;
}

#pragma mark delegate

- (void)viewDidSwipeCancel:(UIView*)view
{
	NSLog(@"current item: %i/%i", self.index + 1, self.count);
}

- (void)viewDidSwipePrevious:(UIView*)view
{
	self.index--;
}

- (void)viewDidSwipeNext:(UIView*)view
{
	self.index++;
}

@end
#endif


@interface ChoosePersonViewController ()
@property (nonatomic, strong) NSMutableArray *people;
@end

#if 1

@implementation ChoosePersonViewController

- (instancetype)init {
    self = [super init];
    if (self) {
		views = [[NSMutableArray alloc] init];
        _people = [[self defaultPeople] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	//	set up button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"liked"];
    button.frame = CGRectMake(140, 400, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self action:@selector(action_reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

	//	set up views
	for (int i = 0; i < 4; i++)
	{
		ChoosePersonView* view = [[ChoosePersonView alloc] 
			initWithFrame:CGRectMake(0, 0, 280, 360) person:self.people[i] options:nil];
		[views addObject:view];
	}

	//	set up swipe view
	LFReversibleTinderView* view_swipe = [[LFReversibleTinderView alloc] initWithFrame:CGRectMake(0, 60, 320, 320)];
	view_swipe.swipe_views = views;
	[self.view addSubview:view_swipe];
	NSLog(@"dummy: %@", view_swipe.swipe_views);
	//view_swipe.delegate = self;
	//self.view.userInteractionEnabled = YES;
}

- (void)action_reload {
    //[self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
	[[[UIApplication sharedApplication] delegate] performSelector:@selector(setController)];
#pragma clang diagnostic pop
}

#pragma mark delegate

- (void)viewDidSwipeCancel:(UIView*)view
{
	NSLog(@"cancelled");
}

- (void)viewDidSwipePrevious:(UIView*)view
{
	NSLog(@"swiped previous");
}

- (void)viewDidSwipeNext:(UIView*)view
{
	NSLog(@"swiped next");
}

#pragma mark data

- (NSArray *)defaultPeople {
    return @[
        [[Person alloc] initWithName:@"Finn"
                               image:[UIImage imageNamed:@"finn"]
                                 age:15
               numberOfSharedFriends:3
             numberOfSharedInterests:2
                      numberOfPhotos:1],
        [[Person alloc] initWithName:@"Jake"
                               image:[UIImage imageNamed:@"jake"]
                                 age:28
               numberOfSharedFriends:2
             numberOfSharedInterests:6
                      numberOfPhotos:8],
        [[Person alloc] initWithName:@"Fiona"
                               image:[UIImage imageNamed:@"fiona"]
                                 age:14
               numberOfSharedFriends:1
             numberOfSharedInterests:3
                      numberOfPhotos:5],
        [[Person alloc] initWithName:@"P. Gumball"
                               image:[UIImage imageNamed:@"prince"]
                                 age:18
               numberOfSharedFriends:1
             numberOfSharedInterests:1
                      numberOfPhotos:2],
    ];
}

@end

#else

static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@implementation ChoosePersonViewController

#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
		views = [[NSMutableArray alloc] init];
        // This view controller maintains a list of ChoosePersonView
        // instances to display.
        _people = [[self defaultPeople] mutableCopy];
    }
    return self;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];

	//	test
#if 0
	for (int i = 0; i < 4; i++)
	{
		ChoosePersonView* view = [[ChoosePersonView alloc] 
			initWithFrame:CGRectMake(20, 20, 280, 280) person:self.people[i] options:nil];
		[views addObject:view];
	}
	LFReversibleTinderView* view_swipe = [[LFReversibleTinderView alloc] initWithFrame:CGRectMake(0, 220, 320, 320)];
	view_swipe.delegate = self;
	view_swipe.subviews = views;
	[self.view addSubview:view_swipe];
#endif

	//	working code
#if 1
	srandomdev();
	int count = 4;
	for (int i = 0; i < count; i++)
	{
#if 0
		ChoosePersonView* view_previous = nil;
		if (i > 0)
			view_previous = views[i - 1];

		//	ChoosePersonView* view = [self alloc_view_frame: index:i];
		MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
		options.delegate = self;
		options.threshold = 160.f;
		options.previousView = view_previous;
		options.isLast = (i == 3) ? YES : NO;
		options.size = CGSizeMake(280, 280);
		options.onPan = ^(MDCPanState *state) {
			CGRect frame = [self backCardViewFrame];
			if (state.direction == MDCSwipeDirectionLeft)
			{
				self.backCardView.frame = CGRectMake(frame.origin.x,
													 frame.origin.y - (state.thresholdRatio * 10.f),
													 CGRectGetWidth(frame),
													 CGRectGetHeight(frame));
			}
		};
#endif

		CGRect frame = CGRectMake(20, 60, 280, 280);
		ChoosePersonView *view = [[ChoosePersonView alloc] 
			initWithFrame:frame person:self.people[i] options:nil];

		[views addObject:view];

#if 0
		//	rotate
		float f = (float)random() / (float)RAND_MAX;
		f = f / 5.0 - 0.1;
		view.transform = CGAffineTransformMakeRotation(f);

		if (view_previous)
			[self.view insertSubview:view belowSubview:view_previous];
		else
			[self.view addSubview:view];
#endif

#if 1
		//LFReversibleTinderSubview* view = views[i];
		LFReversibleTinderSubview* view_previous = nil;
		if (i > 0)
			view_previous = views[i - 1];

		MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
		options.delegate = self;
		options.threshold = 160.f;
		options.previousView = view_previous;
		options.isLast = (i == (count - 1)) ? YES : NO;
		options.size = CGSizeMake(280, 280);

		//	rotate
		float f = (float)random() / (float)RAND_MAX;
		f = f / 5.0 - 0.1;
		view.transform = CGAffineTransformMakeRotation(f);
		view.options = options;
		[view setupSwipeToChoose];

		if (view_previous)
			[self.view insertSubview:view belowSubview:view_previous];
		else
			[self.view addSubview:view];
		//	NSLog(@"%i view %i - %i", i, options.isLast, view);
#endif
	}
#endif
#if 0
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
	self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame] frontView:nil];
    [self.view addSubview:self.frontCardView];

    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
	self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame] frontView:self.frontCardView];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
#endif
    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    [self constructNopeButton];
    [self constructLikedButton];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

- (void)viewDidSwipeCancel:(UIView*)view
{
	NSLog(@"cancelled");
}

- (void)viewDidSwipePrevious:(UIView*)view
{
	NSLog(@"swiped previous");
}

- (void)viewDidSwipeNext:(UIView*)view
{
	NSLog(@"swiped next");
}

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentPerson.name);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentPerson.name);
    } else {
        NSLog(@"You liked %@.", self.currentPerson.name);
    }

#if 0
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
	self.previousCardView = self.frontCardView;
    self.frontCardView = self.backCardView;
	if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame] frontView:self.frontCardView])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
	[self.view addSubview:self.previousCardView];
	//AntiARCRetain(self.previousCardView);
#endif
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(ChoosePersonView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentPerson = frontCardView.person;
}

- (NSArray *)defaultPeople {
    // It would be trivial to download these from a web service
    // as needed, but for the purposes of this sample app we'll
    // simply store them in memory.
    return @[
        [[Person alloc] initWithName:@"Finn"
                               image:[UIImage imageNamed:@"finn"]
                                 age:15
               numberOfSharedFriends:3
             numberOfSharedInterests:2
                      numberOfPhotos:1],
        [[Person alloc] initWithName:@"Jake"
                               image:[UIImage imageNamed:@"jake"]
                                 age:28
               numberOfSharedFriends:2
             numberOfSharedInterests:6
                      numberOfPhotos:8],
        [[Person alloc] initWithName:@"Fiona"
                               image:[UIImage imageNamed:@"fiona"]
                                 age:14
               numberOfSharedFriends:1
             numberOfSharedInterests:3
                      numberOfPhotos:5],
        [[Person alloc] initWithName:@"P. Gumball"
                               image:[UIImage imageNamed:@"prince"]
                                 age:18
               numberOfSharedFriends:1
             numberOfSharedInterests:1
                      numberOfPhotos:2],
    ];
}

- (ChoosePersonView*)alloc_view_frame:(CGRect)frame index:(int)index
{
	ChoosePersonView* previousView = nil;
	if (index > 0)
		previousView = views[index - 1];

    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
	options.previousView = previousView;
	options.isLast = (index == 3) ? YES : NO;
	options.size = CGSizeMake(280, 280);
    options.onPan = ^(MDCPanState *state) {
        CGRect frame = [self backCardViewFrame];
		if (state.direction == MDCSwipeDirectionLeft)
		{
			self.backCardView.frame = CGRectMake(frame.origin.x,
												 frame.origin.y - (state.thresholdRatio * 10.f),
												 CGRectGetWidth(frame),
												 CGRectGetHeight(frame));
		}
    };

    ChoosePersonView *personView = [[ChoosePersonView alloc] 
		initWithFrame:frame person:self.people[index] options:options];

    return personView;
}

- (ChoosePersonView *)popPersonViewWithFrame:(CGRect)frame frontView:(UIView*)frontView {
    if ([self.people count] == 0) {
        return nil;
    }

    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
	options.previousView = frontView;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
		if (state.direction == MDCSwipeDirectionLeft)
			self.backCardView.frame = CGRectMake(frame.origin.x,
												 frame.origin.y - (state.thresholdRatio * 10.f),
												 CGRectGetWidth(frame),
												 CGRectGetHeight(frame));
		//	else if (state.direction == MDCSwipeDirectionRight) self.previousCardView.frame = frame;
    };

    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                    person:self.people[0]
                                                                   options:options];
    [self.people removeObjectAtIndex:0];
    return personView;
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 60.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

// Create and add the "nope" button.
- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"nope"];
    button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY([views[0] frame]) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:247.f/255.f
                                         green:91.f/255.f
                                          blue:37.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"liked"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY([views[0] frame]) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    //[self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
	[[[UIApplication sharedApplication] delegate] performSelector:@selector(setController)];
#pragma clang diagnostic pop
}

@end
#endif
