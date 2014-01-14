//
//  MainViewController.m
//  TB_CustomTransitionIOS7
//
//  Created by Yari Dareglia on 9/29/13.
//  Copyright (c) 2013 Bitwaker. All rights reserved.
//

#import "MainViewController.h"
#import "ModalViewController.h"
#import "TransitionManager.h"

@import MapKit;

@interface MainViewController ()
@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, strong) TransitionManager *transitionManager;
@end

@implementation MainViewController



#pragma mark - Initialization / Config 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)setup{
    
    //TransitionManager class implements the UIViewControllerAnimatedTransitioning protocol
    self.transitionManager = [[TransitionManager alloc]init];
    self.transitionManager.mainController = self; // Set the reference to the main controller
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setup];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end