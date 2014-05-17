//
//  ProductsVC.m
//  MeliTest
//
//  Created by German Pereyra on 5/16/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "ProductsVC.h"
#import "Product.h"
#import "ProductManager.h"
#import "ProductsTableView.h"
#import "ProductCell.h"
#import "LoadingView.h"

static dispatch_queue_t imageQueue;

@interface ProductsVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) ProductsTableView *tblProducts;
@property (nonatomic, strong) NSMutableDictionary *images;
@property (nonatomic, assign) BOOL noMoreResults;
@end

@implementation ProductsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.images = [[NSMutableDictionary alloc] init];
        imageQueue = dispatch_queue_create("com.company.app.imageQueue", NULL);
        [[ProductManager sharedInstance].allProducts removeAllObjects];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tblProducts = [[ProductsTableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tblProducts];
    self.tblProducts.dataSource = self;
    self.tblProducts.delegate = self;
    
    [LoadingView loadingShowOnView:self.view animated:NO frame:self.view.bounds];
    [self makeSearch];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"count %i", [[[ProductManager sharedInstance] allProducts] count]);
    return [[[ProductManager sharedInstance] allProducts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellProducts"];
    Product *prodCell = [[[ProductManager sharedInstance] allProducts] objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellProducts"] ;
    }

    [cell displayInfoWithTitle:prodCell.title price:prodCell.price];
    
    cell.imgThumbnail.hidden = YES;
    
    UIImage *img = [self.images objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]];
    if (img) {
        //[[cell imageView] setImage:img];
        [cell setProductImage:img];
    } else {
        __weak typeof(self) weakSelf = self;
        dispatch_async(imageQueue, ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[prodCell thumbnail]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *img = [UIImage imageWithData:imageData];
                [weakSelf.images setValue:img forKey:[NSString stringWithFormat:@"%i", indexPath.row]];
                //[cell setProductImage:img];
                ProductCell *updateCell = (id)[weakSelf.tblProducts cellForRowAtIndexPath:indexPath];
                if (updateCell)
                    [cell setProductImage:img];
            });
        });
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height)
    {
        self.tblProducts.tableFooterView.hidden = NO;
        [self makeSearch];

    }
}


#pragma mark - Private methods
- (void)makeSearch{
    if(self.noMoreResults)
        return;
    if (self.textForSearch && self.textForSearch.length > 0) {
        __weak typeof(self) weakSelf = self;
        dispatch_queue_t myQueue = dispatch_queue_create("q_get", NULL);
        dispatch_async(myQueue, ^{
            @try {
                [[ProductManager sharedInstance] searchBy:self.textForSearch];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LoadingView loadingHideOnView:weakSelf.view animated:YES];
                    if ([ProductManager sharedInstance].allProducts.count == 0) {
                        [self displayDoesntFoundMessage];
                    }else{
                        if (([ProductManager sharedInstance].allProducts.count % 10) != 0) {
                            self.tblProducts.tableFooterView.hidden = YES;
                            self.noMoreResults = YES;
                        }
                        [[weakSelf tblProducts] reloadData];
                    }
                });
            }
            @catch (NSException *exception) {
                [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"GenericError", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }
        });
        [self.tblProducts reloadData];
    }else{
            [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"GenericError", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
}

- (void)displayDoesntFoundMessage{
    UIView *noResults = [[UIView alloc] initWithFrame:CGRectMake(10, 90, 300, 44)];
    noResults.backgroundColor = [UIColor colorWithRed:1 green:0.918 blue:0.655 alpha:1.0];
    noResults.layer.cornerRadius = 4;
    noResults.layer.borderWidth = 1;
    noResults.layer.borderColor = [UIColor colorWithRed:0.937 green:0.792 blue:0.318 alpha:1.0].CGColor;
    
    UILabel *lblNoResults = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300,  18)];
    lblNoResults.font = [UIFont systemFontOfSize:16];
    lblNoResults.text = [NSString stringWithFormat:NSLocalizedString(@"NoResults", nil), self.textForSearch];
    lblNoResults.textAlignment = NSTextAlignmentCenter;
    lblNoResults.backgroundColor = [UIColor clearColor];
    lblNoResults.textColor = [UIColor colorWithRed:0.31 green:0.231 blue:0.024 alpha:1.0];
    lblNoResults.tag = 999888;
    [noResults addSubview:lblNoResults];
    noResults.alpha = 0;
    
    CGSize size = [[NSString stringWithFormat:NSLocalizedString(@"NoResults", nil), self.textForSearch] sizeWithFont:lblNoResults.font constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:lblNoResults.lineBreakMode];
    
    if(size.height > [UIFont systemFontOfSize:16].lineHeight){
        lblNoResults.numberOfLines = 0;
        lblNoResults.frame = CGRectMake(0, 10, 300, size.height);
        noResults.frame = CGRectMake(10, 90, 300, size.height + 20);
    }
    
    self.tblProducts.hidden = YES;
    [self.view addSubview:noResults];
    [UIView animateWithDuration:0.3 animations:^{
        noResults.alpha = 1;
    }];
}


@end
