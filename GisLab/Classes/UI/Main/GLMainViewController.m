//
//  GLMainViewController.m
//  GisLab
//
//  Created by Andrew Kopanev on 7/13/13.
//  Copyright (c) 2013 Moqod. All rights reserved.
//

#import "GLMainViewController.h"
#import "GLMainView.h"

#import "AFNetworking.h"

@interface GLMainViewController () <MKMapViewDelegate> {
	GLMainView		*_mainView;
	BOOL			_didShowUserLocation;
}
@end

@implementation GLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLS(@"GISLAB_TITLE");
	
	_mainView = [[GLMainView alloc] initWithFrame:self.view.bounds];
	_mainView.mapView.delegate = self;
	[self.view addSubview:_mainView];
	
	_mainView.mapView.showsUserLocation = YES;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	if (NO == _didShowUserLocation) {
		_didShowUserLocation = YES;
		[_mainView.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.00045, 0.00057)) animated:YES];
	}
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
	NSLog(@"%s", __PRETTY_FUNCTION__);	
}

#pragma mark - requests

- (void)submitData {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setValue:[NSNumber numberWithDouble:150.0] forKey:@"lat"];
	[dictionary setValue:[NSNumber numberWithDouble:150.0] forKey:@"lon"];
	[dictionary setValue:[NSNumber numberWithDouble:1000000.0] forKey:@"accuracy"];
	[dictionary setValue:@"second@mail.com" forKey:@"email"];
	
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://fiosm.openstreetmap.ru:8090/"]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:jsonData];
	
	AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:nil failure:nil];
	[jsonRequest start];
}

#pragma mark -

- (void)dealloc {
	[_mainView release];
	[super dealloc];
}

@end
