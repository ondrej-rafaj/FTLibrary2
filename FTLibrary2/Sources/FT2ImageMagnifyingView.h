//
//  FT2ImageMagnifyingView.h
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 12/02/2012.
//  Copyright (c) 2012 Fuerte International All rights reserved.
//

#import "FT2MagnifyingView.h"

@interface FT2ImageMagnifyingView : FT2MagnifyingView

@property (nonatomic, strong) UIImage *image;

/* you can change the image property of the imageView if don't want the magnifying view to change the current zoom scale */
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic) CGFloat maxScale;

- (void)setImage:(UIImage *)image adjustZoom:(BOOL)adjust;

@end
