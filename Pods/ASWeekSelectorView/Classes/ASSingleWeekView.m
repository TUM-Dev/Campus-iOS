//
//  ASSingleWeekView.m
//  ASWeekSelectorView
//
//  Created by Adrian Schoenig on 16/04/2014.
//  Copyright (c) 2014 Adrian Schoenig. All rights reserved.
//

#import "ASSingleWeekView.h"

@interface ASSingleWeekView ()

@property (nonatomic, strong) NSCalendar *gregorian;

@end

@implementation ASSingleWeekView

#pragma mark - Public methods

- (void)setStartDate:(NSDate *)startDate
{
  _startDate = startDate;
  
  [self rebuildView];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapper:)];
    [self addGestureRecognizer:tapper];
  }
  return self;
}

#pragma mark - User interaction

- (void)handleTapper:(UITapGestureRecognizer *)tapper
{
  CGPoint location = [tapper locationInView:self];
  UIView *subview = [self hitTest:location withEvent:nil];
  NSUInteger dayOffset = subview.tag;
  
  NSDate *date = [self dateByAddingDays:dayOffset toDate:self.startDate];
  [self.delegate singleWeekView:self didSelectDate:date atFrame:subview.frame];
}

#pragma mark - Private helpers

- (NSDate *)dateByAddingDays:(NSInteger)days toDate:(NSDate *)date
{
  if (days == 0) {
    return date;
  }
  
  NSDateComponents *components = [[NSDateComponents alloc] init];
  [components setDay:days];
  return [self.gregorian dateByAddingComponents:components toDate:date options:0];
}

- (void)rebuildView
{
  for (NSInteger index = self.subviews.count - 1; index >= 0; index--) {
    UIView *subview = self.subviews[index];
    [subview removeFromSuperview];
  }
  CGFloat widthPerItem = CGRectGetWidth(self.frame) / 7;
  CGFloat itemHeight = CGRectGetHeight(self.frame);
  for (NSUInteger dayIndex = 0; dayIndex < 7; dayIndex++) {
    NSDate *date = [self dateByAddingDays:dayIndex toDate:self.startDate];
    CGRect frame = CGRectMake(dayIndex * widthPerItem, 0, widthPerItem, itemHeight);
    UIView *view = [self.delegate singleWeekView:self
                                     viewForDate:date
                                       withFrame:frame];
    view.tag = dayIndex;
    [self addSubview:view];
  }
}

@end
