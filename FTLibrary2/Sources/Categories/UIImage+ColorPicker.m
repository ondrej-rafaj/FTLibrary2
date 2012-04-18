//
//  NSObject+UIImage_ColorPicker.m
//  FT2Library
//
//  Created by Francesco on 16/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "UIImage+ColorPicker.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (ColorPicker)

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}



- (UIColor*) getPixelColorAtLocation:(CGPoint)point andAlpha:(float *)_alpha {
    UIColor* color = nil;
    CGImageRef inImage = self.CGImage;
    *_alpha = NSNotFound;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    
    
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil; /* error */ }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage); 
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    int offset = NSNotFound;
    int alpha = NSNotFound;
    int red = NSNotFound;
    int green = NSNotFound;
    int blue = NSNotFound;
    *_alpha = NSNotFound;
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        offset = 4*((w*round(point.y))+round(point.x));
        alpha =  data[offset];
        red = data[offset+1];
        green = data[offset+2];
        blue = data[offset+3];
        *_alpha = (alpha/255.0f);

    }
    //NSLog(@"offset:\t(%d out of\t%lu) Alpha %d",offset, (4 * w * h) ,alpha);
    color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) free(data);
    
    return color;
}


#pragma mark Calling Methods


- (UIColor *)colorAtPoint:(CGPoint)point {
    float alpha = NSNotFound;
    return [self getPixelColorAtLocation:point andAlpha:&alpha];
}


- (float)alphaAtPoint:(CGPoint)point {
    float alpha;
    [self getPixelColorAtLocation:point andAlpha:&alpha];
    return alpha;    
}

+ (UIColor *)colorFromImage:(UIImage *)image atPoint:(CGPoint)point {
    float alpha = NSNotFound;
    return [image getPixelColorAtLocation:point andAlpha:&alpha];
}


+ (float)alphaFromImage:(UIImage *)image atPoint:(CGPoint)point {
    float alpha = NSNotFound;
    [image getPixelColorAtLocation:point andAlpha:&alpha];
    return alpha;
}

@end
