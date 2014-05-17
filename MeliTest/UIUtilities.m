//
//  UIUtilities.m
//  MeliTest
//
//  Created by German Pereyra on 5/16/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "UIUtilities.h"

@implementation UIUtilities


+ (NSString *)stringWithDoubleAndCurrencySymbol:(double)number{
    
    NSString *result = nil;
    int intpart = (int)number;
    double decpart = number - intpart;
    if (decpart == 0){
        result = [NSString stringWithFormat:@"%i",intpart];
    }
    else{
        result = [NSString stringWithFormat:@"%.1lf",number];
    }
    result = [NSString stringWithFormat:@"$%@", [result stringByReplacingOccurrencesOfString:@"." withString:@","]];
    return result;
}


+ (void)moveView:(UIView*)view newYposition:(float)newYposition {
    // si la Y es menor de -216, lo limita a 216 porque sino se ve un espacio en blanco de la vista
    if (newYposition < -216) newYposition = -216;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        newYposition += 64;
    }
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
    view.frame = CGRectMake(view.frame.origin.x, newYposition, view.frame.size.width, view.frame.size.height + ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7 ? (newYposition >= 0 ? newYposition : newYposition * -1) : 0));
	
	[UIView commitAnimations];
}

@end
