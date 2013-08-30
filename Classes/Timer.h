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

#import <Foundation/Foundation.h>

@interface Timer : NSObject {
@private
	float delay_;
	float interval_;
	BOOL repeats_;
	int iterations_;
	int currentIteration_;
	id target_;
	SEL selector_;
	id userInfo_;
	NSTimer* timer_;
}

@property (nonatomic,assign) float delay;
@property (nonatomic,assign) float interval;
@property (nonatomic,assign) BOOL repeats;
@property (nonatomic,assign) int iterations;
@property (nonatomic,readonly) int currentIteration;
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL selector;
@property (nonatomic, retain) id userInfo;

- (void) schedule;
- (void) invalidate;

@end