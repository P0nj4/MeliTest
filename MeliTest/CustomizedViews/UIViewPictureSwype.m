//
//  UIViewPictureTap.m
//  MeliTest
//
//  Created by German Pereyra on 5/17/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//
#define kiViewTag 44

#import "UIViewPictureSwype.h"

@interface UIViewPictureSwype ()
@property (nonatomic, weak) NSMutableArray *images;
@property (nonatomic, assign) NSInteger index;
@end


@implementation UIViewPictureSwype

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        self.images = images;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
        iv.tag = kiViewTag;
        iv.image = [self.images objectAtIndex:0];
        
        [self addSubview:iv];
#warning falta el icono
        if (self.images.count > 1) {
            UIView *icon = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 4, 4)];
            icon.layer.cornerRadius = 4;
            icon.backgroundColor = [UIColor whiteColor];
            [self addSubview:icon];
        }
        
        UISwipeGestureRecognizer *gestureRight;
        UISwipeGestureRecognizer *gestureLeft;
        gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];//direction is set by default.
        gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];//need to set direction.
        [gestureLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [gestureRight setDirection:(UISwipeGestureRecognizerDirectionRight)];

        [self addGestureRecognizer:gestureRight];//this gets things rolling.
        [self addGestureRecognizer:gestureLeft];//this gets things rolling.
        
    }
    return self;
}


-(void)handleSwipeGesture:(UISwipeGestureRecognizer *) sender {
    UIImageView *iv = (UIImageView *)[self viewWithTag:kiViewTag];
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.images.count - 1 == self.index) {
            return;
        }
        self.index++;
        [UIView animateWithDuration:0.1 animations:^{
            iv.alpha = 0;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                iv.alpha = 1;
            }];
        }];
        iv.image = [self.images objectAtIndex:self.index];
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.index == 0) {
            return;
        }
        self.index--;
        [UIView animateWithDuration:0.1 animations:^{
            iv.alpha = 0;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                iv.alpha = 1;
            }];
        }];

        iv.image = [self.images objectAtIndex:self.index];
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
