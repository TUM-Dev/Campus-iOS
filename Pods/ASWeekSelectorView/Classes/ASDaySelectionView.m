//
//  ASDaySelectionView.m
//  ASWeekSelectorView
//
//  Created by Adrian Schoenig on 22/04/2014.
//  Copyright (c) 2014 Adrian Schoenig. All rights reserved.
//

#import "ASDaySelectionView.h"

@implementation ASDaySelectionView

#pragma mark - UIView

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();

  // Draw circle.
  CGRect circleRect = [self circleRect];
  if (self.fillCircle) {
    CGContextSetFillColorWithColor(context, self.circleColor.CGColor);
    CGContextFillEllipseInRect(context, circleRect);
  } else {
    CGContextSetStrokeColorWithColor(context, self.circleColor.CGColor);
    CGContextStrokeEllipseInRect(context, circleRect);
  }
}

#pragma mark - Private helpers

- (CGRect)circleRect
{
  CGFloat diameterFromWidth  = CGRectGetWidth(self.frame) * .66;
  CGFloat diameterFromHeight = CGRectGetHeight(self.frame) * .5;
  
  CGFloat diameter = MIN(diameterFromWidth, diameterFromHeight);
  CGFloat xOffset = self.circleCenter.x - diameter / 2;
  CGFloat yOffset = self.circleCenter.y - diameter / 2;
  return CGRectMake(xOffset, yOffset, diameter, diameter);
}


@end
