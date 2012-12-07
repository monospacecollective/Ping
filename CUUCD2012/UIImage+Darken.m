//
//  UIImage+Darken.m
//  Erudio
//
//  created by Eric Horacek & Devon Tivona on 1/8/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

//
// Adapted from http://coffeeshopped.com/2010/09/iphone-how-to-dynamically-color-a-uiimage8
//

#import "UIImage+Darken.h"

@implementation UIImage (Darken)

- (UIImage *)darkenedImageWithOverlayAlpha:(CGFloat)alpha
{
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [[UIColor colorWithWhite:0.0 alpha:alpha] setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeDarken);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextDrawImage(context, rect, self.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *darkenedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return darkenedImage;
}

@end
