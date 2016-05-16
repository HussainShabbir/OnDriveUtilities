//
//  UINavigationController+LeftBtnItem.m
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/15/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import "UINavigationController+LeftBtnItem.h"

@implementation UINavigationController (LeftBtnItem)

-(void) changeBackButtonItem:(NSString*)title
{
    NSArray *viewControllerArr = [self viewControllers];
    // get index of the previous ViewContoller
    UIViewController *previous;
    if (viewControllerArr.count) {
        previous = [viewControllerArr objectAtIndex:0];
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
