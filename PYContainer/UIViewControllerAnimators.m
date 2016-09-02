//
//  UIViewControllerAnimators.m
//  demo
//
//  Created by yr on 16/3/31.
//  Coyrright © 2016年 yr. All rights reserved.
//

#import "UIViewControllerAnimators.h"

@implementation TransitionAnimateL2R {
    CGRect                  _fromOriginFrame;
    __weak UIViewController *_fromVC;
    __weak UIViewController *_toVC;
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)context
{
    return 0.5f;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)context
{
    _toVC   = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    _fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[context containerView] addSubview:_toVC.view];

    _fromOriginFrame = _fromVC.view.frame;
    [self changeToViewToFromViewLeft];

    __weak typeof(context) context_weak = context;

    [UIView animateWithDuration:[self transitionDuration:context]
                     animations:^{
         CGRect fNewFrame    = _fromOriginFrame;
         fNewFrame.origin.x += fNewFrame.size.width;

         _fromVC.view.frame = fNewFrame;
         _toVC.view.frame   = _fromVC.view.bounds;
     } completion:^(BOOL finished) {
         [context_weak completeTransition:![context_weak transitionWasCancelled]];
     }];
}


- (void)animationEnded:(BOOL)transitionCompleted
{
    if (transitionCompleted == false) {
        _fromVC.view.frame = _fromOriginFrame;
        [self changeToViewToFromViewLeft];
    }
}


- (void)changeToViewToFromViewLeft
{
    CGRect tFrame    = _fromVC.view.frame;
    tFrame.origin.x -= tFrame.size.width;
    _toVC.view.frame = tFrame;
}


@end



@implementation TransitionAnimateR2L {
    CGRect                  _fromOriginFrame;
    __weak UIViewController *_fromVC;
    __weak UIViewController *_toVC;
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)context
{
    return 0.5f;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)context
{
    _toVC   = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    _fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[context containerView] addSubview:_toVC.view];

    _fromOriginFrame = _fromVC.view.frame;
    [self changeToViewToFromViewRight];

    __weak typeof(context) context_weak = context;

    [UIView animateWithDuration:[self transitionDuration:context]
                     animations:^{
         CGRect fFrame    = _fromOriginFrame;
         fFrame.origin.x -= fFrame.size.width;

         _fromVC.view.frame = fFrame;
         _toVC.view.frame   = _fromVC.view.bounds;
     } completion:^(BOOL finished) {
         [context_weak completeTransition:![context_weak transitionWasCancelled]];
     }];
}


- (void)animationEnded:(BOOL)transitionCompleted
{
    if (transitionCompleted == false) {
        _fromVC.view.frame = _fromOriginFrame;
        [self changeToViewToFromViewRight];
    }
}


- (void)changeToViewToFromViewRight
{
    CGRect tFrame    = _fromVC.view.frame;
    tFrame.origin.x += tFrame.size.width;
    _toVC.view.frame = tFrame;
}


@end