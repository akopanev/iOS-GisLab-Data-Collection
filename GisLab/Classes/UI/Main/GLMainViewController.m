//
//  GLMainViewController.m
//  GisLab
//
//  Created by Andrew Kopanev on 7/13/13.
//  Copyright (c) 2013 Moqod. All rights reserved.
//

#import "GLMainViewController.h"
#import "GLMainView.h"
#import "UIAlertViewWithUserInfo.h"
#import "AFNetworking.h"

const int GLMainViewController_FailedRequestAlertTag		 = 1;

@interface GLMainViewController () <MKMapViewDelegate, UIAlertViewDelegate> {
	GLMainView		*_mainView;
	BOOL			_didShowUserLocation;
}
@property (nonatomic, retain) CLLocation			*userLocation;
@end

@implementation GLMainViewController

#pragma mark - helpers

- (NSString *)previousEmail {
	NSString *previousEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"GLEmail"];
	return previousEmail ? previousEmail : @"";
}

- (void)hideKeyboard {
	[_mainView.uikTextField resignFirstResponder];
	[_mainView.emailTextField resignFirstResponder];
	[_mainView.noteTextField resignFirstResponder];
}

- (void)resetViewData {
	_mainView.uikTextField.text = @"";
	_mainView.noteTextField.text = @"";
}

- (void)setSubmitButtonLocked:(BOOL)locked {
	self.navigationItem.rightBarButtonItem.enabled = !locked;
}

#pragma mark - notifications

- (void)didEnterBackgroundNotification:(NSNotification *)notification {
	_didShowUserLocation = NO;
	if ([self isViewLoaded]) {
		NSString *email = [_mainView.emailTextField text];
		if (email.length) {
			[[NSUserDefaults standardUserDefaults] setValue:email forKey:@"GLEmail"];
		} else {
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GLEmail"];
		}
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

#pragma mark - initialization

- (id)init {
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
	}
	return self;
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLS(@"GISLAB_TITLE");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLS(@"SEND") style:UIBarButtonItemStyleBordered target:self action:@selector(submitAction)] autorelease];
	
	_mainView = [[GLMainView alloc] initWithFrame:self.view.bounds];
	[_mainView.locateMeButton addTarget:self action:@selector(locateMeAction) forControlEvents:UIControlEventTouchUpInside];
	_mainView.emailTextField.text = [self previousEmail];
	_mainView.mapView.delegate = self;
	_mainView.mapView.showsUserLocation = YES;
	[self.view addSubview:_mainView];
}

#pragma mark - MKMapViewDelegate

- (void)showUserLocation {
	if (CLLocationCoordinate2DIsValid(_mainView.mapView.userLocation.coordinate)) {
		[_mainView.mapView setRegion:MKCoordinateRegionMake(_mainView.mapView.userLocation.coordinate, MKCoordinateSpanMake(0.00045, 0.00057)) animated:YES];
	}
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	if (NO == _didShowUserLocation) {
		_didShowUserLocation = YES;
		[self showUserLocation];
	}
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
	NSLog(@"%s error == %@", __PRETTY_FUNCTION__, error);
	
	if (error.localizedRecoverySuggestion) {
		[[[[UIAlertView alloc] initWithTitle:nil message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:NSLS(@"OK") otherButtonTitles:nil] autorelease] show];		
	}
}

#pragma mark - actions

- (void)submitData:(NSDictionary *)dictionary {
	NSLog(@"%s data == %@", __PRETTY_FUNCTION__, dictionary);
	
	[self setSubmitButtonLocked:YES];
	
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: API_URL ];
	[request addValue:@"application/json; charset=utf8;" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:jsonData];
	
	AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id result) {
		[self setSubmitButtonLocked:NO];
		[self resetViewData];
		[_mainView showPlusOneAnimation];
		[[[[UIAlertView alloc] initWithTitle:nil message:NSLS(@"ALERT_REQUEST_SUCCEED") delegate:nil cancelButtonTitle:NSLS(@"OK") otherButtonTitles:nil] autorelease] show];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[self setSubmitButtonLocked:NO];
		UIAlertViewWithUserInfo *alertView = [[[UIAlertViewWithUserInfo alloc] initWithTitle:nil message:NSLS(@"ALERT_REQUEST_FAILED") delegate:self cancelButtonTitle:NSLS(@"CANCEL") otherButtonTitles:NSLS(@"REPEAT"), nil] autorelease];
		alertView.tag = GLMainViewController_FailedRequestAlertTag;
		alertView.userInfo = dictionary;
		[alertView show];
	}];
	[operation start];
}

- (void)submitAction {
	CLLocation *userLocation = _mainView.mapView.userLocation.location;
	if (nil != userLocation) {
		[self hideKeyboard];
		
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		[dictionary setValue:[NSNumber numberWithDouble:userLocation.coordinate.latitude] forKey:@"lat"];
		[dictionary setValue:[NSNumber numberWithDouble:userLocation.coordinate.longitude] forKey:@"lon"];
		[dictionary setValue:[NSNumber numberWithDouble:userLocation.horizontalAccuracy] forKey:@"accuracy"];
		[dictionary setValue:_mainView.emailTextField.text.length ? _mainView.emailTextField.text : nil forKey:@"email"];
		[dictionary setValue:_mainView.uikTextField.text.length ? _mainView.uikTextField.text : nil forKey:@"uik"];
		[dictionary setValue:_mainView.noteTextField.text.length ? _mainView.noteTextField.text : nil forKey:@"note"];
		[self submitData:dictionary];
	} else {
		[[[[UIAlertView alloc] initWithTitle:nil message:NSLS(@"ALERT_CANT_DETERMINE_LOCATION") delegate:nil cancelButtonTitle:NSLS(@"OK") otherButtonTitles:nil] autorelease] show];
	}
}

- (void)locateMeAction {
	if (nil != _mainView.mapView.userLocation) {
		[self showUserLocation];
	} else {
		[[[[UIAlertView alloc] initWithTitle:nil message:NSLS(@"ALERT_CANT_DETERMINE_LOCATION") delegate:nil cancelButtonTitle:NSLS(@"OK") otherButtonTitles:nil] autorelease] show];
	}
}

#pragma mark - requests

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (alertView.tag == GLMainViewController_FailedRequestAlertTag) {
		if (buttonIndex != alertView.cancelButtonIndex) {
			UIAlertViewWithUserInfo *aView = (UIAlertViewWithUserInfo *)alertView;
			[self submitData:aView.userInfo];
		} else {
			[self resetViewData];
		}
	}
}

#pragma mark -

- (void)dealloc {
	[_mainView release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
