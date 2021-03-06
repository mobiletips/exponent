/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ABI6_0_0RCTTestModule.h"

#import "ABI6_0_0FBSnapshotTestController.h"
#import "ABI6_0_0RCTAssert.h"
#import "ABI6_0_0RCTEventDispatcher.h"
#import "ABI6_0_0RCTLog.h"
#import "ABI6_0_0RCTUIManager.h"

@implementation ABI6_0_0RCTTestModule
{
  NSMutableDictionary<NSString *, NSString *> *_snapshotCounter;
}

@synthesize bridge = _bridge;

ABI6_0_0RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
  return _bridge.uiManager.methodQueue;
}

ABI6_0_0RCT_EXPORT_METHOD(verifySnapshot:(ABI6_0_0RCTResponseSenderBlock)callback)
{
  ABI6_0_0RCTAssert(_controller != nil, @"No snapshot controller configured.");

  [_bridge.uiManager addUIBlock:^(ABI6_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {

    NSString *testName = NSStringFromSelector(_testSelector);
    if (!_snapshotCounter) {
      _snapshotCounter = [NSMutableDictionary new];
    }
    _snapshotCounter[testName] = (@([_snapshotCounter[testName] integerValue] + 1)).stringValue;

    NSError *error = nil;
    BOOL success = [_controller compareSnapshotOfView:_view
                                             selector:_testSelector
                                           identifier:_snapshotCounter[testName]
                                                error:&error];
    callback(@[@(success)]);
  }];
}

ABI6_0_0RCT_EXPORT_METHOD(sendAppEvent:(NSString *)name body:(nullable id)body)
{
  [_bridge.eventDispatcher sendAppEventWithName:name body:body];
}

ABI6_0_0RCT_REMAP_METHOD(shouldResolve, shouldResolve_resolve:(ABI6_0_0RCTPromiseResolveBlock)resolve reject:(ABI6_0_0RCTPromiseRejectBlock)reject)
{
  resolve(@1);
}

ABI6_0_0RCT_REMAP_METHOD(shouldReject, shouldReject_resolve:(ABI6_0_0RCTPromiseResolveBlock)resolve reject:(ABI6_0_0RCTPromiseRejectBlock)reject)
{
  reject(nil, nil, nil);
}

ABI6_0_0RCT_EXPORT_METHOD(markTestCompleted)
{
  [self markTestPassed:YES];
}

ABI6_0_0RCT_EXPORT_METHOD(markTestPassed:(BOOL)success)
{
  [_bridge.uiManager addUIBlock:^(__unused ABI6_0_0RCTUIManager *uiManager, __unused NSDictionary<NSNumber *, UIView *> *viewRegistry) {
    _status = success ? ABI6_0_0RCTTestStatusPassed : ABI6_0_0RCTTestStatusFailed;
  }];
}

@end
