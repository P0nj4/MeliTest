//
//  ProductDetailsVC.m
//  MeliTest
//
//  Created by German Pereyra on 5/17/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#define kTitleFontHeight 12
#define kPriceFontHeight 12

#import "ProductDetailsVC.h"
#import "ProductManager.h"
#import "LoadingView.h"
#import "UIViewPictureSwype.h"
#import "ProductDescriptionVC.h"
#import "UIUtilities.h"

@interface ProductDetailsVC ()
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UILabel *lblInfo;
@end
/*
"Condition" = "Condición";
"Sold" = "Vendidos";
"Quantity" = "Cantidad";
"Description" = "Descripción";
"Seller_City" = "Ciudad del vendedor";
*/
@implementation ProductDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.images = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.currentProduct) {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"GenericError", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 300, [UIFont systemFontOfSize:kTitleFontHeight].lineHeight)];
    lblTitle.font = [UIFont systemFontOfSize:kTitleFontHeight];
    lblTitle.text = self.currentProduct.title;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f];
    lblTitle.numberOfLines = 0;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    CGRect titleRect = lblTitle.frame;
    
    CGSize newSize = [self.currentProduct.title sizeWithFont:lblTitle.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByClipping];
    newSize.width = 300;
    titleRect.size = newSize;
    lblTitle.frame = titleRect;
    
    
    UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, [UIFont systemFontOfSize:kPriceFontHeight].lineHeight)];
    lblPrice.font = [UIFont systemFontOfSize:kPriceFontHeight];
    lblPrice.backgroundColor = [UIColor clearColor];
    lblPrice.textAlignment = NSTextAlignmentCenter;
    lblPrice.textColor =  [UIColor colorWithRed:153/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    
    lblPrice.frame = CGRectMake(lblPrice.frame.origin.x, CGRectGetMaxY(lblTitle.frame) + 10, lblPrice.frame.size.width, lblPrice.frame.size.height);
    lblPrice.text = [UIUtilities stringWithDoubleAndCurrencySymbol:self.currentProduct.price currencySymbol:self.currentProduct.currency];
    
    [self.view addSubview:lblTitle];
    [self.view addSubview:lblPrice];
    
    
    self.lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 275, 300, 0)];
    self.lblInfo.textAlignment = NSTextAlignmentCenter;
    self.lblInfo.font = [UIFont systemFontOfSize:9];
    [self.view addSubview:self.lblInfo];
    self.lblInfo.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f];
    self.lblInfo.numberOfLines = 0;
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(showDescription)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:NSLocalizedString(@"SeeDescription", nil) forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 400.0, 160.0, 40.0);
    button.center = CGPointMake(self.view.center.x, button.center.y);
    [self.view addSubview:button];
    
    [LoadingView loadingShowOnView:self.view animated:NO frame:self.view.bounds];
    
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t myQueue = dispatch_queue_create("q_getProductDetails", NULL);
    dispatch_async(myQueue, ^{
        @try {
            [[ProductManager sharedInstance] setProductInformation:self.currentProduct];
            
            for (NSString *urlIMG in self.currentProduct.pictures) {
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlIMG]];
                UIImage *imgAux = [UIImage imageWithData:imageData];
                if (imgAux) {
                    [weakSelf.images addObject:imgAux];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewPictureSwype *asScroll = [[UIViewPictureSwype alloc]initWithFrame:CGRectMake((weakSelf.view.bounds.size.width - 200) / 2,CGRectGetMaxY(lblTitle.frame) + 10 ,200.0,200.0) withImages:self.images];
                [weakSelf.view addSubview:asScroll];
                
                lblPrice.frame = CGRectMake(lblPrice.frame.origin.x, CGRectGetMaxY(asScroll.frame) + 10, lblPrice.frame.size.width, lblPrice.frame.size.height);
                
                weakSelf.lblInfo.text = [NSString stringWithFormat:NSLocalizedString(@"ProductDetailInfo", nil),weakSelf.currentProduct.condition, weakSelf.currentProduct.available_quantity, weakSelf.currentProduct.sold_quantity, weakSelf.currentProduct.city];
                
                weakSelf.lblInfo.frame = CGRectMake(weakSelf.lblInfo.frame.origin.x, CGRectGetMaxY(lblPrice.frame) + 10 , weakSelf.lblInfo.frame.size.width, [weakSelf.lblInfo.text sizeWithFont:weakSelf.lblInfo.font constrainedToSize:CGSizeMake(weakSelf.lblInfo.frame.size.width, 99999) lineBreakMode:self.lblInfo.lineBreakMode].height);
                NSLog(@"%@ %@",weakSelf.lblInfo.text,NSStringFromCGRect(weakSelf.lblInfo.frame));
                
                [LoadingView loadingHideOnView:weakSelf.view animated:YES];
            });
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"GenericError", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            });
        }
        
    });
    
}


- (void)showDescription{
    ProductDescriptionVC *vc = [[ProductDescriptionVC alloc] init];
    vc.currentProduct = self.currentProduct;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
