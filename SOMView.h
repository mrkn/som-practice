// -*- mode: objc; coding: utf-8; c-basic-offset: 2; indent-tabs-mode: nil; -*-
//  SOMView.h
//  som_1d
//
//  Created by muraken on 09/05/07.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <boost/shared_ptr.hpp>
#import <utility>

#import "som.hpp"

@interface SOMView : NSView {

}

- (void) applicationDidFinishLaunching: (NSNotification*) aNotification;


- (void) clear;
- (void) drawSOM: (boost::shared_ptr<som_1d>)som;
- (void) activateInputPointAt: (std::pair<double, double>)pt;

@end
