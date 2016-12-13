# `ASWeekSelectorView`

[![Badge w/ Version](http://cocoapod-badges.herokuapp.com/v/ASWeekSelectorView/badge.png)](http://cocoadocs.org/docsets/ASWeekSelectorView)
[![Badge w/ Platform](http://cocoapod-badges.herokuapp.com/p/ASWeekSelectorView/badge.png)](http://cocoadocs.org/docsets/ASWeekSelectorView)

A mini week view to select a day. You can swipe through weeks and tap on a day to select them, somewhat similar to the iOS 7 calendar app.
 
It's using the methodology described in Apple's excellent WWDC 2011 session 104 "Advanced ScrollView Techniques".

![Week selector](http://cl.ly/image/0L1H2r2y140e/weekselector.mov.gif)

# Setup

1) Add to your Podfile:

```ruby
pod 'ASWeekSelectorView', '~> 0.4.0'
```

2) Add an instance of `ASWeekSelectorView` to your view hierarchy, configure it, provide a delegate and implement the delegate smethod. (Note that you won't need to use `ASDaySelectionView` and `ASSingleWeekView` yourself - they are internal helper class.)

3) When using Auto Layout, adjust the frame in `viewWillLayoutSubviews`:

```swift
override func viewWillLayoutSubviews() {
  super.viewWillLayoutSubviews()
  weekSelector.frame.size.width = self.view.frame.width
}
```

```objective-c
- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  CGRect frame = self.weekSelector.frame;
  frame.size.width = CGRectGetWidth(self.view.frame);
  self.weekSelector.frame = frame;
}
```


# Example

See the included example project for a very basic implementation.
