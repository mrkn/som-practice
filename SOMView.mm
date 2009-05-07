// -*- mode: objc; coding: utf-8; c-basic-offset: 2; indent-tabs-mode: nil; -*-
//  SOMView.mm
//  som_1d
//
//  Created by muraken on 09/05/07.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SOMView.h"

#import <boost/tuple/tuple.hpp>

@implementation SOMView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) applicationDidFinishLaunching: (NSNotification*) aNotification
{
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
}

- (void) clear
{
  NSEraseRect([self bounds]);
}

- (void) drawSOM: (boost::shared_ptr<som_1d>)som
{
  std::size_t const& n = som->n();
  som_1d::double_array const& xs = som->xs();
  som_1d::double_array const& ys = som->ys();

  NSGraphicsContext* aContext = [NSGraphicsContext currentContext];
  [aContext saveGraphicsState];

  NSAffineTransform* xform = [NSAffineTransform transform];
  NSSize size = [self bounds].size;
  [xform scaleXBy: size.width yBy: size.height];
  [xform concat];
  [xform invert];

  NSSize lineSize = [xform transformSize: NSMakeSize(1.0, 1.0)];

  [[NSColor blackColor] setStroke];
  NSBezierPath* edgesPath = [NSBezierPath bezierPath];
  [edgesPath setLineWidth: lineSize.width];
  [edgesPath moveToPoint: NSMakePoint(xs[0], ys[0])];
  for (std::size_t i = 1; i < n; ++i) {
    [edgesPath lineToPoint: NSMakePoint(xs[i], ys[i])];
  }
  [edgesPath stroke];

  NSSize ovalSize = [xform transformSize: NSMakeSize(4.0, 4.0)];

  [[NSColor blackColor] setFill];
  NSBezierPath* verticesPath = [NSBezierPath bezierPath];
  for (std::size_t i = 0; i < som->n(); ++i) {
    double const x = xs[i] - ovalSize.width/2.0;
    double const y = ys[i] - ovalSize.height/2.0;
    [verticesPath appendBezierPathWithOvalInRect: NSMakeRect(x, y, ovalSize.width, ovalSize.height)];
  }
  [verticesPath fill];

  [aContext restoreGraphicsState];

  [aContext flushGraphics];
}

- (void) activateInputPointAt: (std::pair<double, double>)pt
{
  double x, y;
  boost::tie(x, y) = pt;
  NSLog(@"(%f, %f)\n", x, y);

  NSGraphicsContext* aContext = [NSGraphicsContext currentContext];
  [aContext saveGraphicsState];

  NSAffineTransform* xform = [NSAffineTransform transform];
  NSSize size = [self bounds].size;
  [xform scaleXBy: size.width yBy: size.height];
  [xform concat];
  [xform invert];

  NSSize ovalSize = [xform transformSize: NSMakeSize(4.0, 4.0)];

  [[NSColor redColor] setFill];
  x -= ovalSize.width/2.0;
  y -= ovalSize.height/2.0;
  NSBezierPath* thePath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(x, y, ovalSize.width, ovalSize.height)];
  [thePath fill];

  [aContext restoreGraphicsState];

  [aContext flushGraphics];
}

@end
