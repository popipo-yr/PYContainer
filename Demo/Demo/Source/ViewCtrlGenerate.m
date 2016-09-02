//
//  ViewCtrlGenerate.m
//  Demo
//
//  Created by yr on 16/8/18.
//  Copyright © 2016年 yr. All rights reserved.
//

#import "ViewCtrlGenerate.h"
#import <objc/runtime.h>
#import "PYAppContainerController.h"

@interface ClickViewController : UIViewController

@property (nonatomic, copy)   void(^backCall)(UIViewController* vc);
@property (nonatomic, strong) UIButton* backButton;

@end

@implementation ClickViewController

-(instancetype)init
{
    if (self = [super init]) {
        _backButton = [UIButton new];
    }
    return self;
}

-(void)viewDidLoad{

    [super viewDidLoad];
    
    _backButton.center = self.view.center;
    _backButton.bounds = CGRectMake(0, 0, 200, 40);
    
    [self.view addSubview:_backButton];
    [_backButton addTarget:self
                   action:@selector(backEvent)
         forControlEvents:UIControlEventTouchUpInside];
}

-(void)backEvent{

    if (self.backCall) {
        self.backCall(self);
    }
}

@end


@interface SpanViewController : UIViewController{

    CGPoint _startPoint;
}

@property (nonatomic, copy)   void(^backCall)(UIViewController* vc);
@property (nonatomic, strong) NSString* tip;

@end

@implementation SpanViewController



-(void)viewDidLoad{
    
    [super viewDidLoad];
   
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(pan:)];
    
    [self.view addGestureRecognizer:pan];
    
    UILabel* label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 200, 40);
    label.center = self.view.center;
    label.text   = self.tip;
    [self.view addSubview:label];

}


-(void)pan:(UIPanGestureRecognizer*)gr
{
    if (gr.state == UIGestureRecognizerStateBegan) {
      
        if (self.backCall) {
            self.backCall(self);
        }
       
        _startPoint = [gr translationInView:self.view.window];
        
        
    }else if(gr.state == UIGestureRecognizerStateChanged){
        
        CGPoint curPoint = [gr translationInView:self.view.window];
       
        CGFloat update = (curPoint.x - _startPoint.x) / CGRectGetWidth(self.view.bounds);
        
        
        [self.containerController.transController updateInteractiveTransition:update];
        
    }else{
        
        CGPoint curPoint = [gr translationInView:self.view.window];
        
        CGFloat update = (curPoint.x - _startPoint.x) / CGRectGetWidth(self.view.bounds);
        
        if (update > 0.5) {
            [self.containerController.transController finishInteractiveTransition];
        }else{
            [self.containerController.transController cancelInteractiveTransition];
        }
    }
    
}

@end


@implementation ViewCtrlGenerate

+ (UIViewController*)generateVCWithConfig:(void(^)(UIViewController* vc,
                                                   UIButton* backButton))config
                                backBlock:(void(^)(UIViewController* vc))backBlock
{
    ClickViewController* vc = [[ClickViewController alloc] init];
   
    vc.backCall = backBlock;
    
    if (config) {
        config(vc, vc.backButton);
    }
    
    return vc;
}

+ (UIViewController*)generateInteractiveVCWithConfig:(void(^)(UIViewController* vc))config
                                           backBlock:(void(^)(UIViewController* vc))backBlock
                                                 tip:(NSString*)tip;
{
    SpanViewController* vc = [[SpanViewController alloc] init];
    
    vc.backCall = backBlock;
    vc.tip      = tip;
    
    if (config) {
        config(vc);
    }
    
    return vc;

}

@end
