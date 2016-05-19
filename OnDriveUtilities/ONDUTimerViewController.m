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

@interface ONDUTimerViewController ()

@end

@implementation ONDUTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController changeBackButtonItem:nil withCurrentObject:self];
    self.navigationItem.title = @"Timer";
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ONDUPkTableViewCell *timerCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    switch (indexPath.row) {
        case 0:
            break;
            
        case 1:
            timerCell.timerView.hidden = NO;
            cell.textLabel.text = @"Start";
            break;
            
        case 2:
            timerCell.timerView.hidden = YES;
            break;
            
        default:
            break;
    }
}



@end
