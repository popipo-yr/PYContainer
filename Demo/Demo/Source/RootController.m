//
//  RootController.m
//  demo
//
//  Created by yr on 16/6/1.
//  Coyrright © 2016年 yr. All rights reserved.
//

#import "RootController.h"
#import "ViewCtrlGenerate.h"
#import "PYAppContainerController+Addtion.h"
#import "UIViewControllerAnimators.h"

@interface RootController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *_demoNameArray;
    NSArray *_callMethodArray;
}

@end

@implementation RootController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITableView *tableView = [UITableView new];
    tableView.frame = self.view.bounds;
    [self.view addSubview:tableView];

    tableView.delegate   = self;
    tableView.dataSource = self;
    tableView.contentInset   =  UIEdgeInsetsMake(100, 0, 0, 0);
    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;


    _demoNameArray = [[NSArray alloc]initWithObjects:
                      @"改变RootController",
                      @"显示ChildController",
                      @"显示ChildController并更改为其他",
                      @"交互式改变RootController",
                      @"交互式改变ChildController",
                      nil];

    _callMethodArray = [[NSArray alloc]initWithObjects:
                        NSStringFromSelector(@selector(changeRoot)),
                        NSStringFromSelector(@selector(showChild)),
                        NSStringFromSelector(@selector(showChildAndChange)),
                        NSStringFromSelector(@selector(changeRootInteractive)),
                        NSStringFromSelector(@selector(showChildInteractive)),
                        nil];
}


- (void)changeRoot
{

    UIViewController *vc = [ViewCtrlGenerate generateVCWithConfig:^(UIViewController *vc, UIButton *backButton) {
                                vc.view.backgroundColor = [UIColor greenColor];
                                [backButton setTitle:@"切换到原始root" forState:UIControlStateNormal];
                                [backButton setBackgroundColor:[UIColor blackColor]];
                            } backBlock:^(UIViewController *vc){
                                [vc.containerController changeRootViewController:self];
                            }];

    [self.containerController changeRootViewController:vc useAnimation:false];
}


- (void)showChild
{
    UIViewController *vc = [ViewCtrlGenerate generateVCWithConfig:^(UIViewController *vc, UIButton *backButton) {
        vc.view.backgroundColor = [UIColor redColor];
        [backButton setTitle:@"回退到root" forState:UIControlStateNormal];
        [backButton setBackgroundColor:[UIColor blackColor]];
    } backBlock:^(UIViewController *vc){
        [vc.containerController hiddenChildViewControllerWithCustomAnimator:
         [TransitionAnimateR2L new]];
    }];
    
    [self.containerController showChildViewController:vc
                                       customAnimator:[TransitionAnimateR2L new]];
}


- (void)showChildAndChange
{
    UIViewController *firstChild = [ViewCtrlGenerate generateVCWithConfig:^(UIViewController *vc, UIButton *backButton) {
        vc.view.backgroundColor = [UIColor redColor];
        [backButton setTitle:@"显示其他child" forState:UIControlStateNormal];
        [backButton setBackgroundColor:[UIColor blackColor]];
    } backBlock:^(UIViewController *vc){
       
        UIViewController *secondChild = [ViewCtrlGenerate generateVCWithConfig:^(UIViewController *vc, UIButton *backButton) {
            vc.view.backgroundColor = [UIColor blueColor];
            [backButton setTitle:@"回退到root" forState:UIControlStateNormal];
            [backButton setBackgroundColor:[UIColor blackColor]];
        } backBlock:^(UIViewController *vc){
            [vc.containerController hiddenChildViewController];
        }];
        
        [vc.containerController showChildViewController:secondChild];
    }];
    
    [self.containerController showChildViewController:firstChild];
}


- (void)changeRootInteractive
{
    UIViewController *vc = [ViewCtrlGenerate generateInteractiveVCWithConfig:^(UIViewController *vc) {
        vc.view.backgroundColor = [UIColor greenColor];
    } backBlock:^(UIViewController *vc){
        [vc.containerController changeRootViewController:self finishCallBack:nil
                                            useAnimation:YES
                                          customAnimator:[TransitionAnimateL2R new]
                                           isInteractive:YES];
    } tip:@"滑动切换到原始root"];
    
    [self.containerController changeRootViewController:vc useAnimation:false];
}


- (void)showChildInteractive
{
    UIViewController *vc = [ViewCtrlGenerate generateInteractiveVCWithConfig:^(UIViewController *vc) {
        vc.view.backgroundColor = [UIColor greenColor];

    } backBlock:^(UIViewController *vc){
        [vc.containerController hiddenChildViewControllerWithFinishCallBack:nil
                                            useAnimation:YES
                                          customAnimator:[TransitionAnimateL2R new]
                                           isInteractive:YES];
    } tip:@"滑动切换到原始root"];
    
    [self.containerController showChildViewController:vc useAnimation:false];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _demoNameArray.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellID";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [_demoNameArray objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _callMethodArray.count) {
        SEL               selector    = NSSelectorFromString(_callMethodArray[indexPath.row]);
        NSMethodSignature *sig        = [self methodSignatureForSelector:selector];
        NSInvocation      *invocation = [NSInvocation invocationWithMethodSignature:sig];

        invocation.target   = self;
        invocation.selector = selector;

        [invocation invoke];
    }
}


@end
