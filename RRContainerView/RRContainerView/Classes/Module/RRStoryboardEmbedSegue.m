//
//  RRStoryboardEmbedSegue.m
//  RRContainerView
//
//  Copyright (c) 2013 Rolandas Razma <rolandas@razma.lt>
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "RRStoryboardEmbedSegue.h"


@implementation RRStoryboardEmbedSegue {
    __weak UIViewController *_viewController;
    __weak UIView           *_containerView;
    __weak UIViewController *_destinationViewController;
    NSString                *_destinationViewControllerIdentifier;
    NSString                *_identifier;
}


#pragma mark -
#pragma mark NSObject


+ (void)load {
    
    // here I'm checking for NSLayoutConstraint because UIStoryboardEmbedSegueTemplate is private in iOS6
    // keep in mind that I'm NOT using any private classes here as UIStoryboardEmbedSegueTemplate doesn't exist in iOS5
    if( !NSClassFromString(@"NSLayoutConstraint") ){
        [NSKeyedUnarchiver setClass:[RRStoryboardEmbedSegue class] forClassName:@"UIStoryboardEmbedSegueTemplate"];
    }

}


#pragma mark -
#pragma mark UIStoryboardSegue


- (NSString *)identifier {
    return _identifier;
}


- (UIViewController *)sourceViewController {
    return _viewController;
}


- (UIViewController *)destinationViewController {
    return _destinationViewController;
}


- (void)perform {

    BOOL newViewController = (_destinationViewController == nil);
    
    // instantiate view controller
    if( newViewController ){
        _destinationViewController = [_viewController.storyboard instantiateViewControllerWithIdentifier:_destinationViewControllerIdentifier];
        
        // Notify about segue to be performed
        [_viewController prepareForSegue:self sender:_viewController];
        
        // Add child view controller
        [_viewController addChildViewController:_destinationViewController];
    }
    
    [_destinationViewController viewWillAppear:NO];
    [_destinationViewController.view setFrame:_containerView.bounds];
    [_destinationViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_containerView addSubview:_destinationViewController.view];
    [_destinationViewController viewDidAppear:NO];
    
    if( newViewController ){
        [_destinationViewController didMoveToParentViewController:_viewController];
    }

}


#pragma mark -
#pragma mark RRStoryboardEmbedSegue


- (id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super init]) ){
        _destinationViewControllerIdentifier= [aDecoder decodeObjectForKey:@"UIDestinationViewControllerIdentifier"];
        _identifier                         = [aDecoder decodeObjectForKey:@"UIIdentifier"];
    }
    return self;
}


- (void)setContainerView:(UIView *)containerView {
    _containerView = containerView;

    // in iOS6 this is performed when view is loading, but I think we can perform it here...
    [self perform];
}


@end
