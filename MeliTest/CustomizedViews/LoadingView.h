//
//  LoadingView.h
//  PedidosYa!
//
//  Created by Germán Pereyra on 18/03/13.
//  Copyright (c) 2013 PedidosYa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
-(void)setLoadingLabelText:(NSString *)loadingText;
+ (void)loadingHideOnView:(UIView *)view animated:(BOOL)animated;
+ (void)loadingShowOnView:(UIView *)view animated:(BOOL)animated frame:(CGRect)frame;
+ (void)loadingShowOnView:(UIView *)view withTag:(long)tag animated:(BOOL)animated frame:(CGRect)frame;
+ (void)loadingHideOnView:(UIView *)view withTag:(long)tag animated:(BOOL)animated;
@end
