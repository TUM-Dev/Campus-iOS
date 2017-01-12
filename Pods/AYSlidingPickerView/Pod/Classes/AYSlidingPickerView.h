//
//  AYSlidingPickerView.h
//  AYSlidingPickerView
//
//  Created by Ayan Yenbekbay on 11/18/2015.
//  Copyright (c) 2015 Ayan Yenbekbay. All rights reserved.
//

typedef enum {
  AYSlidingPickerViewShownState,
  AYSlidingPickerViewClosedState,
  AYSlidingPickerViewDisplayingState
} AYSlidingPickerViewState;

@interface AYSlidingPickerViewItem : NSObject

#pragma mark Properties

/**
 *  Action to be performed on selection.
 */
@property (copy, nonatomic) void (^handler)(BOOL completed);
/**
 *  String to be displayed in the picker view.
 */
@property (copy, nonatomic) NSString *title;

#pragma mark Methods

/**
 *  Creates an item for the picker view with the specified title and handler.
 *
 *  @param title   String to be displayed in the picker view.
 *  @param handler Action to be performed on selection.
 *
 *  @return Newly created picker view item.
 */
- (AYSlidingPickerViewItem *)initWithTitle:(NSString *)title handler:(void (^)(BOOL completed))handler;

@end

@interface AYSlidingPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

#pragma mark Properties

/**
 *  Indicates whether or not the picker view should be closed on selection of an item.
 */
@property (nonatomic) BOOL closeOnSelection;
/**
 *  Array of AYSlidingPickerViewItem objects providing data for the picker view.
 */
@property (nonatomic) NSArray *items;
/**
 *  Holds the index of the current selected item in the picker view.
 */
@property (nonatomic) NSUInteger selectedIndex;
/**
 *  Color for the item labels in the picker view.
 */
@property (nonatomic) UIColor *itemColor;
/**
 *  Font for the item labels in the picker view.
 */
@property (nonatomic) UIFont *itemFont;
/**
 *  Current visible view in the window. Must be specified before showing the picker view.
 */
@property (weak, nonatomic) UIView *mainView;
/**
 *  Current state of the picker view.
 */
@property (nonatomic, readonly) AYSlidingPickerViewState state;
/**
 *  Indicates whether or not the picker view is allowed to be shown.
 */
@property (nonatomic, getter=isDisabled) BOOL disabled;
/**
 *  A block that will be fired before the picker view appears.
 */
@property (nonatomic, copy) void (^willAppearHandler)();
/**
 *  A block that will be fired after the picker view appears.
 */
@property (nonatomic, copy) void (^didAppearHandler)();
/**
 *  A block that will be fired before the picker view is dismissed.
 */
@property (nonatomic, copy) void (^willDismissHandler)();
/**
 *  A block that will be fired after the picker view is dismissed.
 */
@property (nonatomic, copy) void (^didDismissHandler)();

#pragma mark Methods

/**
 *  Access the shared AYSlidingPickerView object.
 *
 *  @return Shared AYSlidingPickerView object.
 */
+ (AYSlidingPickerView *)sharedInstance;
/**
 *  Performs the animation to show the picker view, blocks user interaction in the specified main view.
 */
- (void)show;
/**
 *  Performs the animation to hide the picker view, enables user interaction in the specified main view.
 */
- (void)dismiss;
/**
 *  Performs the animation to show the picker view, blocks user interaction in the specified main view.
 *
 *  @param completion Action to be performed after the animation completes.
 */
- (void)showWithCompletion:(void (^)(BOOL))completion;
/**
 *  Performs the animation to hide the picker view, enables user interaction in the specified main view.
 *
 *  @param completion Action to be performed after the animation completes.
 */
- (void)dismissWithCompletion:(void (^)(BOOL))completion;
/**
 *  Appends tap and pan gesture recognizers to the specified navigation bar.
 *  Consequently, tapping on or panning the navigation bar either shows or hides the picker view based on the current state.
 *  @discussion Usually, this method is called in the <code>viewWillAppear</code> method of a view controller.
 *
 *  @param navigationBar Navigation bar to add gesture recognizers to.
 */
- (void)addGestureRecognizersToNavigationBar:(UINavigationBar *)navigationBar;
/**
 *  Removes tap and pan gesture recognizers from the specified navigation bar.
 *  @discussion Usually, this method is called in the <code>viewWillDisappear</code> method of a view controller.
 *  Alternatively, you can just call <code>addGestureRecognizersToNavigationBar:</code> with another navigation bar, and the gesture recognizers
 *  will be automatically removed from the previous active navigation bar.
 *
 *  @param navigationBar Navigation bar to remove gesture recognizers from.
 */
- (void)removeGestureRecognizersFromNavigationBar:(UINavigationBar *)navigationBar;

@end
