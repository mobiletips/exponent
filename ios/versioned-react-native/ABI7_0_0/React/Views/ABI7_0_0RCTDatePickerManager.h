/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ABI7_0_0RCTViewManager.h"
#import "ABI7_0_0RCTConvert.h"

@interface ABI7_0_0RCTConvert(UIDatePicker)

+ (UIDatePickerMode)UIDatePickerMode:(id)json;

@end

@interface ABI7_0_0RCTDatePickerManager : ABI7_0_0RCTViewManager

@end
