//
//  GLMainView.h
//  GisLab
//
//  Created by Andrew Kopanev on 7/13/13.
//  Copyright (c) 2013 Moqod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GLMainView : UIView

@property (nonatomic, readonly) UITextField		*uikTextField;
@property (nonatomic, readonly) UITextField		*emailTextField;
@property (nonatomic, readonly) UITextField		*noteTextField;
@property (nonatomic, readonly) MKMapView		*mapView;
@property (nonatomic, readonly) UIButton		*locateMeButton;

- (void)showPlusOneAnimation;

@end
