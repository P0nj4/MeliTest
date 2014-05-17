//
//  ProductDescriptionVC.m
//  MeliTest
//
//  Created by German Pereyra on 5/17/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "ProductDescriptionVC.h"

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
    
    UIWebView *Wview = [[UIWebView alloc] initWithFrame:CGRectMake(10, 65, 300, self.view.bounds.size.height - 65)];
    [Wview loadHTMLString:@"\n<p>IPOD 4</p>\r\n<p>16 GB</p>\r\n<p>IMPECABLE</p>\r\n<p>MUY POCO USO</p>\r\n<p>CON CARGADOR</p>" baseURL:nil];
    [self.view addSubview:Wview];

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
