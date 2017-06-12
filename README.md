# LFReversibleTinderView

This library is based on MDCSwipeToChoose, and as the name suggested, it's reversible.

To use it, simply add "pod 'LFReversibleTinderView'" in your Podfile, and then do "pod install" and import "LFReversibleTinderView.h" to get started.

### Swift 3.1 Example

	func setup_tinder() {
		let view_tinder = LFReversibleTinderView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
		view_tinder.backgroundColor = .green
		let views = NSMutableArray()
		for _ in 0 ..< 10 {
			let view_test = LFReversibleTinderSubview(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
			view_test.backgroundColor = .blue
			views.add(view_test)
		}
		view_tinder.swipe_views = views
		view.addSubview(view_tinder)
	}

### Objective-C Exmple

In the LikedOrNope example, ChoosePersonView is a subview of LFReversibleTinderSubview. You need to set up your subviews first:

	//	set up views
	for (int i = 0; i < 4; i++)
	{
		ChoosePersonView* view = [[ChoosePersonView alloc] 
			initWithFrame:CGRectMake(0, 0, 280, 360) person:self.people[i] options:nil];
		[views addObject:view];
	}

And then set up the tinder-like view:

	//	set up swipe view
	LFReversibleTinderView* view_swipe = [[LFReversibleTinderView alloc] initWithFrame:CGRectMake(0, 60, 320, 320)];
	view_swipe.swipe_views = views;

And add it as subview:

	[self.view addSubview:view_swipe];

Done. Please note the the following section about MDCSwipeToChoose may not work with this lib, please get the origin one if you don't want the "reverse" part.

The feature is there but this lib is still under tweak, so use it at your own risk. Checkour LFramework if you want some convinient helpers too! - https://github.com/superarts/LFramework

# MDCSwipeToChoose

[![Build Status](https://travis-ci.org/modocache/MDCSwipeToChoose.svg?branch=master)](https://travis-ci.org/modocache/MDCSwipeToChoose)

Swipe to "like" or "dislike" any view, just like Tinder.app. Build a flashcard app, a photo viewer, and more, in minutes, not hours!

- Use `UIView+MDCSwipeToChoose` to add a swipe gesture and callbacks to any `UIView`.
- Use `MDCSwipeToChooseView` to get a UI nearly identical to Tinder.app in just a few lines of code.

![](http://cl.ly/image/0M1j1J0E0s3G/MDCSwipeToChoose-v0.2.0.gif)

You may view slides on some the architecture decisions that went into this library [here](http://modocache.io/ios-ui-component-api-design).

## How to Install via CocoaPods

Place the following in your Podfile and run `pod install`:

```objc
pod "MDCSwipeToChoose"
```

## How to Use

Check out [the sample app](https://github.com/modocache/MDCSwipeToChoose/tree/master/Examples/LikedOrNope) for an example of how to use `MDCSwipeToChooseView` to build the UI in the GIF above.

> **NOTE:** You must run `pod install` in the `Examples/LikedOrNope` directory before building the example app.

Every public class contains documentation in its header file.

### Swiping Yes/No

The following is an example of how you can use `MDCSwipeToChooseView` to display a photo. The user can choose to delete it by swiping left, or save it by swiping right.

```objc
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

// ... in a view controller

#pragma mark - Creating and Customizing a MDCSwipeToChooseView

- (void)viewDidLoad {
    [super viewDidLoad];

    // You can customize MDCSwipeToChooseView using MDCSwipeToChooseViewOptions.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.likedText = @"Keep";
    options.likedColor = [UIColor blueColor];
    options.nopeText = @"Delete";
    options.onPan = ^(MDCPanState *state){
        if (state.thresholdRatio == 1.f && state.direction == MDCSwipeDirectionLeft) {
            NSLog(@"Let go now to delete the photo!");
        }
    };

    MDCSwipeToChooseView *view = [[MDCSwipeToChooseView alloc] initWithFrame:self.view.bounds
                                                                     options:options];
    view.imageView.image = [UIImage imageNamed:@"photo"];
    [self.view addSubview:view];
}

#pragma mark - MDCSwipeToChooseDelegate Callbacks

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"Photo deleted!");
    } else {
        NSLog(@"Photo saved!");
    }
}
```

As of version 0.2.0, you may also swipe a view programmatically:

```objc
[self.swipeToChooseView mdc_swipe:MDCSwipeDirectionLeft];
```

## More Generic Swiping

You don't have to use a subclass of `MDCChooseView`. You can use the `mdc_swipeToChooseSetup:` method on any `UIView` to enable swipe-to-choose.

In the following example, we adjust the opacity of a `UIWebView` when it's panned left and right.

```objc
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

// ... in a view controller

- (void)viewDidLoad {
    [super viewDidLoad];

    MDCSwipeOptions *options = [MDCSwipeOptions new];
    options.delegate = self;
    options.onPan = ^(MDCPanState *state){
        switch (state.direction) {
            case MDCSwipeDirectionLeft:
                self.webView.alpha = 0.5f - state.thresholdRatio;
                break;
            case MDCSwipeDirectionRight:
                self.webView.alpha = 0.5f + state.thresholdRatio;
                break;
            case MDCSwipeDirectionNone:
                self.webView.alpha = 0.5f;
                break;
        }
    };
    [self.webView mdc_swipeToChooseSetup:options];
}
```

## License

All the source code is distributed under the [MIT license](http://www.opensource.org/licenses/mit-license.php). See the LICENSE file for details. The license does not apply to the images used in the sample apps.