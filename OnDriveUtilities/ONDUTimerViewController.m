//
//  ONDUTimerViewController.m
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/17/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import "ONDUTimerViewController.h"
#import "ONDUPkTableViewCell.h"
#import "UINavigationController+LeftBtnItem.h"
#import "ONDUShared.h"

@interface ONDUTimerViewController ()
@property (nonatomic,strong)dispatch_source_t timer;
@end

@implementation ONDUTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController changeBackButtonItem:nil withCurrentObject:self];
    self.navigationItem.title = @"Timer";
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 44.0f;
    if (!indexPath.row){
        rowHeight = 212.0f;
    }
    return rowHeight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    ONDUPkTableViewCell *timerCell = (ONDUPkTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CellDatePicker"];
    switch (indexPath.row) {
        case 0:
            timerCell.timerView.hidden = YES;
            timerCell.datePicker.date = [NSDate date];
            cell = timerCell;
            break;
            
        case 1:
            cell.textLabel.text = @"Start";
            break;
            
        case 2:
            cell.textLabel.text = @"Stop";
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ONDUPkTableViewCell *timerCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    switch (indexPath.row) {
        case 0:
            break;
            
        case 1:
        {
            timerCell.timerView.hidden = NO;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            NSTimeInterval duration = timerCell.datePicker.countDownDuration;
            [self scheduleReminder:duration];
            double secondsToFire = 1.000f;
            __block NSInteger hours = (NSInteger)(duration/3600.0f);
            __block NSInteger minutes = ((NSInteger)duration - (hours * 3600))/60 -1;
            __block NSInteger second = 59;
            __block NSString *timerLabel = [NSString stringWithFormat:@"%ld : %ld : %ld",(long)hours,(long)minutes,(long)second];
            timerCell.timerlabel.text = timerLabel;
            self.timer = CreateDispatchTimer(secondsToFire, queue, ^{
                // Do something
                --second;
                if (second == 0 && (minutes >= 1 || hours >= 1)){
                    second = 59;
                    --minutes;
                    if (minutes == 0 && hours >= 1){
                        minutes = 59;
                        --hours;
                    }
                }
                if (!hours && !minutes && !second)
                {
                    if (_timer)
                    {
                        dispatch_source_cancel(_timer);
                        [[UIApplication sharedApplication]cancelAllLocalNotifications];
                    }
                }
                timerLabel = [NSString stringWithFormat:@"%ld : %ld : %ld",(long)hours,(long)minutes,(long)second];
                dispatch_async(dispatch_get_main_queue(),^{
                    timerCell.timerlabel.text = timerLabel;
                    if (!hours && !minutes && !second){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Parking Reminder" message:@"Time is Over" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alertController addAction:alertAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                });
            });
            break;
        }
        case 2:
            timerCell.timerView.hidden = YES;
            if (_timer) {
                dispatch_source_cancel(_timer);
                [[UIApplication sharedApplication]cancelAllLocalNotifications];
            }
            break;
            
        default:
            break;
    }
}

dispatch_source_t CreateDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

-(void)scheduleReminder:(NSTimeInterval)duration{
    NSDateFormatter *dat= [[NSDateFormatter alloc]init];
    [dat setLocale:[NSLocale currentLocale]];
    [dat setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *reminderDate=[NSDate date];
    reminderDate =[reminderDate dateByAddingTimeInterval:duration];
    UILocalNotification  *missingDreamNotify=[[UILocalNotification alloc]init];
    missingDreamNotify.fireDate=reminderDate;
    missingDreamNotify.timeZone = [NSTimeZone defaultTimeZone];
    missingDreamNotify.alertBody = @"Parking Reminder";
    missingDreamNotify.alertAction = @"Time is Over";
    missingDreamNotify.soundName = UILocalNotificationDefaultSoundName;
    missingDreamNotify.repeatInterval = 0;
    [[UIApplication sharedApplication] scheduleLocalNotification:missingDreamNotify];
}

@end
