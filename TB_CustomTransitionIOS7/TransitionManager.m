//
//  TransitionManager.m
//  TB_CustomTransitionIOS7
//
//  Created by Yari Dareglia on 10/22/13.
//  Copyright (c) 2013 Bitwaker. All rights reserved.
//

#import "TransitionManager.h"
#import "ModalViewController.h"

@implementation TransitionManager

- (void)setMainController:(MainViewController *)mainController{
    
    _mainController = mainController;
    UIScreenEdgePanGestureRecognizer *panGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(gestureHandler:)];
    panGesture.edges = UIRectEdgeLeft;
    
    [[self.mainController.view window] addGestureRecognizer:panGesture];
    
}




#pragma mark - UIViewControllerAnimatedTransitioning -

- (void)gestureHandler:(UIScreenEdgePanGestureRecognizer*)recognizer{
    
    
    
    // 0. Get Gesture information
    
    // Location reference
    CGPoint location = [recognizer locationInView:[self.mainController.view window]];
    
    // Velocity reference
    CGPoint velocity = [recognizer velocityInView:[self.mainController.view window]];

    
    
    // 1. Gesture is started, show the modal controller
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //[self createFinger];
        
        if (location.x < CGRectGetMidX(recognizer.view.bounds)) {
            
            // Check that the modal controller view isn't currently shown
            
            if(!self.modalController){
                
                // Instantiate the modal controller
                self.modalController = [[ModalViewController alloc]init];
                self.modalController.transitioningDelegate = self;
                self.modalController.modalPresentationStyle = UIModalPresentationCustom;
                
                // Here we could set the mainController as delegate of the modal controller to get/set useful information
                // Example: self.modalController.delegate = self.mainController;
                
                // Present the controller
                [self.mainController presentViewController:self.modalController animated:YES completion:nil];
            }
        }
        
        else {
            // With this implementation we want to dismiss the controller without the interactive transition, anyway, this would be a good place
            // to add code to dismiss it using an interactive transition
            // [self.modalController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    
    
    // 2. Update the animation state
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        self.finger.center = location;
        
        // Get the ratio of the animation depending on the touch location.
        // When location is at the left of the screen the animation is at its initial phase.
        // Moving to the right, the animation proceed, while moving to the right it is reverse played
        CGFloat animationRatio = location.x / CGRectGetWidth([self.mainController.view window].bounds);
        [self updateInteractiveTransition:animationRatio];
    }
    
    
    
    // 3. Complete or cancel the animation when gesture ends
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //[self.finger removeFromSuperview];
        
        if (self.transitionTo == MODAL) {
            
            if (velocity.x > 0) {
                [self finishInteractiveTransition];
            }
            
            else {
                [self cancelInteractiveTransition];
            }
            
            self.modalController = nil;
        }
        
    }
}

//Define the transition duration
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}


//Define the transition
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    //STEP 1
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect sourceRect = [transitionContext initialFrameForViewController:fromVC];
    
    /*STEP 2:   Draw different transitions depending on the view to show
                for sake of clarity this code is divided in two different blocks
     */

    //STEP 2A: From the First View(INITIAL) -> to the Second View(MODAL)
    if(self.transitionTo == MODAL){

        //1.Settings for the fromVC ............................
        CGAffineTransform rotation;
        rotation = CGAffineTransformMakeRotation(M_PI);
        fromVC.view.frame = sourceRect;
        fromVC.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
        fromVC.view.layer.position = CGPointMake(160.0, 0);
        
        //2.Insert the toVC view...........................
        UIView *container = [transitionContext containerView];
        [container insertSubview:toVC.view belowSubview:fromVC.view];
        CGPoint final_toVC_Center = toVC.view.center;
        
        [container addSubview:fromVC.view];
        
        toVC.view.center = CGPointMake(-sourceRect.size.width, sourceRect.size.height);
        toVC.view.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        //3.Perform the animation...............................
        [UIView animateWithDuration:1.0
                         animations:^{
                             
                             //Setup the final parameters of the 2 views
                             //the animation interpolates from the current parameters
                             //to the next values.
                             fromVC.view.transform = rotation;
                             toVC.view.center = final_toVC_Center;
                             toVC.view.transform = CGAffineTransformMakeRotation(0);
                         } completion:^(BOOL finished) {
                             
                             //When the animation is completed call completeTransition
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             
                         }];
    }
    
    //STEP 2B: From the Second view(MODAL) -> to the First View(INITIAL)
    else{
        
        //Settings for the fromVC ............................
        CGAffineTransform rotation;
        rotation = CGAffineTransformMakeRotation(M_PI);
        UIView *container = [transitionContext containerView];
        fromVC.view.frame = sourceRect;
        fromVC.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
        fromVC.view.layer.position = CGPointMake(160.0, 0);
        
        //Insert the toVC view view...........................
        [container insertSubview:toVC.view belowSubview:fromVC.view];
        toVC.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
        toVC.view.layer.position = CGPointMake(160.0, 0);
        toVC.view.transform = CGAffineTransformMakeRotation(-M_PI);
        
        //Perform the animation...............................
        [UIView animateWithDuration:1.0
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:6.0
                            options:UIViewAnimationOptionCurveEaseIn
         
                         animations:^{
                             
                             //Setup the final parameters of the 2 views
                             //the animation interpolates from the current parameters
                             //to the next values.
                             fromVC.view.center = CGPointMake(fromVC.view.center.x - 320, fromVC.view.center.y);
                             toVC.view.transform = CGAffineTransformMakeRotation(-0);
                             
                         } completion:^(BOOL finished) {
                             
                             //When the animation is completed call completeTransition
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             
                             // release the modal controller
                             self.modalController = nil;
                             
                         }];
    }

    
}





#pragma mark - UIVieControllerTransitioningDelegate -

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source{
    self.transitionTo = MODAL;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transitionTo = INITIAL;
    return self;
}


// Implement these 2 methods to perform interactive transitions
- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return nil; // We don't want to use interactive transition to dismiss the modal view, we are just going to use the standard animator.
}



/* I use this code to show the touch location while recording the video from my iPhone in Airplay
 - (void)createFinger{
 
 self.finger = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
 
 self.finger.layer.cornerRadius = 25;
 self.finger.layer.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4].CGColor;
 self.finger.layer.borderColor = [UIColor whiteColor].CGColor;
 self.finger.layer.borderWidth = 2.0;
 
 [[self.mainController.view window]addSubview:self.finger];
 
 }
 */
@end
