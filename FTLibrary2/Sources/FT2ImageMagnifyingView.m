//
//  FT2ImageMagnifyingView.m
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 12/02/2012.
//  Copyright (c) 2012 Fuerte International All rights reserved.
//

#import "FT2ImageMagnifyingView.h"

@interface FT2ImageMagnifyingView ()

@property (nonatomic, readwrite) UIImageView *imageView;

@end

@implementation FT2ImageMagnifyingView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_maxScale = 1.5;
	}
	return self;
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image
{
	[self setImage:image adjustZoom:YES];
}

- (void)setImage:(UIImage *)image adjustZoom:(BOOL)adjust
{
	// make a new UIImageView for the new image
	if (image) {
		
		self.imageView.image = image;
		
		if (adjust) {
			//next 2 lines to prevent reused views to set incorrect frame due to current transformation
			[self.imageView removeFromSuperview];
			self.imageView.transform = CGAffineTransformIdentity;
			
			[self.imageView sizeToFit];
			
			CGSize imageSize = image.size;
			CGSize maxZoomSize;
			
			CGFloat ratio = imageSize.width / imageSize.height;
			
			CGRect screenBounds = [UIScreen mainScreen].bounds;
			CGFloat minScreenSide = MIN(screenBounds.size.width, screenBounds.size.height);
			if (ratio > 1) {
				//width > height
				maxZoomSize = CGSizeMake( minScreenSide * _maxScale * ratio, minScreenSide * _maxScale);
			}
			else {
				//width <= height
				maxZoomSize = CGSizeMake(minScreenSide * _maxScale, minScreenSide * _maxScale / ratio);
			}
			
			self.imageView.frame = CGRectMake(0, 0, round(maxZoomSize.width), round(maxZoomSize.height));
			self.magnifiedView = self.imageView;
		}
	} else {
		_imageView.image = nil;
	}
	
	if (!adjust && self.magnifiedView == nil) self.magnifiedView = self.imageView;
	
	self.imageView.autoresizingMask = self.autoresizingMask;
}

#pragma mark - Getters

- (UIImageView *)imageView
{
	if (_imageView == nil) {
		_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	}
	return _imageView;
}

- (UIImage *)image
{
	return self.imageView.image;
}



//
//- (void)setMaxMinZoomScalesForCurrentBounds
//{
//	CGSize boundsSize = self.bounds.size;
//    CGSize imageSize = self.imageView.bounds.size;
//    
//    // calculate min/max zoomscale
//    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
//    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
//    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
//    
//    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
//    // maximum zoom scale to 0.5.
//    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
//    
//    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
//    if (minScale > maxScale) {
//        minScale = maxScale;
//    }
//    
//    self.maximumZoomScale = maxScale;
//    self.minimumZoomScale = minScale;
//}

@end
