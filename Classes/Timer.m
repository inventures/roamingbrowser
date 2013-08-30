/*
 * (C) Copyright 2010, Stefan Arentz, Arentz Consulting Inc.
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "Timer.h"

@implementation Timer

@synthesize delay = delay_;
@synthesize interval = interval_;
@synthesize repeats = repeats_;
@synthesize iterations = iterations_;
@synthesize currentIteration = currentIteration_;
@synthesize target = target_;
@synthesize selector = selector_;
@synthesize userInfo = userInfo_;

#pragma mark -

- (id) init
{
	if ((self = [super init]) != nil) {
		delay_ = 1.0;
	}
	return self;
}

- (void) dealloc
{
	if (timer_ != nil) {
		[timer_ invalidate];
		[timer_ release];
	}	
	[super dealloc];
}

#pragma mark -

- (void) execute
{
	currentIteration_++;
	[target_ performSelector: selector_ withObject: self];
	
	if (iterations_ != 0 && currentIteration_ == iterations_) {
		[timer_ invalidate];
		[timer_ release];
		timer_ = nil;
	}
}

- (void) fireInitialDelayTimer: (NSTimer*) timer
{
	[self execute];
	
	if (timer != nil) {
		[timer_ invalidate];
		[timer_ release];
		timer_ = nil;
	}
	
	if (repeats_ || iterations_ > 0) {
		timer_ = [[NSTimer scheduledTimerWithTimeInterval: interval_ target: self
												 selector: @selector(fireIntervalTimer:) userInfo: nil repeats: repeats_ || (iterations_ > 0)] retain];		
	}
}

- (void) fireIntervalTimer: (NSTimer*) timer
{
	[self execute];
}

#pragma mark -

- (void) schedule
{
	if (timer_ == nil)
	{
		currentIteration_ = 0;
		
		if (delay_ != 0.0 || interval_ != 0.0) {
			if (delay_ != 0.0) {
				timer_ = [[NSTimer scheduledTimerWithTimeInterval: delay_ target: self
														 selector: @selector(fireInitialDelayTimer:) userInfo: nil repeats: NO] retain];
			} else {
				timer_ = [[NSTimer scheduledTimerWithTimeInterval: interval_ target: self
														 selector: @selector(fireIntervalTimer:) userInfo: nil repeats: repeats_ || (iterations_ > 0)] retain];
			}
		}
	}
}

- (void) invalidate
{
	if (timer_ != nil) {
		[timer_ invalidate];
		[timer_ release];
		timer_ = nil;
	}
	
	delay_ = 0.0;
	interval_ = 0.0;
	repeats_ = NO;
	iterations_ = 0;
	currentIteration_ = 0;
	target_ = nil;
	selector_ = NULL;
	[userInfo_ release];
	userInfo_ = nil;
}

@end