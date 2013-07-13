//
//  UIAlertViewWithUserInfo.m
//  Pindle
//
//  Created by Andrew Kopanev on 2/1/13.
//  Copyright (c) 2013 TulaCo. All rights reserved.
//

#import "UIAlertViewWithUserInfo.h"

@implementation UIAlertViewWithUserInfo
@synthesize userInfo;
- (void)dealloc {
	self.userInfo = nil;
	[super dealloc];
}
@end
