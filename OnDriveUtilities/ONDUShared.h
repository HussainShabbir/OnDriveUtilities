//
//  ONDUShared.h
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/22/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONDUShared : NSObject
@property (nonatomic,strong) NSUserDefaults *userDef;
+ (id)sharedManager;
@end
