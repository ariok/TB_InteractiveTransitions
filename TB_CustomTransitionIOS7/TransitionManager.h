//
//  TransitionManager.h
//  TB_CustomTransitionIOS7
//
//  Created by Yari Dareglia on 10/22/13.
//  Copyright (c) 2013 Bitwaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModalViewController.h"
#import "MainViewController.h"  

//Define a custom type for the transition mode
//It simply says which is the current showed view...
typedef NS_ENUM(NSUInteger, TransitionStep){
    INITIAL = 0,
    MODAL
};
                              // the UIPercentDrivenInteractiveTransition implements the UIViewControllerInteractiveTransitioning protocol
@interface TransitionManager : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) TransitionStep transitionTo;

@property (nonatomic, weak) MainViewController *mainController;   //keep a reference to the main and the modal controller
@property (nonatomic, strong) ModalViewController *modalController;

@property (nonatomic, strong)UIView *finger;
@end
