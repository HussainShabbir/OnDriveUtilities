//
//  UINavigationController+LeftBtnItem.h
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/15/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (LeftBtnItem)

-(void) changeBackButtonItem:(NSString*)title withCurrentObject:(UIViewController*)currentVwController;

@end
