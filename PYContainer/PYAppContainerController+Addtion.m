//
//  AppContainerController+Addtion.m
//  demo
//
//  Created by yr on 16/6/2.
//  Copyright © 2016年 yr. All rights reserved.
//

#import "PYAppContainerController+Addtion.h"

@implementation PYAppContainerController (Addtion)


- (BOOL)showChildViewController:(UIViewController *)controller
{
    return [self showChildViewController:controller
                          finishCallBack:nil
                            useAnimation:YES
                          customAnimator:nil
                           isInteractive:false];
}


- (BOOL)showChildViewController:(UIViewController *)controller
                 finishCallBack:(void (^)(void))cb
{
    return [self showChildViewController:controller
                          finishCallBack:cb
                            useAnimation:YES
                          customAnimator:nil
                           isInteractive:false];
}


- (BOOL)showChildViewController:(UIViewController *)controller
                   useAnimation:(BOOL)useAnimation
{
    return [self showChildViewController:controller
                          finishCallBack:nil
                            useAnimation:useAnimation
                          customAnimator:nil
                           isInteractive:false];
}


- (BOOL)showChildViewController:(UIViewController *)controller
                 customAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return [self showChildViewController:controller
                          finishCallBack:nil
                            useAnimation:YES
                          customAnimator:animator
                           isInteractive:false];
}


- (BOOL)showChildViewController:(UIViewController *)controller
                  isInteractive:(BOOL)isInteractive
{
    return [self showChildViewController:controller
                          finishCallBack:nil
                            useAnimation:YES
                          customAnimator:nil
                           isInteractive:isInteractive];
}


- (BOOL)hiddenChildViewController
{
    return [self hiddenChildViewControllerWithFinishCallBack:nil
                                                useAnimation:YES
                                              customAnimator:nil
                                               isInteractive:false];
}


- (BOOL)hiddenChildViewControllerWithFinishCallBack:(void (^)(void))cb
{
    return [self hiddenChildViewControllerWithFinishCallBack:cb
                                                useAnimation:YES
                                              customAnimator:nil
                                               isInteractive:false];
}


- (BOOL)hiddenChildViewControllerUseAnimation:(BOOL)useAnimation
{
    return [self hiddenChildViewControllerWithFinishCallBack:nil
                                                useAnimation:useAnimation
                                              customAnimator:nil
                                               isInteractive:false];
}


- (BOOL)hiddenChildViewControllerWithCustomAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return [self hiddenChildViewControllerWithFinishCallBack:nil
                                                useAnimation:YES
                                              customAnimator:animator
                                               isInteractive:false];
}


- (BOOL)hiddenChildViewControllerIsInteractive:(BOOL)isInteractive
{
    return [self hiddenChildViewControllerWithFinishCallBack:nil
                                                useAnimation:YES
                                              customAnimator:nil
                                               isInteractive:isInteractive];
}


- (BOOL)changeRootViewController:(UIViewController *)controller
{
    return [self changeRootViewController:controller
                           finishCallBack:nil
                             useAnimation:YES
                           customAnimator:nil
                            isInteractive:false];
}


- (BOOL)changeRootViewController:(UIViewController *)controller
                  finishCallBack:(void (^)(void))cb
{
    return [self changeRootViewController:controller
                           finishCallBack:cb
                             useAnimation:YES
                           customAnimator:nil
                            isInteractive:false];
}


- (BOOL)changeRootViewController:(UIViewController *)controller
                    useAnimation:(BOOL)useAnimation
{
    return [self changeRootViewController:controller
                           finishCallBack:nil
                             useAnimation:useAnimation
                           customAnimator:nil
                            isInteractive:false];
}


- (BOOL)changeRootViewController:(UIViewController *)controller
                  customAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return [self changeRootViewController:controller
                           finishCallBack:nil
                             useAnimation:YES
                           customAnimator:animator
                            isInteractive:false];
}


- (BOOL)changeRootViewController:(UIViewController *)controller
                   isInteractive:(BOOL)isInteractive
{
    return [self changeRootViewController:controller
                           finishCallBack:nil
                             useAnimation:YES
                           customAnimator:nil
                            isInteractive:isInteractive];
}


@end