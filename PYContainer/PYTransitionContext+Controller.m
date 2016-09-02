//
//  AppContainerAnimator.m
//  yr
//
//  Created by yr on 15/11/18.
//  Coyrright © 2015年 yr. All rights reserved.
//

#import "PYTransitionContext+Controller.h"

#pragma mark - PYTransitionContext

@interface PYTransitionContext (){
    NSDictionary *_controllers;
}
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic, assign) BOOL                     transitionWasCancelled;

@end

@implementation PYTransitionContext

- (instancetype)initWithFromController:(UIViewController *)fromController toController:(UIViewController *)toController
{
    if (self = [super init]) {
        _containerView     = fromController.view.superview;
        _presentationStyle = UIModalPresentationCustom;
        _controllers       = @{UITransitionContextFromViewControllerKey:fromController,
                               UITransitionContextToViewControllerKey:toController, };
    }

    return self;
}


-(void)setInteractive:(BOOL)interactive
{
    _interactive = interactive;
    if (_interactive) {
        [self containerView].layer.speed = 0;
    }
}

- (void)completeTransition:(BOOL)didComplete
{
    if (_interactive) {
        [self containerView].layer.speed = 1;
    }
    
    if (nil != _completionBlock) {
        _completionBlock(didComplete);
    }
}


- (UIViewController *)viewControllerForKey:(NSString *)key
{
    return _controllers[key];
}


- (CGRect)initialFrameForViewController:(UIViewController *)viewController
{
    return _containerView.bounds;
}


- (CGRect)finalFrameForViewController:(UIViewController *)viewController
{
    return _containerView.bounds;
}


- (UIView *)viewForKey:(NSString *)key
{
    return nil;
}


- (CGAffineTransform)targetTransform
{
    return CGAffineTransformIdentity;
}


- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
}


- (void)finishInteractiveTransition
{
    self.transitionWasCancelled = NO;
}


- (void)cancelInteractiveTransition
{
    self.transitionWasCancelled = YES;
}


@end



#pragma mark - PYTransitionController

@implementation PYTransitionController {
    CADisplayLink *_displayLink;
}


- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _context = transitionContext;
}


- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    if ([_context isInteractive] == false) return;

    percentComplete = fmaxf(fminf(percentComplete, 1), 0); //值必须在0-1的范围
    [self _updatePercentComplete:percentComplete];

    [_context updateInteractiveTransition:percentComplete];
}


- (void)cancelInteractiveTransition
{
    if ([_context isInteractive] == false) return;

    [_displayLink invalidate];

    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_cancelProcess)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

    [_context cancelInteractiveTransition];
}


- (void)finishInteractiveTransition
{
    if ([_context isInteractive] == false) return;

    CALayer *layer = [_context containerView].layer;

    CFTimeInterval pausedTime = [layer timeOffset];
    layer.timeOffset = 0.0;
    layer.beginTime  = 0.0;
    layer.speed      = 1.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;

    [_context finishInteractiveTransition];
}


- (void)finishTransition
{
    if ([self.animator respondsToSelector:@selector(animationEnded:)]) {
        [self.animator animationEnded:YES];
    }
}

#pragma mark - Private methods

- (void)_updateLayerTimeOffset:(CFTimeInterval)timeOffset
{
    [_context containerView].layer.timeOffset = timeOffset;
}


- (CFTimeInterval)_layerTimeOffset
{
    return [_context containerView].layer.timeOffset;
}


- (void)_updatePercentComplete:(CGFloat)percentComplete
{
    NSTimeInterval transitionDuration = [_animator transitionDuration:_context];
    CFTimeInterval layerTimeOffset    = percentComplete * transitionDuration;

    [self _updateLayerTimeOffset:layerTimeOffset];
}


- (void)_cancelProcess
{
    NSTimeInterval timeOffset = [self _layerTimeOffset] - [_displayLink duration];

    if (timeOffset < 0) {//回到起点,是否有更好的方式
        [self _finishCancelProcess];
    } else {
        [self _updateLayerTimeOffset:timeOffset];
    }
}


- (void)_finishCancelProcess
{
    [_displayLink invalidate];
    
    if ([self.animator respondsToSelector:@selector(animationEnded:)]) {
        [self.animator animationEnded:false];
    }

    CALayer *layer = [_context containerView].layer;
    
    [CATransaction begin];
    [layer removeAllAnimations];
    [layer.sublayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    [CATransaction  commit];
    

}


@end