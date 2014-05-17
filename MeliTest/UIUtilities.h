//
//  UIUtilities.h
//  MeliTest
//
//  Created by German Pereyra on 5/16/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIUtilities : NSObject
+ (NSString *)stringWithDoubleAndCurrencySymbol:(double)number currencySymbol:(NSString *)symbol;
+ (void)moveView:(UIView*)view newYposition:(float)newYposition;
@end
