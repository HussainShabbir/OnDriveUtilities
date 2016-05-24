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
    NSString *itunesAppUrl = @"itms-apps://itunes.apple.com/app/id1105328604";
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
    
}

-(IBAction)doShare:(id)sender
{
    NSString *texttoshare = @"Hey! I just downloaded the app, Its amazing app while driving. It tracks the Car Parking info, and other important things. Would you like to download OnDrive Utitlities.";
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
    
    [self presentViewController:activityVc animated:YES completion:nil];
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
