//
//  RestConsumer.m
//  MeliTest
//
//  Created by German Pereyra on 5/16/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "ProductManager.h"
#import "Product.h"


static ProductManager *sharedPManager = nil;

@implementation ProductManager


+ (ProductManager *)sharedInstance {
    @synchronized(self) {
        if (sharedPManager == nil) {
            sharedPManager = [[self alloc] init]; // assignment not done here
        }
    }
    return sharedPManager;
}

- (id)init{
    self = [super init];
    if (self) {
        self.allProducts = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)searchBy:(NSString *)search;
{
    NSString *strURL = [[NSString stringWithFormat:@"https://api.mercadolibre.com/sites/MLU/search?q=%@&limit=10&offset=%i", search, self.allProducts.count - 1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSLog(@"request %@", url);
    
    NSURLResponse* response = nil;
    
    NSURLRequest* urlRequest =  [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSError *error;
    NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error] ;

    if (error) {
        @throw [[NSException alloc] initWithName:@"searviceConsume" reason:error.description userInfo:nil];
    }
    
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL];

    Product *newProduct = nil;
    NSArray *jsonList = [jsonResult objectForKey:@"results"];
    
    for (NSDictionary *jsonProd in jsonList) {
        newProduct = [[Product alloc] initWithJson:jsonProd];
        if (newProduct) {
            [self.allProducts addObject:newProduct];
        }
        newProduct = nil;
    }
}


@end
