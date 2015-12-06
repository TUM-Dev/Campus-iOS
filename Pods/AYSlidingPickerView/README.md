# AYSlidingPickerView

[![Version](https://img.shields.io/cocoapods/v/AYSlidingPickerView.svg?style=flat)](http://cocoapods.org/pods/AYSlidingPickerView)
[![License](https://img.shields.io/cocoapods/l/AYSlidingPickerView.svg?style=flat)](http://cocoapods.org/pods/AYSlidingPickerView)
[![Platform](https://img.shields.io/cocoapods/p/AYSlidingPickerView.svg?style=flat)](http://cocoapods.org/pods/AYSlidingPickerView)

Implementation of a picker view that can be shown by either tapping on or panning the navigation bar.

<p>
  <a href='https://appetize.io/app/9n9g6bkyt0z82byg7tbm9mtwmr' 'alt='Live demo'>
    <img width="50" height="60" src="Assets/demo.png"/>
  </a>
</p>

<img width="300" alt="AYGestureHelpView" src="Assets/screencast.gif"/>

## Usage

`AYSlidingPickerView` can be used either as a singleton or as a regular object. In both cases it is necessary to specify the `mainView` and `items` properties.

`mainView` is simply the view that is currently displayed in the app's window. In most cases, it's just `self.view` in a view controller.

`items` must consist of `AYSlidingPickerViewItem` objects. You can generate them as follows:
```objc
NSMutableArray *items = [NSMutableArray new];
for (NSString *title in titles) {
  AYSlidingPickerViewItem *item = [[AYSlidingPickerViewItem alloc] initWithTitle:title handler:^(BOOL completed) {
    // Action to be performed on selection
  }];
  [items addObject:item];
}
```

For more information, please refer to the example and documentation.

## Installation

AYSlidingPickerView is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "AYSlidingPickerView"
```

## Author

Ayan Yenbekbay, ayan.yenb@gmail.com

## License

```
Copyright (c) 2015 Ayan Yenbekbay <ayan.yenb@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
