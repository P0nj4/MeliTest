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

@end
