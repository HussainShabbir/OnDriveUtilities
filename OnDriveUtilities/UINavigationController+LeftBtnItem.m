//
//  UINavigationController+LeftBtnItem.m
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/15/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import "UINavigationController+LeftBtnItem.h"

@implementation UINavigationController (LeftBtnItem)

-(void) changeBackButtonItem:(NSString*)title withCurrentObject:(UIViewController*)currentVwController
{
    NSArray *viewControllerArr = [self viewControllers];
    // get index of the previous ViewContoller
    NSUInteger prevIndex = [viewControllerArr indexOfObject:currentVwController];
    NSInteger currenIndex = prevIndex - 1;
    UIViewController *previous;
    if (currenIndex >= 0) {
        previous = [viewControllerArr objectAtIndex:currenIndex];
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]
                                    initWithTitle:@""
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:nil];
        previous.navigationItem.backBarButtonItem = backBtn;
        self.navigationBar.tintColor = [UIColor blackColor];
    }
}

@end
