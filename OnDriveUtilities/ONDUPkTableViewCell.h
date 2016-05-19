//
//  ONDUPkTableViewCell.h
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/17/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONDUPkTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIDatePicker *datePicker;

@property (nonatomic,weak) IBOutlet UIView *timerView;

@property (nonatomic,weak) IBOutlet UILabel *timerlabel;
@end
