//
//  ASWeekSelectorView.m
//  TripGo
//
//  Created by Adrian Schoenig on 15/04/2014.
//
//

#import "ASWeekSelectorView.h"

#import "ASSingleWeekView.h"
#import "ASDaySelectionView.h"

#define WEEKS 3


@interface ASContainerView : UIView
@property (nonatomic, assign, getter = isAccessibilityElement) BOOL accessibilityElement;
@end
@implementation ASContainerView
@end

@interface ASWeekSelectorView () <ASSingleWeekViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *singleWeekViews;
@property (nonatomic, weak) ASDaySelectionView *selectionView;
@property (nonatomic, strong) ASDaySelectionView *todayView;
@property (nonatomic, weak) UIView *lineView;

// for animating the selection view
@property (nonatomic, assign) CGFloat preDragSelectionX;
@property (nonatomic, assign) CGFloat preDragOffsetX;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isSettingFrame;

@property (nonatomic, strong) NSDateFormatter *dayNameDateFormatter;
@property (nonatomic, strong) NSDateFormatter *dayNumberDateFormatter;
@property (nonatomic, strong) NSDateFormatter *accessibilityDateFormatter;
@property (nonatomic, strong) NSCalendar *gregorian;
@property (nonatomic, strong) NSDate *lastToday; // to check when we need to update our 'today' time stamp

// formatting
@property (nonatomic, strong) UIColor *selectorLetterTextColor;
@property (nonatomic, strong) UIColor *selectorBackgroundColor;
@property (nonatomic, strong) UIColor *lineColor;

@end

@implementation ASWeekSelectorView

#pragma mark - Public methods

- (void)setFirstWeekday:(NSUInteger)firstWeekday
{
  _firstWeekday = firstWeekday;
  
  [self rebuildWeeks];
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
  [self setSelectedDate:selectedDate animated:NO];
}

- (void)setSelectedDate:(NSDate *)selectedDate animated:(BOOL)animated
{
  if (!self.lastToday || ![self date:self.lastToday matchesDateComponentsOfDate:[NSDate date]]) {
    [self rebuildWeeks];
  }
  
  if (! [self date:selectedDate matchesDateComponentsOfDate:_selectedDate]) {
    [self colorLabelForDate:_selectedDate withTextColor:self.numberTextColor];
    _selectedDate = selectedDate;
    self.isAnimating = animated;
    
    [UIView animateWithDuration:animated ? 0.25f : 0
                     animations:
     ^{
       [self rebuildWeeks];
     }
                     completion:
     ^(BOOL finished) {
       self.isAnimating = NO;
       [self colorLabelForDate:_selectedDate withTextColor:self.selectorLetterTextColor];
     }];
  }
}

- (void)setLocale:(NSLocale *)locale
{
  _locale = locale;
  [self updateDateFormatters];
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self didInit:YES];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self didInit:YES];
  }
  return self;
}

- (void)setFrame:(CGRect)frame
{
  self.isSettingFrame = YES;
  BOOL didChange = !CGRectEqualToRect(frame, self.frame);
  
  [super setFrame:frame];
  
  if (didChange) {
    _selectionView = nil;
    _todayView = nil;
    for (UIView *view in [self subviews]) {
      [view removeFromSuperview];
    }
    [self didInit:NO];
  }
  self.isSettingFrame = NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if (self.preDragOffsetX == MAXFLOAT) {
    self.preDragOffsetX = scrollView.contentOffset.x;
    self.preDragSelectionX = CGRectGetMinX(self.selectionView.frame);
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (self.singleWeekViews.count <= 0 || self.isSettingFrame) {
    return; // not ready yet
  }
  
  CGPoint offset = scrollView.contentOffset;
  BOOL updatedOffset = NO;
  
  // place the selection views
  if (self.preDragOffsetX < MAXFLOAT) {
    CGFloat selectionX = self.preDragSelectionX - (offset.x - self.preDragOffsetX);
    
    CGRect selectionViewFrame = self.selectionView.frame;
    selectionViewFrame.origin.x = selectionX;
    self.selectionView.frame = selectionViewFrame;
  }
  
  // prevent horizontal scrolling
  if (offset.y != 0) {
    offset.y = 0;
    updatedOffset = YES;
  }
  
  CGFloat width = CGRectGetWidth(scrollView.frame);
  if (offset.x >= width * 2 || offset.x <= 0) {
    // swap things around
    ASSingleWeekView *week0 = self.singleWeekViews[0];
    ASSingleWeekView *week1 = self.singleWeekViews[1];
    ASSingleWeekView *week2 = self.singleWeekViews[2];
    CGRect leftFrame    = week0.frame;
    CGRect middleFrame  = week1.frame;
    CGRect rightFrame   = week2.frame;
    
    if (offset.x <= 0) {
      // 0 and 1 move right
      week0.frame = middleFrame;
      week1.frame = rightFrame;
      self.singleWeekViews[1] = week0;
      self.singleWeekViews[2] = week1;
      
      // 2 get's updated to -1
      week2.startDate = [self dateByAddingDays:-7 toDate:week0.startDate];
      week2.frame = leftFrame;
      self.singleWeekViews[0] = week2;
      
      if ([self.delegate respondsToSelector:@selector(weekSelectorDidSwipe:)]) {
        [self.delegate weekSelectorDidSwipe:self];
      }
      NSDate *date = [self dateByAddingDays:-7 toDate:self.selectedDate];
      [self userWillSelectDate:date];
      [self userDidSelectDate:date];
      
    } else {
      // 1 and 2 move to the left
      week1.frame = leftFrame;
      week2.frame = middleFrame;
      self.singleWeekViews[0] = week1;
      self.singleWeekViews[1] = week2;

      // 0 get's updated to 3
      week0.startDate = [self dateByAddingDays:7 toDate:week2.startDate];
      week0.frame = rightFrame;
      self.singleWeekViews[2] = week0;

      if ([self.delegate respondsToSelector:@selector(weekSelectorDidSwipe:)]) {
        [self.delegate weekSelectorDidSwipe:self];
      }
      NSDate *date = [self dateByAddingDays:7 toDate:self.selectedDate];
      [self userWillSelectDate:date];
      [self userDidSelectDate:date];
    }
    
    // reset offset
    offset.x = width;
    updatedOffset = YES;
  }
  
  if (updatedOffset) {
    scrollView.contentOffset = offset;
  }
}

- (NSString *)accessibilityScrollStatusForScrollView:(UIScrollView *)scrollView
{
  NSString *format = NSLocalizedStringFromTable(@"Week of %@", @"ASWeekSelectorView", @"Accessibility description when paging through weeks. Supplied %@ is string for the start date.");
  NSDate *startDate = [self.singleWeekViews[1] startDate];
  return [NSString stringWithFormat:format, [self.accessibilityDateFormatter stringFromDate:startDate]];
}


#pragma mark - ASSingleWeekViewDelegate

- (UIView *)singleWeekView:(ASSingleWeekView *)singleWeekView viewForDate:(NSDate *)date withFrame:(CGRect)frame
{
  BOOL isSelection = [self date:date matchesDateComponentsOfDate:self.selectedDate];
  if (isSelection) {
    self.selectionView.frame = frame;
  }
  
  NSDate *today = [NSDate date];
  BOOL isToday = [self date:date matchesDateComponentsOfDate:today];
  if (isToday) {
    self.todayView.frame = frame;
    [singleWeekView insertSubview:self.todayView atIndex:0];
    self.lastToday = today;
  }
  
  ASContainerView *wrapper = [[ASContainerView alloc] initWithFrame:frame];
  CGFloat width = CGRectGetWidth(frame);

  CGFloat nameHeight = 20;
  CGFloat topPadding = 10;
  CGRect nameFrame = CGRectMake(0, topPadding, width, nameHeight - topPadding);
  UILabel *letterLabel = [[UILabel alloc] initWithFrame:nameFrame];
  letterLabel.textAlignment = NSTextAlignmentCenter;
  letterLabel.font = [UIFont systemFontOfSize:9];
  letterLabel.textColor = self.letterTextColor;
  letterLabel.text = [[self.dayNameDateFormatter stringFromDate:date] uppercaseString];
  [wrapper addSubview:letterLabel];

  NSString *dayNumberText = [self.dayNumberDateFormatter stringFromDate:date];
  CGRect numberFrame = CGRectMake(0, nameHeight, width, CGRectGetHeight(frame) - nameHeight);
  UILabel *numberLabel = [[UILabel alloc] initWithFrame:numberFrame];
  numberLabel.textAlignment = NSTextAlignmentCenter;
  numberLabel.font = [UIFont systemFontOfSize:18];
  numberLabel.textColor = (isSelection && ! self.isAnimating) ? self.selectorLetterTextColor : self.numberTextColor;
  numberLabel.text = dayNumberText;
  numberLabel.tag = 100 + [dayNumberText integerValue];
  [wrapper addSubview:numberLabel];
  
  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(frame) - 1, 0, 1, CGRectGetHeight(frame))];
  lineView.backgroundColor = self.lineColor;
  [wrapper addSubview:lineView];
  
  wrapper.accessibilityElement = YES;
  wrapper.accessibilityLabel = [self.accessibilityDateFormatter stringFromDate:date];
  wrapper.accessibilityTraits = isSelection ? (UIAccessibilityTraitButton | UIAccessibilityTraitSelected) : UIAccessibilityTraitButton;
  return wrapper;
}

- (void)singleWeekView:(ASSingleWeekView *)singleWeekView didSelectDate:(NSDate *)date atFrame:(CGRect)frame
{
  [self userWillSelectDate:date];
  [self colorLabelForDate:_selectedDate withTextColor:self.numberTextColor];

  [UIView animateWithDuration:0.25f
                   animations:
   ^{
     self.selectionView.frame = frame;
   }
                   completion:
   ^(BOOL finished) {
     [self userDidSelectDate:date];
   }];
}

#pragma mark - Private helpers

- (void)didInit:(BOOL)setDefaults
{
  if (setDefaults) {
    // default styles
    _letterTextColor = [UIColor colorWithWhite:204.f/255 alpha:1];
    _numberTextColor = [UIColor colorWithWhite:77.f/255 alpha:1];
    _lineColor = [UIColor colorWithWhite:245.f/255 alpha:1];
    _selectorBackgroundColor = [UIColor whiteColor];
    _selectorLetterTextColor = [UIColor whiteColor];
    _preDragOffsetX = MAXFLOAT;
    _preDragSelectionX = MAXFLOAT;
    _locale = [NSLocale autoupdatingCurrentLocale];
    
    // this is using variables directly to not trigger setter methods
    _singleWeekViews = [NSMutableArray arrayWithCapacity:WEEKS];
    _firstWeekday = 1; // sunday
    _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  }
  
  CGFloat width = CGRectGetWidth(self.frame);
  CGFloat height = CGRectGetHeight(self.frame);
  CGRect scrollViewFrame = CGRectMake(0, 0, width, height - 1);
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
  scrollView.contentSize = CGSizeMake(WEEKS * width, height);
  scrollView.contentOffset = CGPointMake(width, 0);
  scrollView.pagingEnabled = YES;
  scrollView.delegate = self;
  scrollView.showsVerticalScrollIndicator = NO;
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [self addSubview:scrollView];
  self.scrollView = scrollView;
  
  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollViewFrame), width, 1)];
  lineView.backgroundColor = self.lineColor;
  lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [self insertSubview:lineView atIndex:0];
  self.lineView = lineView;

  [self updateDateFormatters];
}

- (void)updateDateFormatters
{
  self.dayNumberDateFormatter = [[NSDateFormatter alloc] init];
  self.dayNumberDateFormatter.locale = self.locale;
  self.dayNumberDateFormatter.dateFormat = @"d";
  self.dayNameDateFormatter = [[NSDateFormatter alloc] init];
  self.dayNameDateFormatter.locale = self.locale;
  self.dayNameDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"E"
                                                                         options:0
                                                                          locale:self.locale];
  
  self.accessibilityDateFormatter = [[NSDateFormatter alloc] init];
  self.accessibilityDateFormatter.locale = self.locale;
  self.accessibilityDateFormatter.dateStyle = NSDateFormatterFullStyle;
  self.accessibilityDateFormatter.timeStyle = NSDateFormatterNoStyle;
  [self rebuildWeeks];
}

- (void)rebuildWeeks
{
  if (! self.selectedDate) {
    return;
  }
  
  if (self.singleWeekViews.count > 0) {
    for (UIView *view in self.singleWeekViews) {
      [view removeFromSuperview];
    }
    [self.singleWeekViews removeAllObjects];
  }
  
  // determine where the start of the previews week was as that'll be our start date
  NSDateComponents *component = [self.gregorian components:NSWeekdayCalendarUnit fromDate:self.selectedDate];
  NSInteger weekday = [component weekday];
  NSInteger daysToSubtract;
  if (weekday == self.firstWeekday) {
    daysToSubtract = 0;
  } else if (weekday > self.firstWeekday) {
    daysToSubtract = weekday - self.firstWeekday;
  } else {
    daysToSubtract = (weekday + 7) - self.firstWeekday;
  }
  daysToSubtract += 7;

  NSDate *date = [self dateByAddingDays:- daysToSubtract toDate:self.selectedDate];

  CGFloat width = CGRectGetWidth(self.frame);
  CGFloat height = CGRectGetHeight(self.frame);

  // now we can build the #WEEKS subvies
  for (NSUInteger index = 0; index < WEEKS; index++) {
    CGRect frame = CGRectMake(index * width, 0, width, height);
    ASSingleWeekView *singleView = [[ASSingleWeekView alloc] initWithFrame:frame];
    singleView.delegate = self;
    singleView.startDate = date; // needs to be set AFTER delegate
    
    [self.scrollView addSubview:singleView];
    [self.singleWeekViews addObject:singleView];
    
    // next week
    date = [self dateByAddingDays:7 toDate:date];
  }
}

- (NSDate *)dateByAddingDays:(NSInteger)days toDate:(NSDate *)date
{
  NSDateComponents *diff = [[NSDateComponents alloc] init];
  diff.day = days;
  return [self.gregorian dateByAddingComponents:diff toDate:date options:0];
}

- (BOOL)date:(NSDate *)date matchesDateComponentsOfDate:(NSDate *)otherDate
{
  if (date == otherDate) {
    return YES;
  }
  if (! date || ! otherDate) {
    return NO;
  }
  
  NSUInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
  
  NSDateComponents *components = [self.gregorian components:unitFlags fromDate:date];
  NSDateComponents *otherComponents = [self.gregorian components:unitFlags fromDate:otherDate];
  return [components isEqual:otherComponents];
}

- (void)userWillSelectDate:(NSDate *)date
{
  if ([self.delegate respondsToSelector:@selector(weekSelector:willSelectDate:)]) {
    [self.delegate weekSelector:self willSelectDate:date];
  }
}


- (void)userDidSelectDate:(NSDate *)date
{
  [self colorLabelForDate:_selectedDate withTextColor:self.numberTextColor];
  _selectedDate = date;

  [self animateSelectionToPreDrag];
  
  if ([self.delegate respondsToSelector:@selector(weekSelector:didSelectDate:)]) {
    [self.delegate weekSelector:self didSelectDate:date];
  }
}

- (void)animateSelectionToPreDrag
{
  if (self.preDragOffsetX < MAXFLOAT) {
    CGFloat selectionX = self.preDragSelectionX;
    
    CGRect selectionViewFrame = self.selectionView.frame;
    selectionViewFrame.origin.x = selectionX;
    
    [UIView animateWithDuration:0.25f
                     animations:
     ^{
       self.selectionView.frame = selectionViewFrame;
     } completion:^(BOOL finished) {
       [self colorLabelForDate:_selectedDate withTextColor:self.selectorLetterTextColor];
     }];
    
    self.preDragOffsetX = MAXFLOAT;
  } else {
    [self colorLabelForDate:_selectedDate withTextColor:self.selectorLetterTextColor];
  }
}

- (void)colorLabelForDate:(NSDate *)date withTextColor:(UIColor *)textColor
{
  NSString *dayNumberText = [self.dayNumberDateFormatter stringFromDate:date];
  NSInteger viewTag = 100 + [dayNumberText integerValue];
  for (ASSingleWeekView *singleWeek in self.singleWeekViews) {
    UIView *view = [singleWeek viewWithTag:viewTag];
    if ([view isKindOfClass:[UILabel class]]) {
      UILabel *label = (UILabel *)view;
      label.textColor = textColor;
      return;
    }
  }
}

#pragma mark - Lazy accessors

- (ASDaySelectionView *)selectionView
{
  if (! _selectionView) {
    CGFloat width = CGRectGetWidth(self.frame) / 7;
    CGFloat height = CGRectGetHeight(self.frame);
    
    ASDaySelectionView *view = [[ASDaySelectionView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    view.backgroundColor = self.selectorBackgroundColor;
    view.fillCircle = YES;
    view.circleCenter = CGPointMake(width / 2, 20 + (height - 20) / 2);
    view.circleColor = self.tintColor;
    view.userInteractionEnabled = NO;
    [self insertSubview:view aboveSubview:self.lineView];
    _selectionView = view;
  }
  return _selectionView;
}

- (ASDaySelectionView *)todayView
{
  if (! _todayView) {
    CGFloat width = CGRectGetWidth(self.frame) / 7;
    CGFloat height = CGRectGetHeight(self.frame);
    
    ASDaySelectionView *view = [[ASDaySelectionView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    view.backgroundColor = [UIColor clearColor];
    view.fillCircle = NO;
    view.circleCenter = CGPointMake(width / 2, 20 + (height - 20) / 2);
    view.circleColor = self.tintColor;
    view.userInteractionEnabled = NO;
    _todayView = view;
  }
  return _todayView;
}

@end
