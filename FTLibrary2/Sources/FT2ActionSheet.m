//
//  FT2ActionSheet.m
//  FT2Library
//
//  Created by Baldoph Pourprix on 19/02/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FT2ActionSheet.h"

@implementation FT2ActionSheet

@synthesize cancelBlock = _cancelBlock;
@synthesize destructiveBlock = _destructiveBlock;
@synthesize actionBlock = _actionBlock;

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [super initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
	if (self) {
		NSInteger currentIndex = 0;
		if (otherButtonTitles != nil) {
			[self addButtonWithTitle:otherButtonTitles];
			va_list args;
			va_start(args, otherButtonTitles);
			NSString * title = nil;
			while((title = va_arg(args,NSString*))) {
				currentIndex++;
				[self addButtonWithTitle:title];
			}
			va_end(args);
		}
		
		if (destructiveButtonTitle) {
			currentIndex++;
			[self addButtonWithTitle:destructiveButtonTitle];
			self.destructiveButtonIndex = currentIndex;
		}
		
		if (cancelButtonTitle) {
			currentIndex++;
			[self addButtonWithTitle:cancelButtonTitle];
			self.cancelButtonIndex = currentIndex;
		}
	}
	return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == self.cancelButtonIndex) {
		if (_cancelBlock) _cancelBlock(); 
	} else if (buttonIndex == self.destructiveButtonIndex) {
		if (_destructiveBlock) _destructiveBlock();
	} else {
		if (_actionBlock) _actionBlock(buttonIndex);
	}
}

@end
