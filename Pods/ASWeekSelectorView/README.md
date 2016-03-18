# `ASWeekSelectorView`

[![Badge w/ Version](http://cocoapod-badges.herokuapp.com/v/ASWeekSelectorView/badge.png)](http://cocoadocs.org/docsets/ASWeekSelectorView)
[![Badge w/ Platform](http://cocoapod-badges.herokuapp.com/p/ASWeekSelectorView/badge.png)](http://cocoadocs.org/docsets/ASWeekSelectorView)

A mini week view to select a day. You can swipe through weeks and tap on a day to select them, somewhat similar to the iOS 7 calendar app.
 
It's using the methodology described in Apple's excellent WWDC 2011 session 104 "Advanced ScrollView Techniques".

![Week selector](http://cl.ly/image/0L1H2r2y140e/weekselector.mov.gif)

# Setup

1) Add to your Podfile:

        pod 'ASWeekSelectorView', '~> 0.3.0'

2) Add an instance of `ASWeekSelectorView` to your view hierarchy, configure it, provide a delegate and implement the delegate method. (Note that you won't need to use `ASSingleWeekView` yourself - it's just a helper class.)

# Example

See the included example project for a very basic implementation.
