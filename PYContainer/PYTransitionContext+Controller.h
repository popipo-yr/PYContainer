//
//  AppContainerAnimator.h
//  yr
//
//  Created by yr on 15/11/18.
//  Coyrright © 2015年 yr. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author YangRui, 16-02-25 13:02:23
 *
 *  转场动画上下文
 */
@interface PYTransitionContext : NSObject <UIViewControllerContextTransitioning>

/**
 *  创建上下文
 */
- (instancetype)initWithFromController:(UIViewController *)fromController
                          toController:(UIViewController *)toController;

/**
 *  转场完成回调
 */
@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete);

/**
 *  Context协议
 */
@property (nonatomic, assign, getter = isAnimated) BOOL    animated;
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@property (nonatomic, weak) UIView                         *containerView; //切换视图的容器视图

@end


#pragma mark -
/**
 *  @author YangRui, 16-02-25 13:02:23
 *
 *  转场动画控制器
 */
@interface PYTransitionController : NSObject <UIViewControllerInteractiveTransitioning>

/**
 *  协议接口参数
 */
@property (nonatomic, strong) id<UIViewControllerAnimatedTransitioning>animator;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> context;

/**
 *  协议接口方法
 */
- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;

- (void)finishTransition;

@end