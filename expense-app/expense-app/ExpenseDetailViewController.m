//
//  ExpenseDetailViewController.m
//  expense-app
//
//  Created by Matt Schmulen on 9/28/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "ExpenseDetailViewController.h"

#import "utility.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ExpenseDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAttendee;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewReceipt;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *receiptImageCameraButton;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAmount;
@property (weak, nonatomic) IBOutlet UILabel *labelAttendeeOne;
@property (weak, nonatomic) IBOutlet UILabel *labelAttendeeTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentTime;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentLocation;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;



@end

@implementation ExpenseDetailViewController

UISwitch *editSwitch;
UIPopoverController *popover;

@synthesize imagePicker, usedCamera, model;

- (IBAction)actionPhotoPick:(id)sender {
    
    self.usedCamera = NO;
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setAllowsEditing:YES];
    [imagePicker setWantsFullScreenLayout:YES];
    [imagePicker setHidesBottomBarWhenPushed:YES];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)actionCamera:(id)sender {
    
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        if (popover) return;
        
        // Create and initialize the picker
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = editSwitch.isOn;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
        //MAS TODO  !!!
        //[self presentViewController:picker];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self saveAndClose];
    
    
    if (buttonIndex == 0){
        //cancel clicked ...do your action
    }else{
        
    }
}


- (IBAction)actionSubmitToConcur:(id)sender {
    
    NSLog(@"actionSubmitToConcur");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Submit to Concur"
                                                    message:@"Expense report has been submitted to Concur"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)actionUpdate:(id)sender {
    
    NSLog(@"actionUpdate");
    
    
    if ( false )
    {
        [ AppDelegate identifyFacesFromPicture:@""];
    }
    else
    {
        //[NSThread sleepForTimeInterval:10];
        
        
        /*
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [indicator startAnimating];
        [self addChildViewController:indicator];
        //[alert addSubview:indicator];
        //[indicator release];
        */
        
        [[self labelAttendeeOne] setText:@"Lorie Thomas ( 0.606 )"];
        [[self labelAttendeeTwo] setText:@"Neil Charney ( 0.616 )"];
    }
    
    // DRAW SQUARE AROUND FACE ....
}


- (IBAction)actionupdateReceiptImage:(id)sender {
    
    NSLog(@"actionupdateReceiptImage");
    //Update the Recipt Image ...
    
    //if modal
}




- (IBAction)actionUpdateAtendeeImage:(id)sender {
    
    NSLog(@"actionUpdateAtendeeImage");
    
    //self.usedCamera = NO;
    self.imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setAllowsEditing:YES];
    [imagePicker setWantsFullScreenLayout:YES];
    [imagePicker setHidesBottomBarWhenPushed:YES];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (IBAction)actionSave:(id)sender {
    
    [self saveAndClose];
    
}

- (void) saveAndClose {
    
    NSLog(@"actionSave");
    
    model.name = self.textFieldName.text;
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    model.amount = [f numberFromString:self.textFieldAmount.text];
    model.location = self.labelCurrentLocation.text;
    model.time = self.labelCurrentTime.text;
    
    //Close the screen
    if([self.presentingViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        [self.presentingViewController dismissViewControllerAnimated:(YES) completion:nil];
    else if([self.presentingViewController respondsToSelector:@selector(dismissModalViewControllerAnimated:)])
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    else
        NSLog(@"Oooops, what system is this ?!!! - should never see this !");
    
}



#pragma mark - textfield delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Utility
- (void) performDismiss
{
    if (IS_IPHONE)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [popover dismissPopoverAnimated:YES];
}

- (void) presentViewController:(UIViewController *)viewControllerToPresent
{
    if (IS_IPHONE)
	{
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
	}
	else
	{
        popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerToPresent];
        popover.delegate = self;
        [popover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

// Popover was dismissed
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController
{
    popover = nil;
}

- (void) loadImageFromAssetURL: (NSURL *) assetURL into: (UIImage **) image
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset)
    {
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        CGImageRef cgImage = [assetRepresentation CGImageWithOptions:nil];
        CFRetain(cgImage); // Thanks Oliver Drobnik
        if (image) *image = [UIImage imageWithCGImage:cgImage];
        CFRelease(cgImage);
    };
    
    ALAssetsLibraryAccessFailureBlock failure = ^(NSError *__strong error)
    {
        NSLog(@"Error retrieving asset from url: %@", error.localizedFailureReason);
    };
    
    [library assetForURL:assetURL resultBlock:resultsBlock failureBlock:failure];
}

// Finished saving
- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *)error contextInfo:(void *)contextInfo;
{
    // Handle the end of the image write process
    if (!error)
        NSLog(@"Image written to photo album");
    else
        NSLog(@"Error writing to photo album: %@", error.localizedFailureReason);
}

// Update image and for iPhone, dismiss the controller
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Use the edited image if available
    UIImage __autoreleasing *image = info[UIImagePickerControllerEditedImage];
    
    // If not, grab the original image
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    
    NSURL *assetURL = info[UIImagePickerControllerReferenceURL];
    if (!image && !assetURL)
    {
        NSLog(@"Cannot retrieve an image from the selected item. Giving up.");
    }
    else if (!image)
    {
        NSLog(@"Retrieving from Assets Library");
        [self loadImageFromAssetURL:assetURL into:&image];
    }
    
    if (image)
    {
        // Save the image
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        //MAS UPDATE THE IMAGE VIEW RECEIPT
        _imageViewAttendee.image = image;
    }
    
    [self performDismiss];
}

// Dismiss picker
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self performDismiss];
}



- (IBAction)actionCameraReceiptImage:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        if (popover) return;
        
        // Create and initialize the picker
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = editSwitch.isOn;
        picker.delegate = self;
        
        [self presentViewController:picker];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //configure the model stuff
    //LBModel *model = (LBModel *)[self.tableData objectAtIndex:indexPath.row];
    //cell.textLabel.text = model[@"name"]; // [model objectForKeyedSubscript:@"name"];
    
    
    NSLog(@"Model Loaded %@",[[NSString alloc] initWithFormat:@"%@ $ %@",
                                      [[self model] name],
                                      [[self model] amount]
                                      ] );
    
    self.labelCurrentLocation.text = [[NSString alloc] initWithFormat:@"%@", [[self model] location] ];
    self.textFieldName.text = [[NSString alloc] initWithFormat:@"%@", [[self model] name] ];
    self.textFieldAmount.text = [[NSString alloc] initWithFormat:@"%@", [[self model] amount] ];
    
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    
    self.labelCurrentTime.text = [[NSString alloc] initWithFormat:@"%@", currentTime ];
    self.labelCurrentLocation.text = @"San Francisco, CA";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
