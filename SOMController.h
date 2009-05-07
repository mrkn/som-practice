// -*- mode: objc; coding: utf-8; c-basic-offset: 2; indent-tabs-mode: nil; -*-
//  SOMController.h
//  som_1d
//
//  Created by muraken on 09/05/07.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SOMView.h"

#import <boost/random/mersenne_twister.hpp>
#import <boost/shared_ptr.hpp>
#import <boost/thread.hpp>

#import "som.hpp"

@interface SOMController : NSObject {
  IBOutlet SOMView* som_view;
  std::auto_ptr<boost::thread> som_thread;

  NSLock* cancel_lock;
  bool cancel_request;

  boost::mt19937 random;

  boost::shared_ptr<som_1d> som_;
}

- (void) cancelRequest;
- (bool) isCancelRequested;
@end
