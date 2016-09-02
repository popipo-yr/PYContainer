//
//  ViewCtrlGenerate.h
//  Demo
//
//  Created by yr on 16/8/18.
//  Copyright © 2016年 yr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewCtrlGenerate : NSObject


+ (UIViewController*)generateVCWithConfig:(void(^)(UIViewController* vc,
                                                   UIButton* backButton))config
                                backBlock:(void(^)(UIViewController* vc))backBlock;

+ (UIViewController*)generateInteractiveVCWithConfig:(void(^)(UIViewController* vc))config
                                           backBlock:(void(^)(UIViewController* vc))backBlock
                                                 tip:(NSString*)tip;

@end
