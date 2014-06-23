#import "LFReversibleTinderView.h"


@implementation LFReversibleTinderSubview
@end


@implementation LFReversibleTinderView

#if 1
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
	//self.clipsToBounds = NO;
	[swipe_views setArray:views];
	//[self.swipe_views setArray:views];
	[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

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
	//	NSLog(@"DEBUG LFReversibleTinderView: getter doesn't work for swipe_views, please retain your own copy");
	return swipe_views;
}

#pragma mark delegate

- (void)viewDidSwipeCancel:(UIView*)view
{
	//NSLog(@"current item: %i/%i", self.index + 1, self.count);
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
