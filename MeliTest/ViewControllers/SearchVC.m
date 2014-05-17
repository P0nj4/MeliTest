//
//  SearchVC.m
//  MeliTest
//
//  Created by German Pereyra on 5/17/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "SearchVC.h"
#import "UIUtilities.h"
#import "ProductsVC.h"



@interface SearchVC () <UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIImageView *logo;
@end

@implementation SearchVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 65, 320, 44)];
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        [self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
        [self.view addSubview:self.searchBar];
        //384 × 326
        self.logo = [[UIImageView alloc] initWithFrame:CGRectMake((320 - 192) / 2, (self.view.bounds.size.height  - 163) / 2, 192, 163)];
        self.logo.image = [UIImage imageNamed:@"rootLogo"];
        [self.view addSubview:self.logo];
        
        self.view.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    ProductsVC *productsVC = [[ProductsVC alloc] init];
    productsVC.textForSearch = self.searchBar.text;
    [self.navigationController pushViewController:productsVC animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.3 animations:^{
        self.logo.frame = CGRectMake((320 - 192) / 2, CGRectGetMaxY(searchBar.frame) , 192, 163);
    }];
    return YES;
}



- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.3 animations:^{
        self.logo.frame = CGRectMake((320 - 192) / 2, (self.view.bounds.size.height  - 163) / 2, 192, 163);
    }];
    return YES;
}


@end
