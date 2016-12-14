//
//  ASWeekSelectorView.h
//  ASWeekSelectorView
//
//  Created by Adrian Schoenig on 15/04/2014.
//  Copyright © 2016 Adrian Schoenig. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for ASWeekSelectorView.
FOUNDATION_EXPORT double ASWeekSelectorViewVersionNumber;

//! Project version string for ASWeekSelectorView.
FOUNDATION_EXPORT const unsigned char ASWeekSelectorViewVersionString[];



@protocol ASWeekSelectorViewDelegate;

/**
 A mini week view to select a day. You can swipe through weeks and tap on days to select them, somewhat similar to the iOS 7 calendar app.
 
 It's using the methodology described in Apple's WWDC 2011 session 104 "Advanced ScrollView Techniques".
 */
@interface ASWeekSelectorView : UIView

/**
 The delegate conforming to the `ASWeekSelectorViewDelegate` delegate.
 */
@property (nonatomic, weak) id<ASWeekSelectorViewDelegate> delegate;

/**
 Index of the first day of the week, same as used by `NSCalendar`.
 @default 1, i.e., Sunday
 */
@property (nonatomic, assign) NSUInteger firstWeekday;

/**
 Text color of the big numbers
 */
@property (nonatomic, strong) UIColor *numberTextColor;

/**
 Text color of the small letter labels
 */
@property (nonatomic, strong) UIColor *letterTextColor;

/**
 Locale used for formatting dates
 @default `autoupdatingCurrentLocale`
 */
@property (nonatomic, strong) NSLocale *locale;

/**
 The selected date which is highlighted in the view. When setting this property, the view will also jump to show that date.
 */
@property (nonatomic, strong) NSDate *selectedDate;

/**
 @param selectedDate The date to be selected and shown.
 @param animated     Selection should be animated.
 */
- (void)setSelectedDate:(NSDate *)selectedDate animated:(BOOL)animated;

/**
 Triggers a refresh of the week view, which calls again the delegate methods
 for configuring colours and the indicators. Call this if your underlying
 data has changed and you need those valus refreshed.
 */
- (void)refresh;

@end

@protocol ASWeekSelectorViewDelegate <NSObject>

@optional

/**
 Called on the delegate whenever the user interacts with the view and selects a new date. Called immediately after selection commenced.
 
 @param weekSelector The week selector that the user interacted with.
 @param date         The selected date.
 */
- (void)weekSelector:(ASWeekSelectorView *)weekSelector willSelectDate:(NSDate *)date;

/**
 Called on the delegate whenever the user interacts with the view and selects a new date. Called after any animations are completed.
 
 @param weekSelector The week selector that the user interacted with.
 @param date         The selected date.
 */
- (void)weekSelector:(ASWeekSelectorView *)weekSelector didSelectDate:(NSDate *)date;

/**
 Called when the user did actively swipe to a new week.
 
 @note `weekSelector:selectedDate:` will also be called right after this.
 
 @param weekSelector The week selector that the user interacted with.
 */
- (void)weekSelectorDidSwipe:(ASWeekSelectorView *)weekSelector;

/**
 Implement to draw a circle (stroke only) around the specified date.
 @param date Date for which to customise color (not called for selected date)
 @return Color of the highlighter circle, or `nil` if no circle
 */
- (UIColor *)weekSelector:(ASWeekSelectorView *)weekSelector circleColorForDate:(NSDate *)date;

/**
 Implement to change the color of the number for the specified date.
 @param date Date for which to customise color (not called for selected date)
 @return Color of number label, or `nil` to use default `numberTextColor`
 */
- (UIColor *)weekSelector:(ASWeekSelectorView *)weekSelector numberColorForDate:(NSDate *)date;

/**
 Implement to allow showing a dot below the number for the specified date.
 @param date Date for which to show a dot (or not)
 @return Whether an indicator dot should be shown
 */
- (BOOL)weekSelector:(ASWeekSelectorView *)weekSelector showIndicatorForDate:(NSDate *)date;

@end
