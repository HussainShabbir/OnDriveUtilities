//
//  ONDUCarParkVwController.m
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/15/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import "ONDUCarParkVwController.h"
#import "UINavigationController+LeftBtnItem.h"

@interface ONDUCarParkVwController ()

@end

@implementation ONDUCarParkVwController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;
    [self.navigationController changeBackButtonItem:@"Car Parking"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
