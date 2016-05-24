//
//  WFActivitySpecificItemProvider.h
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/23/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import <UIKit/UIKit.h>


//NSString *const WFActivitySpecificItemProviderTypeDefault;

typedef id (^WFActivitySpecificItemProviderItemBlock)(NSString *activityType);

@interface WFActivitySpecificItemProvider : UIActivityItemProvider

@property (nonatomic, copy) NSDictionary *items;

@property (nonatomic, copy) WFActivitySpecificItemProviderItemBlock itemBlock;

- (id)initWithPlaceholderItem:(id)placeholderItem
                        items:(NSDictionary *)items
                        block:(WFActivitySpecificItemProviderItemBlock)itemBlock;

- (id)initWithPlaceholderItem:(id)placeholderItem
                        items:(NSDictionary *)items;

- (id)initWithPlaceholderItem:(id)placeholderItem
                        block:(WFActivitySpecificItemProviderItemBlock)itemBlock;

- (id)initWithPlaceholderItem:(id)placeholderItem;

@end
