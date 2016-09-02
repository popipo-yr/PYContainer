//
//  PYTransitionAnimator.m
//  demo
//
//  Created by yr on 16/6/3.
//  Copyright © 2016年 yr. All rights reserved.
//

#import "PYTransitionAnimator.h"

@implementation PYTransitionAnimator
{
    __weak UIViewController *_fromVC;
    __weak UIViewController *_toVC;
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)context
{
    return 1;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)context
{
    _toVC   = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    _fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[context containerView] addSubview:_toVC.view];

    _toVC.view.alpha = 0;

    __weak typeof(context) context_weak = context;

    [UIView animateWithDuration:[self transitionDuration:context]
                     animations:^{
         _toVC.view.alpha   = 1;
         _fromVC.view.alpha = 0;
     } completion:^(BOOL finished) {
         [context_weak completeTransition:![context_weak transitionWasCancelled]];
     }];
}


- (void)animationEnded:(BOOL)transitionCompleted
{
    _toVC.view.alpha   = 1;
    _fromVC.view.alpha = 1;
}


@end