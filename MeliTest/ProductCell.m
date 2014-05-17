//
//  ProductCell.m
//  MeliTest
//
//  Created by German Pereyra on 5/16/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//
#define kTitleFontHeight 9
#define kPriceFontHeight 12

#import "ProductCell.h"
#import "UIUtilities.h"

@implementation ProductCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, CGRectGetWidth(self.contentView.frame) - 120, [UIFont systemFontOfSize:kTitleFontHeight].lineHeight)];
        self.lblTitle.font = [UIFont systemFontOfSize:kTitleFontHeight];
        self.lblTitle.backgroundColor = [UIColor clearColor];
        self.lblTitle.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f];
        self.lblTitle.numberOfLines = 0;
        
        self.lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(self.lblTitle.frame) + 10, CGRectGetWidth(self.lblTitle.frame), [UIFont systemFontOfSize:kPriceFontHeight].lineHeight)];
        self.lblPrice.font = [UIFont systemFontOfSize:kPriceFontHeight];
        self.lblPrice.backgroundColor = [UIColor clearColor];
        self.lblPrice.textColor =  [UIColor colorWithRed:153/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        
        self.imgThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 65, 65)];
        
        
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblPrice];
        [self.contentView addSubview:self.imgThumbnail];
        
        [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayInfoWithTitle:(NSString *)title price:(double)price{
    self.lblTitle.text = title;
    CGRect titleRect = self.lblTitle.frame;
    
    CGSize newSize = [title sizeWithFont:self.lblTitle.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.contentView.frame) - 120, CGFLOAT_MAX) lineBreakMode:NSLineBreakByClipping];
    titleRect.size = newSize;
    
    self.lblTitle.frame = titleRect;
    self.lblPrice.frame = CGRectMake(self.lblPrice.frame.origin.x, CGRectGetMaxY(self.lblTitle.frame) + 10, self.lblPrice.frame.size.width, self.lblPrice.frame.size.height);
    
#warning el formato no es el mismo, y además falta saber si son dolares o no
    self.lblPrice.text = [UIUtilities stringWithDoubleAndCurrencySymbol:price];
}

- (void)setProductImage:(UIImage *)img{
    self.imgThumbnail.hidden = NO;
    self.imgThumbnail.image = img;
}

@end
