//
//  UIViewController+NYBackTransition.m
//  NYBackTransitionSample
//
//  Created by naoto yamaguchi on 2014/03/21.
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

#import "UIViewController+NYBackTransition.h"

@implementation UIViewController (NYBackTransition)

# pragma mark - Extarnal API

- (void)presentViewControllerWithBackTransition:(UIViewController *)viewControllerToPresent
                                     completion:(void (^)(void))completion
{
    viewControllerToPresent.transitioningDelegate = self;
    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
}

- (void)dismissViewControllerWithBackTransitionCompletion:(void (^)(void))completion
{
    [self dismissViewControllerAnimated:YES completion:completion];
}

# pragma mark -
# pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [[NYTransitionManager alloc] initWithPresenting:YES];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[NYTransitionManager alloc] initWithPresenting:NO];
}

@end
