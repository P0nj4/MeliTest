//
//  LoadingView.m
//  PedidosYa!
//
//  Created by Germán Pereyra on 18/03/13.
//  Copyright (c) 2013 PedidosYa. All rights reserved.
//
#define kLoadingViewTag 321654987
#define kLoadingLabel 1132158
#import "LoadingView.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
        [self addSubview:activityIndicator];
        activityIndicator.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [activityIndicator startAnimating];
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 320, 30)];
        loadingLabel.textColor = [UIColor blackColor];
        loadingLabel.font = [UIFont systemFontOfSize:15];
        loadingLabel.text = [NSString stringWithFormat:@"%@...",NSLocalizedString(@"Loading", nil)];
        loadingLabel.backgroundColor = [UIColor colorWithRed:0.953 green:0.953 blue:0.953 alpha:1.0];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.center  = CGPointMake(self.frame.size.width / 2, (self.frame.size.height / 2) - 30 );
        loadingLabel.tag = kLoadingLabel;
        loadingLabel.isAccessibilityElement = NO;
        self.isAccessibilityElement = YES;
        self.accessibilityLabel = loadingLabel.text;
        [self addSubview:loadingLabel];
        
        self.backgroundColor =  [UIColor colorWithRed:0.953 green:0.953 blue:0.953 alpha:1.0];
    }
    return self;
}

-(void)setLoadingLabelText:(NSString *)loadingText{    
    ((UILabel *)[self viewWithTag:kLoadingLabel]).text = [NSString stringWithFormat:@"%@...",loadingText];
}


+ (void)loadingShowOnView:(UIView *)view animated:(BOOL)animated frame:(CGRect)frame{
    [self loadingShowOnView:view withTag:kLoadingViewTag animated:animated frame:frame];
}



+ (void)loadingShowOnView:(UIView *)view withTag:(long)tag animated:(BOOL)animated frame:(CGRect)frame{
    if(![view viewWithTag:tag]){
        LoadingView *loading = [[LoadingView alloc] initWithFrame:frame];
        loading.tag = tag;
        [view addSubview:loading];
        if(animated){
            loading.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                loading.alpha = 1;
            }];
        }
    }
}


+ (void)loadingHideOnView:(UIView *)view animated:(BOOL)animated{
    [self loadingHideOnView:view withTag:kLoadingViewTag animated:animated];
}


+ (void)loadingHideOnView:(UIView *)view withTag:(long)tag animated:(BOOL)animated{
    if([view viewWithTag:tag]){
        LoadingView *loading = (LoadingView *)[view viewWithTag:tag];
        if(animated){
            [UIView animateWithDuration:0.3 animations:^{
                loading.alpha = 0;
            } completion:^(BOOL finished) {
                [loading removeFromSuperview];
            }];
        }else{
            [loading removeFromSuperview];
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
