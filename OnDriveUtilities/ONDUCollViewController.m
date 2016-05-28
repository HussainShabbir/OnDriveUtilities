//
//  ONDUCollectionViewController.m
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/15/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import "ONDUCollViewController.h"
#import "ONDUCollViewCell.h"
#import "ONDUTransitViewcontroller.h"
#import "WFActivitySpecificItemProvider.h"

typedef enum : NSInteger {
    kCarParking = 0,
    kPArkingTimer,
    kTransportation
} OnDriveEnumTypes;

@interface ONDUCollViewController ()
@property (nonatomic,strong) NSArray * utilities;
@property (nonatomic,strong) NSArray * utilitiesImages;
@property (nonatomic,strong) NSString * selectedCellValue;
@end

@implementation ONDUCollViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = NO;
    self.utilities = @[@"Car Parking",@"Parking Meter",@"Gas Stations",@"Hospitals",@"Restaurants",@"Hotels"];
    self.utilitiesImages = @[[UIImage imageNamed:@"Motor"],[UIImage imageNamed:@"Timer"],[UIImage imageNamed:@"GasFuel"],[UIImage imageNamed:@"Hospital"],[UIImage imageNamed:@"Restaurant"],[UIImage imageNamed:@"Hotel"]];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barTintColor = [UIColor colorWithRed:(91/255.0f) green:(160/255.0f) blue:(36/255.0f) alpha:1.0];
    UIBarButtonItem *rate = [[UIBarButtonItem alloc]initWithTitle:@"Rate us" style:UIBarButtonItemStylePlain target:self action:@selector(doRateUs:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *feedBack = [[UIBarButtonItem alloc]initWithTitle:@"Feedback" style:UIBarButtonItemStylePlain target:self action:@selector(doFeedBack:)];
    UIBarButtonItem *help = [[UIBarButtonItem alloc]initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(showHelp:)];
    
    [self setToolbarItems:@[rate,flexibleSpace,feedBack,flexibleSpace,help]];
    for (UIBarButtonItem *item in self.toolbarItems){
        item.tintColor = [UIColor blackColor];
    }
    
}
-(void)doRateUs:(id)sender
{
    NSString *itunesAppUrl = @"itms-apps://itunes.apple.com/us/app/drive-utilities/id1116906010?mt=8";
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:itunesAppUrl]];
}

-(void)doFeedBack:(id)sender{
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc]init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"OnDrive Utilities"];
        [mail setToRecipients:@[@"hshabbirhussain53@gmail.com"]];
        [self presentViewController:mail animated:YES completion:nil];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultSent:
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case MFMailComposeResultCancelled:
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case MFMailComposeResultSaved:
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

-(void)showHelp:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"OnDrive Utilities" message:@"Car Parking\n It is use for tracking Parking information. In this you can add your parking location, so that it will be easy to find out your car\n\nParking Timer\nIt is use to set your parking timer, if there is any time limit to park your car then after setting this timer you will get the notifications once time will finished. This will help to avoid extra charge.\n\nGas Stations\nIt is use to find out the nearest gas stations. It will display the annotation on your map\n\nHospitals\nIt is use to find out the nearest Hospitals. It will display the annotation on your map\n\nRestaurants\nIt is use to find out the nearest Restaurants. It will display the annotation on your map\n\nHotels\nIt is use to find out the nearest Hotels. It will display the annotation on your map." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    alertController.view.tintColor = [UIColor blackColor];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(IBAction)doShare:(id)sender
{
    NSString *texttoshare = @"Hey! I just downloaded the app, Its amazing app while driving. It tracks the Car Parking info, and other important things. Would you like to download OnDrive Utitlities. Here is the link https://itunes.apple.com/us/app/drive-utilities/id1116906010";
    UIActivityViewController *activityVc = nil;
    WFActivitySpecificItemProvider *itemProvider1 = [[WFActivitySpecificItemProvider alloc]initWithPlaceholderItem:@{@"WFActivitySpecificItemProviderTypeDefault" : texttoshare, UIActivityTypePostToFacebook : texttoshare, UIActivityTypePostToTwitter : texttoshare, UIActivityTypeMessage : texttoshare}];
    
    WFActivitySpecificItemProvider *itemProvider2 = [[WFActivitySpecificItemProvider alloc]initWithPlaceholderItem:nil block:^id(NSString *activityType) {
        if ([activityType isEqualToString:@"net.whatsapp.WhatsApp.ShareExtension"]){
            [activityVc dismissViewControllerAnimated:NO completion:nil];
            NSString *string = [NSString stringWithFormat:@"whatsapp://send?text=%@",texttoshare];
            NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [[UIApplication sharedApplication] openURL: url];
        }
        return texttoshare;
    }];
    
    activityVc = [[UIActivityViewController alloc]initWithActivityItems:@[itemProvider1,itemProvider2] applicationActivities:nil];
    
    activityVc.excludedActivityTypes = @[UIActivityTypeAddToReadingList,UIActivityTypeCopyToPasteboard,UIActivityTypePostToFlickr,UIActivityTypePostToWeibo,UIActivityTypeAssignToContact,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypeAirDrop];
    activityVc.view.tintColor = [UIColor blackColor];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [self presentViewController:activityVc animated:YES completion:nil];
    }
    else{
        UIPopoverController *popOverVc = [[UIPopoverController alloc]initWithContentViewController:activityVc];
        UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;
        UIView *view = [item valueForKey:@"view"];
        [popOverVc presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"TransPortIdentifier"]){
        ONDUTransitViewcontroller *vwController = segue.destinationViewController;
        vwController.selectedTransit = self.selectedCellValue;
    }
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ONDUCollViewCell *cell = (ONDUCollViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.lbl.text = self.utilities[indexPath.row];
    cell.imageVw.image = self.utilitiesImages[indexPath.row];
    cell.layer.borderWidth=1.0f;
    cell.layer.cornerRadius = 5.0f;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
//    cell.layer.borderColor=[UIColor colorWithRed:(91/255.0f) green:(160/255.0f) blue:(36/255.0f) alpha:1.0f].CGColor;
    // Configure the cell
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier;
    switch (indexPath.row) {
        case kCarParking:
            identifier = @"CarParkingIdentifier";
            break;
        case kPArkingTimer:
            identifier = @"ParkingTimerIdentifier";
            break;
        default:
            identifier = @"TransPortIdentifier";
            ONDUCollViewCell *selectedCell = (ONDUCollViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
            self.selectedCellValue = selectedCell.lbl.text;
            break;
    }
    [self performSegueWithIdentifier:identifier sender:self];
}

@end
