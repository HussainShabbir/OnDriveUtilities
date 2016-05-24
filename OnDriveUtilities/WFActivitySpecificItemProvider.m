//
//  WFActivitySpecificItemProvider.m
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/23/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import "WFActivitySpecificItemProvider.h"

//NSString *const WFActivitySpecificItemProviderTypeDefault =
//@"WFActivitySpecificItemProviderTypeDefault";

@implementation WFActivitySpecificItemProvider
- (id)initWithPlaceholderItem:(id)placeholderItem
                        items:(NSDictionary *)items
                        block:(WFActivitySpecificItemProviderItemBlock)itemBlock
{
    self = [super initWithPlaceholderItem:placeholderItem];
    
    if (self) {
        
        _items = [items copy];
        _itemBlock = [itemBlock copy];
    }
    
    return self;
}

- (id)initWithPlaceholderItem:(id)placeholderItem
                        items:(NSDictionary *)items
{
    return [self initWithPlaceholderItem:placeholderItem
                                   items:items
                                   block:nil];
}

- (id)initWithPlaceholderItem:(id)placeholderItem
                        block:(WFActivitySpecificItemProviderItemBlock)itemBlock
{
    return [self initWithPlaceholderItem:placeholderItem
                                   items:nil
                                   block:itemBlock];
}

- (id)initWithPlaceholderItem:(id)placeholderItem
{
    return [self initWithPlaceholderItem:placeholderItem
                                   items:nil
                                   block:nil];
}

- (id)item
{
    id item = nil;
    
    // check items dictionary first
    item = [self items][[self activityType]];
    
    if (item)
        return item;
    
    // try calling block
    if ([self itemBlock])
        item = [self itemBlock]([self activityType]);
    
    if (item)
        return item;
    
    // check items dictionary for default
    item = [self items][@"WFActivitySpecificItemProviderTypeDefault"];
    
    if (item)
        return item;
    
    // return placeholder as last resort
    return [self placeholderItem];
}

@end
