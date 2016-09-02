//
//  AppContainerController.m
//  yr
//
//  Created by yr on 15/11/18.
//  Coyrright © 2015年 yr. All rights reserved.
//

#import "PYAppContainerController.h"
#import "PYTransitionAnimator.h"


@interface PYAppContainerController (){
    UIViewController *_rootViewController;     //主视图控制器
    UIViewController *_curShowViewController;     //当前显示视图控制器
}

@property (nonatomic, copy) void (^operateFinishCallBack)(void); //视图控制器切换完成回调
@property (nonatomic, assign) BOOL                 isTransing; //是否在进行转换
@property (nonatomic, strong) PYTransitionController *transController; //持有视图转场需要的对象

@end


@implementation PYAppContainerController

- (instancetype)initWithRootViewController:(UIViewController *)controller
{
    if (self = [super init]) {
        [controller willMoveToParentViewController:nil];
        [self addChildViewController:controller];
        _rootViewController    = controller;
        _curShowViewController = _rootViewController;
    }

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:_curShowViewController.view];

    //当使用自动布局的时候_curShowViewController.view 的大小为{0,0},需要设置值
    _curShowViewController.view.frame = self.view.bounds;
}


/**
 *  状态栏样式通过显示视图控制器配置显示
 */
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return _curShowViewController;
}


#pragma mark - outMethoder

- (BOOL)changeRootViewController:(UIViewController *)controller
                  finishCallBack:(void (^)(void))cb
                    useAnimation:(BOOL)useAnimation
                  customAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
                   isInteractive:(BOOL)isInteractive;
{
    if (_isTransing ||
        nil == _rootViewController ||
        nil == controller ||
        _rootViewController == controller) return false;

    self.operateFinishCallBack = cb;

    __weak typeof(self) self_weak_             = self;
    __weak typeof(controller) controller_weak_ = controller;

    [self _changeViewControllerFrom:_rootViewController
                                 to:controller
                       useAnimation:useAnimation
                    completionBlock:^(BOOL isFinish) {
         if (isFinish == true) {
             [self_weak_ _adjustCurShowVC:controller_weak_];
             [self_weak_ _adjustRootVC:controller_weak_];
         }
     }
                            animate:animator
                      isInteractive:isInteractive];

    return true;
}


- (BOOL)showChildViewController:(UIViewController *)controller
                 finishCallBack:(void (^)(void))cb
                   useAnimation:(BOOL)useAnimation
                 customAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
                  isInteractive:(BOOL)isInteractive;
{
    if (_isTransing ||
        nil == _rootViewController ||
        nil == controller ||
        _curShowViewController == controller) return false;

    self.operateFinishCallBack = cb;

    __weak typeof(self) self_weak_             = self;
    __weak typeof(controller) controller_weak_ = controller;

    [self _changeViewControllerFrom:_curShowViewController
                                 to:controller
                       useAnimation:useAnimation
                    completionBlock:^(BOOL isFinish) {
         if (isFinish) {
             [self_weak_ _adjustCurShowVC:controller_weak_];
         }
     }
                            animate:animator
                      isInteractive:isInteractive];

    return true;
}


- (BOOL)hiddenChildViewControllerWithFinishCallBack:(void (^)(void))cb
                                       useAnimation:(BOOL)useAnimation
                                     customAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
                                      isInteractive:(BOOL)isInteractive;
{
    if (_isTransing ||
        nil == _rootViewController ||
        nil == _curShowViewController ||
        _curShowViewController == _rootViewController) return false;

    self.operateFinishCallBack = cb;

    __weak typeof(self) self_weak_                      = self;
    __weak typeof(_rootViewController) controller_weak_ = _rootViewController;

    [self _changeViewControllerFrom:_curShowViewController
                                 to:_rootViewController
                       useAnimation:useAnimation
                    completionBlock:^(BOOL isFinish) {
         if (isFinish) {
             [self_weak_ _adjustCurShowVC:controller_weak_];
         }
     }
                            animate:animator
                      isInteractive:isInteractive];

    return true;
}


- (void)_changeViewControllerFrom:(UIViewController *)fromController
                               to:(UIViewController *)toController
                     useAnimation:(BOOL)useAnimation
                  completionBlock:(void (^)(BOOL))completionBlock
                          animate:(id<UIViewControllerAnimatedTransitioning>)animate
                    isInteractive:(BOOL)isInteractive
{
    if (nil == fromController || nil == toController) return;

    UIView *toView = toController.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toView.frame            = self.view.frame;

    [fromController willMoveToParentViewController:nil];
    [self addChildViewController:toController];

    ///----------------- block-start
    __weak typeof(self) self_weak_                     = self;
    __weak typeof(fromController) fromController_weak_ = fromController;
    __weak typeof(toController) toController_weak_     = toController;

    void (^completionBlockCoyr)(BOOL) = [completionBlock copy];

    //////////
    void (^finishChangeBlock)(void) = ^(void){
        [fromController_weak_.view removeFromSuperview];
        [fromController_weak_ removeFromParentViewController];
        [toController_weak_ didMoveToParentViewController:self_weak_];

        if (self_weak_.operateFinishCallBack) {
            self_weak_.operateFinishCallBack();
            self_weak_.operateFinishCallBack = nil;
        }

        if (completionBlockCoyr) {
            completionBlockCoyr(YES);
        }

        [toController_weak_ setNeedsStatusBarAppearanceUpdate];
    };

    /////////
    void (^cancelChangeBlock)(void) = ^(void){
        [toController_weak_.view removeFromSuperview];

        self_weak_.operateFinishCallBack = nil;

        if (completionBlockCoyr) {
            completionBlockCoyr(false);
        }

        [fromController_weak_ setNeedsStatusBarAppearanceUpdate];
    };

    /////////
    void (^contextCompletionBlock)(BOOL) = ^(BOOL isCompleted){

        if (isCompleted) {
            finishChangeBlock();
        } else {
            cancelChangeBlock();
        }
       
        if (isCompleted) {
            [self_weak_.transController finishTransition];
        }

        self_weak_.isTransing                  = false;
        self_weak_.view.userInteractionEnabled = YES;
        self_weak_.transController             = nil;
    };
    ///------------- block-end

    if (useAnimation == false) {
        [self.view addSubview:toView];
        finishChangeBlock();
        return;
    }

    PYTransitionContext *context = [[PYTransitionContext alloc]
                                    initWithFromController:fromController
                                    toController:toController];
    if (animate == nil) {//没有设置,使用默认的
        animate = [PYTransitionAnimator new];
    }

    context.containerView   = self.view;
    context.animated        = true;
    context.interactive     = false;
    context.completionBlock = contextCompletionBlock;

    self.isTransing                  = true;
    self.view.userInteractionEnabled = false; //关闭交互,在完成后开启

    _transController          = [PYTransitionController new];
    _transController.animator = animate;
    _transController.context  = context;

    if (isInteractive) {
        context.interactive = YES;
        [_transController startInteractiveTransition:context];
    }

    //开始
    [animate animateTransition:context];
}


- (UIViewController *)currentShowViewController
{
    return _curShowViewController;
}


- (void)_adjustCurShowVC:(UIViewController *)curShowVC
{
    _curShowViewController = curShowVC;
}


- (void)_adjustRootVC:(UIViewController *)rootVC
{
    _rootViewController = rootVC;
}


@end



@implementation UIViewController (PYAppContainerController)

- (PYAppContainerController *)containerController
{
    UIViewController *vc = self;

    while (vc) {
        if ([vc isKindOfClass:[PYAppContainerController class]]) {
            return (PYAppContainerController *)vc;
        }

        vc = vc.parentViewController ? : vc.presentingViewController;
    }

    return nil;
}


@end