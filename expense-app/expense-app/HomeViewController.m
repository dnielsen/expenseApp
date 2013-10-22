//
//  HomeViewController.m
//  expense-app
//
//  Created by Matt Schmulen on 9/28/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

#import "utility.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>


//#import "AFHTTPRequestOperationManager.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imageUser;

@end

@implementation HomeViewController

UISwitch *editSwitch;
UIPopoverController *popover;

@synthesize imagePicker, usedCamera;

- (IBAction)actionPhotoPick:(id)sender {
    
    NSLog(@"actionPhotoPick");
    self.usedCamera = NO;
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setAllowsEditing:YES];
    [imagePicker setWantsFullScreenLayout:YES];
    [imagePicker setHidesBottomBarWhenPushed:YES];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (IBAction)actionSubmitImageToHP:(id)sender {
    
    NSLog(@"actionSubmitImageToHP");
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
//    NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"dnielsen",@"Deepblue1", nil] forKeys:[NSArray arrayWithObjects:@"username",@"password", nil]];
//    NSDictionary *dict2 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:dict1,@"10873218563681",nil] forKeys:[NSArray arrayWithObjects:@"passwordCredentials",@"tenantId",nil]];
//    NSDictionary *dict3 = [NSDictionary dictionaryWithObject:dict2 forKey:@"auth"];
//    NSLog(@"Dimple:%@",dict3);
    
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"YS11LX9TT81LNVXKSKM7",@"r8zsRj+i/SfVSXkOiUlVZg2SJBw2p2izogqKlo+W", nil] forKeys:[NSArray arrayWithObjects:@"accessKey",@"secretKey", nil]];
    
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:dict1,[NSArray arrayWithObject:@"accessKey"], nil] forKeys:[NSArray arrayWithObjects:@"accessKey",@"methods", nil]];
    
    NSDictionary *dict3 = [NSDictionary dictionaryWithObject:dict2 forKey:@"identity"];
    
    NSDictionary *dict4 = [NSDictionary dictionaryWithObject:dict3 forKey:@"auth"];
    NSLog(@"Dimple:%@",dict4);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict4 options:NSJSONWritingPrettyPrinted error:nil];

    NSString *requestString = [NSString stringWithFormat:@""];
    
    NSMutableData *requestData = [NSMutableData dataWithBytes: [requestString UTF8String] length: [requestString length]];
    [requestData appendData:jsonData];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/tokens-d"]];

    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];

    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
    NSString *str = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error
    NSArray *DataArr = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
//    [DataArr retain];
    NSLog(@"\n\nDimple::::::%@",DataArr);
    
    

//    [manager POST:@"https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/tokens" parameters:dict3 success:^(AFHTTPRequestOperation *operation, id responseObject)
//    {
//        NSLog(@"JSON: %@", responseObject);
//    }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error)
//    {
//        NSLog(@"Error: %@", error);
//    }];
    
}

- (IBAction)actionCamera:(id)sender {
    
    //Press on the Camera Button
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
        _imageUser.image = image;
    }
    
    [self performDismiss];
}

// Dismiss picker
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self performDismiss];
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
    
	// Do any additional setup after loading the view.
//    [AppDelegate initializeServerData];
//    [AppDelegate updateHPToken];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
