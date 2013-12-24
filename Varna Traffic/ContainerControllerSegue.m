//
//  ContainerControllerSegue.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/1/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import "ContainerControllerSegue.h"
#import "StationsViewController.h"

@implementation ContainerControllerSegue

- (void)perform {
    StationsViewController *containerViewController = (StationsViewController *)self.sourceViewController;

    [containerViewController switchToContentViewController:self.destinationViewController];
}

@end
