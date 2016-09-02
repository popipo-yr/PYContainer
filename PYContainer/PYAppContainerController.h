//
//  AppContainerController.h
//  yr
//
//  Created by yr on 15/11/18.
//  Coyrright © 2015年 yr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYTransitionContext+Controller.h"

/**
 *  @author YangRui, 16-02-25 13:02:23
 *
 *  视图控制器容器
 */
@interface PYAppContainerController : UIViewController

@property (nonatomic, readonly) UIViewController *currentShowViewController;
@property (nonatomic, readonly) UIViewController *rootViewController;
@property (nonatomic, readonly) PYTransitionController *transController;

/**
 *  创建容器
 *
 *  @param controller 主视图控制器
 */
- (instancetype)initWithRootViewController:(UIViewController *)controller;


/**--------------------
 * 下面的操作 note:
 * 当animator为nil时,将使用默认动画 PYTransitionAnimator
 * 当useAnimation为false时, isInteractive,animator将失效
 *--------------------------*/

/**
 *  改变根视图控制器
 */
- (BOOL)changeRootViewController:(UIViewController *)controller
                  finishCallBack:(void (^)(void))cb
                    useAnimation:(BOOL)useAnimation
                  customAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
                   isInteractive:(BOOL)isInteractive;

/**
 *  显示或者切换子视图控制器
 */
- (BOOL)showChildViewController:(UIViewController *)controller
                 finishCallBack:(void (^)(void))cb
                   useAnimation:(BOOL)useAnimation
                 customAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
                  isInteractive:(BOOL)isInteractive;

/**
 *  隐藏子视图控制器
 */
- (BOOL)hiddenChildViewControllerWithFinishCallBack:(void (^)(void))cb
                                       useAnimation:(BOOL)useAnimation
                                     customAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
                                      isInteractive:(BOOL)isInteractive;


@end


/**
 *  @author YangRui, 16-02-25 13:02:31
 *
 *  基础视图控制器获取当前容器对象的扩展
 */
@interface UIViewController (PYAppContainerController)
//当前视图的容器对象
@property(nonatomic, readonly, strong) PYAppContainerController *containerController;
@end