//
//  ProductDescriptionVC.m
//  MeliTest
//
//  Created by German Pereyra on 5/17/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "ProductDescriptionVC.h"
#import "ProductManager.h"
#import "LoadingView.h"


@interface ProductDescriptionVC ()

@end

@implementation ProductDescriptionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *Wview = [[UIWebView alloc] initWithFrame:CGRectMake(10, 0, 300, self.view.bounds.size.height)];

    [self.view addSubview:Wview];
    
    [LoadingView loadingShowOnView:self.view animated:YES frame:self.view.bounds];
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t myQueue = dispatch_queue_create("q_getProductDetails", NULL);
    dispatch_async(myQueue, ^{

        @try {
            [[ProductManager sharedInstance] setProductDescription:self.currentProduct];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.currentProduct.HTMLDescription.length > 0) {
                    [Wview loadHTMLString:[NSString stringWithFormat:@"<html><body>%@</body><html>", weakSelf.currentProduct.HTMLDescription] baseURL:nil];
                    [Wview setScalesPageToFit:YES];
                }else{
                    [Wview loadHTMLString:[NSString stringWithFormat:@"<html><body style=\"width:300px\"><p>%@</p></body><html>", weakSelf.currentProduct.PlainDescription] baseURL:nil];
                }
                
                
                
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
