//
//  Product.h
//  MeliTest
//
//  Created by German Pereyra on 5/16/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSString *thumbnail;

- (id)initWithJson:(NSDictionary *)json;
@end
