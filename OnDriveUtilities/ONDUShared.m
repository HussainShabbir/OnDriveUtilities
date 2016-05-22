//
//  ONDUShared.m
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/22/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import "ONDUShared.h"

@implementation ONDUShared

+ (id)sharedManager{
    static ONDUShared *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

@end
