//
//  Product.m
//  MeliTest
//
//  Created by German Pereyra on 5/16/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "Product.h"

@implementation Product

- (id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if (self) {
        if (!IsNull([json objectForKey:@"id"])) {
            self.identifier = [json objectForKey:@"id"];
        }
        if (!IsNull([json objectForKey:@"title"])) {
            self.title = [json objectForKey:@"title"];
        }
        if (!IsNull([json objectForKey:@"price"])) {
            self.price = [[json objectForKey:@"price"] doubleValue];
        }
        if (!IsNull([json objectForKey:@"thumbnail"])) {
            self.thumbnail = [json objectForKey:@"thumbnail"];
        }
        if (!IsNull([json objectForKey:@"currency_id"])) {
            self.currency = ([[json objectForKey:@"currency_id"] isEqualToString:@"USD"] ? @"U$S" : @"$");
        }
        if (!IsNull([json objectForKey:@"pictures"])) {
            NSArray *picturesArray = [json objectForKey:@"pictures"];
            self.pictures = [[NSMutableArray alloc] initWithCapacity:picturesArray.count];
            for (NSDictionary *pic in picturesArray) {
                [self.pictures addObject:[pic objectForKey:@"url"]];
            }
        }
        if (!IsNull([json objectForKey:@"available_quantity"])) {
            self.available_quantity = [[json objectForKey:@"available_quantity"] integerValue];
        }
        if (!IsNull([json objectForKey:@"sold_quantity"])) {
            self.sold_quantity = [[json objectForKey:@"sold_quantity"] integerValue];
        }
        if (!IsNull([json objectForKey:@"condition"])) {
            self.condition = NSLocalizedString([json objectForKey:@"condition"], nil);
        }
        if (!IsNull([json objectForKey:@"seller_address"]) && !IsNull([[json objectForKey:@"seller_address"] objectForKey:@"city"])) {
            if (!IsNull([[[json objectForKey:@"seller_address"] objectForKey:@"city"] objectForKey:@"name"])) {
                self.city = [[[json objectForKey:@"seller_address"] objectForKey:@"city"] objectForKey:@"name"];
            }
        }
        
    }
    return self;
}


- (NSString *)description{
    return [NSString stringWithFormat:@"%@ - %@", self.identifier, self.title];
}
@end
