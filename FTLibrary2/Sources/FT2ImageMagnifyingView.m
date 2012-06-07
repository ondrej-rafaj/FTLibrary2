//
//  FT2ImageMagnifyingView.m
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 12/02/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FT2ImageMagnifyingView.h"

@interface FT2ImageMagnifyingView ()

- (UIImageView *)imageView;

@end

@implementation FT2ImageMagnifyingView

#pragma mark - Setters

- (void)setImage:(UIImage *)image
{    
    // make a new UIImageView for the new image
	UIImageView *imageView = nil;
	if (image) {
		
		imageView = [[UIImageView alloc] initWithImage:image];
		
		CGSize imageSize = image.size;
		CGSize maxZoomSize;
		
		CGFloat ratio = imageSize.width / imageSize.height;
		if (ratio > 1) {
			//width > height
			maxZoomSize = CGSizeMake(480 * 1.5 * ratio, 480 * 1.5);
		}
		else {
			//width <= height
			maxZoomSize = CGSizeMake(480 * 1.5, 480 * 1.5 / ratio);
		}
		
		imageView.frame = CGRectMake(0, 0, maxZoomSize.width, maxZoomSize.height);
	}
    self.magnifiedView = imageView;
	
	self.imageView.autoresizingMask = self.autoresizingMask;
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self setImage:self.image];
}

#pragma mark - Getters

- (UIImageView *)imageView
{
	return (UIImageView *)self.magnifiedView;
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
