//
//  ProductCell.h
//  MeliTest
//
//  Created by German Pereyra on 5/16/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblPrice;
@property (nonatomic, strong) UIImageView *imgThumbnail;

- (void)displayInfoWithTitle:(NSString *)title price:(double)price;
- (void)setProductImage:(UIImage *)img;
@end
