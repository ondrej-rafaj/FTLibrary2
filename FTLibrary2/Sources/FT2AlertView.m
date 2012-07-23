//
//  FT2AlertView.m
//  FT2Library
//
//  Created by Baldoph Pourprix on 19/02/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FT2AlertView.h"

@implementation FT2AlertView

@synthesize cancelBlock = _cancelBlock;
@synthesize actionBlock = _actionBlock;

- (id)initWithTitle:(NSString *)title message:(NSString *)message actionBlock:(void (^)(NSInteger clikedButtonIndex))actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
	if (self) {
		self.delegate = self;
		
		self.actionBlock = actionBlock;
	}
	return self;
}

+ (id)showAlertViewWithTitle:(NSString *)title message:(NSString *)message actionBlock:(void (^)(NSInteger clikedButtonIndex))actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	FT2AlertView *a = [[FT2AlertView alloc] initWithTitle:title message:message actionBlock:actionBlock cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
	[a show];
	return a;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (self.cancelButtonIndex == buttonIndex) {
		if (_cancelBlock) _cancelBlock();
	} else {
		if (_actionBlock) _actionBlock(buttonIndex);
	}
}


@end
