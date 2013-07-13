//
//  GLAppDelegate.m
//  GisLab
//
//  Created by Andrew Kopanev on 7/13/13.
//  Copyright (c) 2013 Moqod. All rights reserved.
//

#import "GLAppDelegate.h"
#import "GLMainViewController.h"

@implementation GLAppDelegate

- (void)dealloc {
	[_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor blackColor];
	self.window.rootViewController = [[[UINavigationController alloc] initWithRootViewController:[[[GLMainViewController alloc] init] autorelease]] autorelease];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
