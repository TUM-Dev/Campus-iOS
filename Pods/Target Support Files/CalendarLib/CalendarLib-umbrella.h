#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MGCDateRange.h"
#import "MGCDayPlannerEKViewController.h"
#import "MGCDayPlannerView.h"
#import "MGCDayPlannerViewController.h"
#import "MGCEventView.h"
#import "MGCMonthMiniCalendarView.h"
#import "MGCMonthPlannerEKViewController.h"
#import "MGCMonthPlannerView.h"
#import "MGCMonthPlannerViewController.h"
#import "MGCReusableObjectQueue.h"
#import "MGCStandardEventView.h"
#import "MGCYearCalendarView.h"
#import "NSAttributedString+MGCAdditions.h"
#import "NSCalendar+MGCAdditions.h"

FOUNDATION_EXPORT double CalendarLibVersionNumber;
FOUNDATION_EXPORT const unsigned char CalendarLibVersionString[];

