#import "MDCSwipeToChoose.h"


//	name wrap
@interface LFReversibleTinderSubview: MDCSwipeToChooseView
@end


@interface LFReversibleTinderView: UIView <MDCSwipeToChooseDelegate>
{
	NSMutableArray*	swipe_views;
}
@property (nonatomic) int index;
@property (nonatomic) int count;
// contains LFReversibleTinderSubview
@property (nonatomic, strong) NSMutableArray*	swipe_views;	
//@property (nonatomic, strong) id		delegate;

@end
