//
//  ProductsTableView.m
//  MeliTest
//
//  Created by German Pereyra on 5/16/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "ProductsTableView.h"

@implementation ProductsTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        UIActivityIndicatorView *loadMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadMore startAnimating];
        loadMore.center = footerView.center;
        [footerView addSubview:loadMore];
        self.tableFooterView = footerView;
        self.tableFooterView.hidden = NO;
    }
    return self;
}


@end
