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

static dispatch_queue_t imageQueue;

@interface ProductsVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) ProductsTableView *tblProducts;
@property (nonatomic, strong) NSMutableDictionary *images;
@end

@implementation ProductsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.images = [[NSMutableDictionary alloc] init];
        imageQueue = dispatch_queue_create("com.company.app.imageQueue", NULL);
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
        NSLog(@"Scroll End Called");
        self.tblProducts.tableFooterView.hidden = NO;
        [self makeSearch];

    }
}



- (void)makeSearch{
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t myQueue = dispatch_queue_create("q_get", NULL);
    dispatch_async(myQueue, ^{
        [[ProductManager sharedInstance] searchBy:@"ipod"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([ProductManager sharedInstance].allProducts.count == 0) {
                #warning desplegar mensaje de que no se encontraron resultados para la busqueda
            }else{
                [[weakSelf tblProducts] reloadData];
            }
        });
    });
    [self.tblProducts reloadData];
}


@end
