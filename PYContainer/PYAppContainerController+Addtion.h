//
//  AppContainerController+Addtion.h
//  demo
//
//  Created by yr on 16/6/2.
//  Copyright © 2016年 yr. All rights reserved.
//

#import "PYAppContainerController.h"

/**
 *  @author YangRui, 16-02-25 13:02:23
 *
 *  视图控制器容器简化方法扩展
 */
@interface PYAppContainerController (Addtion)

/**
 *  显示子视图控制器
 */
- (BOOL)showChildViewController:(UIViewController *)controller;

- (BOOL)showChildViewController:(UIViewController *)controller
                 finishCallBack:(void (^)(void))cb;

- (BOOL)showChildViewController:(UIViewController *)controller
                   useAnimation:(BOOL)useAnimation;

- (BOOL)showChildViewController:(UIViewController *)controller
                 customAnimator:(id<UIViewControllerAnimatedTransitioning>)animator;

- (BOOL)showChildViewController:(UIViewController *)controller
                  isInteractive:(BOOL)isInteractive;


/**
 *  隐藏子视图控制器
 */
- (BOOL)hiddenChildViewController;

- (BOOL)hiddenChildViewControllerWithFinishCallBack:(void (^)(void))cb;

- (BOOL)hiddenChildViewControllerUseAnimation:(BOOL)useAnimation;

- (BOOL)hiddenChildViewControllerWithCustomAnimator:(id<UIViewControllerAnimatedTransitioning>)animator;

- (BOOL)hiddenChildViewControllerIsInteractive:(BOOL)isInteractive;

/**
 *  改变根视图控制器
 */
- (BOOL)changeRootViewController:(UIViewController *)controller;

- (BOOL)changeRootViewController:(UIViewController *)controller
                  finishCallBack:(void (^)(void))cb;

- (BOOL)changeRootViewController:(UIViewController *)controller
                    useAnimation:(BOOL)useAnimation;

- (BOOL)changeRootViewController:(UIViewController *)controller
                  customAnimator:(id<UIViewControllerAnimatedTransitioning>)animator;

- (BOOL)changeRootViewController:(UIViewController *)controller
                   isInteractive:(BOOL)isInteractive;


@end