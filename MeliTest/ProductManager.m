//
//  RestConsumer.m
//  MeliTest
//
//  Created by German Pereyra on 5/16/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "ProductManager.h"


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

- (id)makeRequest:(NSString *)url error:(NSError **)error{
    NSString *strURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *urlForReq = [NSURL URLWithString:strURL];
    NSLog(@"request %@", urlForReq);
    
    NSURLResponse* response = nil;
    
    NSURLRequest* urlRequest =  [NSURLRequest requestWithURL:urlForReq cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:error] ;
    if (error && !data) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
}


- (void)searchBy:(NSString *)search;
{
    NSError *error;

    NSString *url = [NSString stringWithFormat:@"https://api.mercadolibre.com/sites/MLU/search?q=%@&limit=10&offset=%i", search, self.allProducts.count - 1];
    NSDictionary *jsonResult = [self makeRequest:url error:&error];
    
    if (error || !jsonResult) {
        @throw [[NSException alloc] initWithName:@"searviceConsume" reason:error.description userInfo:nil];
    }
    
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

- (void)setProductInformation:(Product *)item{
    
    NSError *error;
    
    NSString *url = [NSString stringWithFormat:@"https://api.mercadolibre.com/items/%@",item.identifier];
    NSDictionary *jsonResult = [self makeRequest:url error:&error];
    
    if (error || !jsonResult) {
        @throw [[NSException alloc] initWithName:@"searviceConsume" reason:error.description userInfo:nil];
    }
    [item setAttributesFromJson:jsonResult];
    
}



- (void)setProductDescription:(Product *)item{
    
    NSError *error;
    
    NSString *url = [NSString stringWithFormat:@"https://api.mercadolibre.com/items/%@/descriptions",item.identifier];
    NSArray *jsonResult = [self makeRequest:url error:&error];
    

    if (error || !jsonResult) {
        @throw [[NSException alloc] initWithName:@"searviceConsume" reason:error.description userInfo:nil];
    }
    item.HTMLDescription = [[jsonResult objectAtIndex:0] objectForKey:@"text"];
    item.PlainDescription = [[jsonResult objectAtIndex:0] objectForKey:@"plain_text"];
    
}

@end
