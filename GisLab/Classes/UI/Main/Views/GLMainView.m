//
//  GLMainView.m
//  GisLab
//
//  Created by Andrew Kopanev on 7/13/13.
//  Copyright (c) 2013 Moqod. All rights reserved.
//

#import "GLMainView.h"

@interface GLMainView () <UITextFieldDelegate>

@end

@implementation GLMainView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor colorWithWhite:241.0f/255.0f alpha:1.0f];
		
		_uikTextField = [[UITextField alloc] initWithFrame:CGRectZero];
		_uikTextField.placeholder = NSLS(@"UIK_PLACEHOLDER");
		_uikTextField.borderStyle = UITextBorderStyleRoundedRect;
		_uikTextField.returnKeyType = UIReturnKeyDone;
		_uikTextField.delegate = self;
		[self addSubview:_uikTextField];
		
		_emailTextField = [[UITextField alloc] initWithFrame:CGRectZero];
		_emailTextField.placeholder = NSLS(@"EMAIL_PLACEHOLDER");
		_emailTextField.borderStyle = UITextBorderStyleRoundedRect;
		_emailTextField.delegate = self;
		_emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
		_emailTextField.returnKeyType = UIReturnKeyDone;
		[self addSubview:_emailTextField];
		
		_noteTextField = [[UITextField alloc] initWithFrame:CGRectZero];
		_noteTextField.placeholder = NSLS(@"NOTE_PLACEHOLDER");	
		_noteTextField.borderStyle = UITextBorderStyleRoundedRect;
		_noteTextField.delegate = self;
		_noteTextField.returnKeyType = UIReturnKeyDone;
		[self addSubview:_noteTextField];
		
		_mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
		[self addSubview:_mapView];
    }
    return self;
}

#pragma mark -

- (void)layoutSubviews {
	[super layoutSubviews];
	
	const float horizontalMargin = 10.0f;
	const float verticalMargin = 10.0f;
	const float textFieldWidth = floorf(self.bounds.size.width - horizontalMargin * 2.0f);
	const float textFieldHeight = 31.0f;
	const float offsetBetweenViews = 10.0f;
	
	float textFieldX = floorf(self.bounds.size.width * 0.5f - textFieldWidth * 0.5f);
	float textFieldY = verticalMargin;
	NSArray *fields = [NSArray arrayWithObjects:_uikTextField, _emailTextField, _noteTextField, nil];
	for (UIView *v in fields) {
		v.frame = CGRectMake(textFieldX, textFieldY, textFieldWidth, textFieldHeight);
		textFieldY += (textFieldHeight + offsetBetweenViews);
	}
	
	float mapY = CGRectGetMaxY(_noteTextField.frame) + offsetBetweenViews;
	float mapW = floorf(self.bounds.size.width - horizontalMargin * 2.0f);
	float mapH = self.bounds.size.height - mapY - verticalMargin;
	_mapView.frame = CGRectMake(horizontalMargin, mapY, mapW, mapH);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -

- (void)dealloc {
	[_uikTextField release];
	[_emailTextField release];
	[_noteTextField release];
	[_mapView release];
	[super dealloc];
}

@end
