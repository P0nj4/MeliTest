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
        self.identifier = [json objectForKey:@"id"];
        self.title = [json objectForKey:@"title"];
        self.price = [[json objectForKey:@"price"] doubleValue];
        self.thumbnail = [json objectForKey:@"thumbnail"];
    }
    return self;
}


- (NSString *)description{
    return [NSString stringWithFormat:@"%@ - %@", self.identifier, self.title];
}
@end
