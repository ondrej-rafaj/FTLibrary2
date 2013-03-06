//
//  FGalleryPhotoErrorView.m
//  FTLibrary2
//
//  Created by Matěj Ornest on 27.09.12.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FGalleryPhotoErrorView.h"

@implementation FGalleryPhotoErrorView {
	
	UILabel *_titleLabel;
	
	UILabel *_descriptionLabel;
}

- (id) initWithFrame: (CGRect) frame {
	
    self = [super initWithFrame: frame];
	
    if (self) {
        // Initialization code
    }
	
    return self;
}

- (UILabel *) titleLabel {
	
	if(_titleLabel == nil) {
		
		/// Create label instance and setup default behavior
		_titleLabel = [UILabel new];
		
		_titleLabel.backgroundColor = [UIColor clearColor];
		
		_titleLabel.textColor = [UIColor whiteColor];
		
		_titleLabel.font = [UIFont boldSystemFontOfSize: 16.0];
		
		_titleLabel.numberOfLines = 3;
		
		_titleLabel.textAlignment = UITextAlignmentCenter;
		
		_titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		
		[self addSubview: _titleLabel];
	}
	
	return _titleLabel;
}

- (UILabel *) descriptionLabel {
	
	if(_descriptionLabel == nil) {
		
		/// Create label instance and setup default behavior
		
		_descriptionLabel = [UILabel new];
		
		_descriptionLabel.backgroundColor = [UIColor clearColor];
		
		_descriptionLabel.textColor = [UIColor whiteColor];
		
		_descriptionLabel.font = [UIFont systemFontOfSize: 14.0];
		
		_descriptionLabel.numberOfLines = 5;
		
		_descriptionLabel.textAlignment = UITextAlignmentCenter;
		
		_descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
		
		[self addSubview: _descriptionLabel];
	}
	
	return _descriptionLabel;
}

- (void) layoutSubviews {
	
	[super layoutSubviews];
	
	/// Create space with some edge insets
	CGSize viewSize = self.frame.size;
	viewSize.width -= 40.0f;
	viewSize.height -= 40.0;
	
	/// Compuite size for title
	CGSize labelSize = [_titleLabel.text sizeWithFont: _titleLabel.font constrainedToSize: viewSize];
	
	/// Create frame and set it to title label
	CGRect frame = CGRectMake(10.0f, 10.0f, labelSize.width, labelSize.height);
	
	_titleLabel.frame = frame;
	
	/// Put title label to the center
	_titleLabel.center = self.center;
	
	/// Adjust workspace for description label
	viewSize.height -= labelSize.height + 10.0f;
	
	labelSize = [_descriptionLabel.text sizeWithFont: _descriptionLabel.font constrainedToSize: viewSize];
	
	frame.size = labelSize;
	
	_descriptionLabel.frame = frame;
	
	_descriptionLabel.center = self.center;
	
	/// Fix position of description label
	frame.origin.x = _descriptionLabel.frame.origin.x;
	
	frame.origin.y = CGRectGetMaxY(_titleLabel.frame) + 10.0f;
	
	_descriptionLabel.frame = frame;
}

@end
