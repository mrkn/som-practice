// -*- mode: objc; coding: utf-8; c-basic-offset: 2; indent-tabs-mode: nil; -*-
//  SOMController.mm
//  som_1d
//
//  Created by muraken on 09/05/07.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SOMController.h"
#import <boost/bind.hpp>
#import <boost/random/uniform_real.hpp>
#import <utility>

@interface SOMController(SOMRunner)
- (void) runSOM: (id)anObject;
@end

namespace 
{

void
som_thread_entry(SOMController* anController)
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  [anController runSOM: nil];
  [pool release];
}

}

@implementation SOMController

- (void) applicationDidFinishLaunching: (NSNotification*) aNotification
{
  // ここで初期化を行う
  [som_view applicationDidFinishLaunching: aNotification];

  som_ = boost::shared_ptr<som_1d>(new som_1d(100, random));

  cancel_lock = [[NSLock alloc] init];
  cancel_request = false;

  som_thread = std::auto_ptr<boost::thread>(new boost::thread(boost::bind(som_thread_entry, self)));
}

- (void) windowWillClose: (NSNotification*) aNotification
{
  // ここで後始末を行う

  [self cancelRequest];
  som_thread->join();

  [NSApp terminate: self];
}

- (void) cancelRequest
{
  [cancel_lock lock];
  self->cancel_request = true;
  [cancel_lock unlock];
}

- (bool) isCancelRequested
{
  [cancel_lock lock];
  bool f = self->cancel_request;
  [cancel_lock unlock];
  return f;
}

- (void) runSOM: (id)anObject
{
  while (![self isCancelRequested]) {
    boost::uniform_real<> unif;
    double x = unif(random);
    double y = unif(random);
    som_->activate_at(x, y);

    // メインスレッド以外のスレッドでビューに描画するにはフォーカスのロッ
    // クが必要
    [som_view lockFocus];
    [som_view clear];
    [som_view drawSOM: som_];
    [som_view activateInputPointAt: std::make_pair(x, y)];
    [som_view unlockFocus];

    boost::this_thread::sleep(boost::get_system_time()
                              + boost::posix_time::milliseconds(50));
  }
  NSLog(@"terminate runSOM");
}
@end
