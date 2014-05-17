//
//  RestConsumer.h
//  MeliTest
//
//  Created by German Pereyra on 5/16/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"


@interface ProductManager : NSObject
@property (nonatomic, strong) NSMutableArray *allProducts;

+ (ProductManager *)sharedInstance;
- (void)searchBy:(NSString *)search;
- (void)setProductInformation:(Product *)item;
- (void)setProductDescription:(Product *)item;

@end
