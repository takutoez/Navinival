//
//  NYTransitionManager.m
//  NYBackTransitionSample
//
//  Created by naoto yamaguchi on 2014/03/23.
//  Copyright (c) 2014年 naoto yamaguchi. All rights reserved.
//
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 naoto yamaguchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "NYTransitionManager.h"

/*
 *
 * define animation duration
 * default timeInterval 0.40f
 *
 */

////////////////////////////////////////////////////////////////////////////////////////////////////
// Present Transition Duration
////////////////////////////////////////////////////////////////////////////////////////////////////
static const NSTimeInterval kPresentBackTransitionDuration = 0.35f;

////////////////////////////////////////////////////////////////////////////////////////////////////
// Dismiss Transition Duration
////////////////////////////////////////////////////////////////////////////////////////////////////
static const NSTimeInterval kDismissBackTransitionDuration = 0.35f;


/**
 *
 * dimmingView tag
 *
 */
static const NSUInteger kDimmingViewTag = 100000;


@interface NYTransitionManager ()

/*
 *
 * BOOL
 * presenting flag
 *
 */
@property (nonatomic) BOOL flag;

@end


@implementation NYTransitionManager

# pragma mark - Initialize

- (id)initWithPresenting:(BOOL)flag
{
    self = [super init];
    if (self) {
        _flag = flag;
    }
    return self;
}

# pragma mark -
# pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (_flag) {
        return kPresentBackTransitionDuration;
    } else {
        return kDismissBackTransitionDuration;
    }
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (_flag) {
        [self presentTransitionWithTransitionContext:transitionContext];
    } else {
        [self dismissTransitionWithTransitionContext:transitionContext];
    }
}

# pragma mark - Transition method

- (void)presentTransitionWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // get UIView and UIViewController
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor blackColor];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *dimmingView = [self dimmingViewWithFrame:containerView.frame];
    [fromViewController.view addSubview:dimmingView];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // prepare
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    [containerView insertSubview:toViewController.view
                    aboveSubview:fromViewController.view];
    toViewController.view.frame = [self invisibleFrame:containerView.frame];
    
    CATransform3D transform = [self backAnimation];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // animation
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    [UIView animateWithDuration:kPresentBackTransitionDuration * 0.875f
                          delay:kPresentBackTransitionDuration * 0.125f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         fromViewController.view.layer.transform = transform;
                         dimmingView.alpha = 0.7f;
                     } completion:^(BOOL finished) {
                     }];
    
    [UIView animateWithDuration:kPresentBackTransitionDuration * 0.75f
                          delay:kPresentBackTransitionDuration * 0.25f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toViewController.view.frame = containerView.frame;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)dismissTransitionWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // get UIView and UIViewController
    ////////////////////////////////////////////////////////////////////////////////////////////////

    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor blackColor];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *dimmingView = [self searchDimmingViewWithViewController:toViewController];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // prepare
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    [containerView insertSubview:toViewController.view
                    belowSubview:fromViewController.view];
    
    toViewController.view.frame = containerView.frame;
    toViewController.view.layer.transform = [self forwardAnimation];
    
    CGRect invisibleFrame = [self invisibleFrame:containerView.frame];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // animation
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    [UIView animateWithDuration:kDismissBackTransitionDuration * 0.875f
                          delay:kDismissBackTransitionDuration * 0.125f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         fromViewController.view.frame = invisibleFrame;
                     } completion:^(BOOL finished) {
                     }];
    
    [UIView animateWithDuration:kDismissBackTransitionDuration * 0.75f
                          delay:kDismissBackTransitionDuration * 0.25f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         toViewController.view.layer.transform = CATransform3DIdentity;
                         dimmingView.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [dimmingView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
    
}

# pragma mark -
# pragma mark - DimmingView

- (UIView *)dimmingViewWithFrame:(CGRect)frame
{
    UIView *dimmingView = [[UIView alloc] initWithFrame:frame];
    dimmingView.backgroundColor = [UIColor blackColor];
    dimmingView.alpha = 0.0f;
    dimmingView.tag = kDimmingViewTag;
    return dimmingView;
}

- (UIView *)searchDimmingViewWithViewController:(UIViewController *)viewController
{
    UIView *dimmingView = nil;
    for (UIView *view in viewController.view.subviews) {
        if (view.tag == kDimmingViewTag) {
            dimmingView = view;
        }
    }
    return dimmingView;
}

# pragma mark - Helper method

- (BOOL)isUINavigationController:(UIViewController *)viewController
{
    return [viewController isKindOfClass:[UINavigationController class]];
}

- (CGRect)invisibleFrame:(CGRect)frame
{
    CGRect invisibleFrame = frame;
    invisibleFrame.origin.y = frame.size.height;
    return invisibleFrame;
}

- (void)adjustNavigationBarHeightWithViewController:(UIViewController *)viewController
{
    if ([self isUINavigationController:viewController]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        UINavigationBar *navBar = nav.navigationBar;
        CGRect navBarFrame = navBar.frame;
        navBar.frame = CGRectMake(navBarFrame.origin.x,
                                  navBarFrame.origin.y,
                                  navBarFrame.size.width,
                                  navBarFrame.size.height + 20.0f);
    }
}

# pragma mark - CoreAnimation 3D

- (CATransform3D)backAnimation
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0/-500.0;
    transform = CATransform3DScale(transform, 0.90f, 0.90f, 1.0f);
    return transform;
}

- (CATransform3D)forwardAnimation
{
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DScale(transform, 0.90f, 0.90f, 1.0f);
    return transform;
}

@end
