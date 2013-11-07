//
//  HomeViewController.m
//  expense-app
//
//  Created by Matt Schmulen on 9/28/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//


#define maxheight  150
#define maxwidth  150


#import "HomeViewController.h"
#import "AppDelegate.h"

#import "utility.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>


//#import "AFHTTPRequestOperationManager.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (strong, nonatomic) IBOutlet UIImageView *imageUser;

@end

@implementation HomeViewController

UISwitch *editSwitch;
UIPopoverController *popover;

@synthesize imagePicker, usedCamera,imageUser;

#pragma mark - Image picker Delegate

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
        imageUser.image = image;
    }
    
    [self performDismiss];
}

// Dismiss picker
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self performDismiss];
}


#pragma mark - Actions


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

NSString *imgUrl;

- (IBAction)actionSubmitImageToHP:(id)sender
{
    
    NSLog(@"actionSubmitImageToHP");
//    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"HpToken"])
        [self HpAuthentication];
//    else
//    {
//        appdel.hpToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"HpToken"];
//    }
//    *************************** HP Face Detection Start *****************************************************
    [self HpUploadTo_ObjectStorage];
    
    [self HpFaceDetection1];
    
    
    
//    https://region-a.geo-1.objects.hpcloudsvc.com/v1/10873218563681
    
}



- (void)HpUploadTo_ObjectStorage
{
    NSData *imageData = UIImageJPEGRepresentation(imageUser.image, 90);
    
    int r = arc4random_uniform(100000);
   
    imgUrl = [NSString stringWithFormat:@"https://region-a.geo-1.objects.hpcloudsvc.com/v1/10873218563681/FaceVarify/%@/Image%d.jpg",appdel.hpToken,r];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:imgUrl]];
    [request setValue:appdel.hpToken forHTTPHeaderField:@"X-Auth-Token"];
    
    [request setHTTPMethod:@"PUT"];

    [request setHTTPBody:imageData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"OBJ_STORAGE:returnStr:%@",returnStr);

// Temp Close Code for image store in local
    
//    NSString *imageName = @"userImage.jpg";
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* documentsDirectory = [paths objectAtIndex:0];
//
//    // Now we get the full path to the file
//    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
//
//    // and then we write it out
//    [imageData writeToFile:fullPathToFile atomically:NO];

    
}

//Working Function
- (void)HpFaceDetection1
{
    
    NSString *strContainer = @"https://region-a.geo-1.objects.hpcloudsvc.com/v1/10873218563681/FaceVarify";
    
    NSString *strUrl = [NSString stringWithFormat:@"http://map-api.hpl.hp.com/facedetect?url_pic=%@&url_object_store=%@/%@",imgUrl,strContainer,appdel.hpToken];

    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [request setValue:appdel.hpToken forHTTPHeaderField:@"X-Auth-Token"];
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil ];

    NSString *str = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"Response::%@",str);
    if([str length]> 0)
    {
        NSDictionary *DataDict = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
        
        if(DataDict.count > 0)
        {
            NSArray *arrFace = [DataDict objectForKey:@"face"];
//            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Face detection" message:[NSString stringWithFormat:@"%d face(s) detected",[arrFace count]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [al show];
            [self drawFaces:arrFace];
        }
        else
        {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Face detection" message:@"No faces detected" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [al show];

        }
        
    }
    else
    {
        NSLog(@"No Faces Detected");
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Face detection" message:@"No faces detected" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [al show];

    }
    
//    Now Delete Image from Hp Cloud
    
//    NSMutableURLRequest *delRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://region-a.geo-1.objects.hpcloudsvc.com/v1/10873218563681?bulk-delete"]];
//    [request setValue:appdel.hpToken forHTTPHeaderField:@"X-Auth-Token"];
//
//    [request setHTTPMethod:@"DELETE"];
//    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
//    NSString *body = [NSString stringWithFormat:@"FaceVarify/Image82850.jpg"];
//    NSData *databody = [body dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [request setHTTPBody:databody];
//    
//    NSData *returnDataDel = [NSURLConnection sendSynchronousRequest:delRequest returningResponse:nil error:nil];
//    NSString *returnStrDel = [[NSString alloc] initWithData:returnDataDel encoding:NSUTF8StringEncoding];
//    NSLog(@"bulk-delete:returnStr:%@",returnStrDel);

    
}

-(void) drawFaces:(NSArray *)arrFace
{
    NSLog(@"%d Faces Detected",arrFace.count);
    
    float rate = 1;
    float imgwidth = 150;
    float imgheight = 150;
    float imgH = imageUser.image.size.height;
    float imgw = imageUser.image.size.width;
    
    
    if (imgw / imgwidth > imgH / imgheight)
    {
        if (imgheight > 150 && imgwidth > 320)
        {
            imgwidth = 320;
        }
        rate = imgwidth / imgw;
        
        if (rate > 1)
        {
            rate = 1;
            imgwidth = imgw;
            imgheight = imgH;
        }
        else
        {
            imgheight = imgH * rate;
        }
    }
    else
    {
        rate = imgheight / imgH;
        
        if (imgheight > 150 && imgwidth > 320)
        {
            imgheight = 150;
        }
        if (rate > 1)
        {
            rate = 1;
            imgwidth = imgw;
            imgheight = imgH;
        }
        else
        {
            imgwidth = imgw * rate;
        }
    }

    
    for (int i = 0; i < arrFace.count; i++)
    {
        NSLog(@"Drawing Rect %d",i);
        NSDictionary *dict = [arrFace objectAtIndex:i];
        CGFloat left1 = [[dict objectForKey:@"bb_left"] floatValue];
        CGFloat top1 = [[dict objectForKey:@"bb_top"] floatValue];
        CGFloat right1 = [[dict objectForKey:@"bb_right"] floatValue];
        CGFloat bottom1 = [[dict objectForKey:@"bb_bottom"] floatValue];
        
        
        CGFloat top = top1 * rate + (maxheight - imgheight) / 2;
        CGFloat left = left1 * rate + (maxwidth - imgwidth) / 2;
        CGFloat height = (bottom1 - top1) * rate;
        CGFloat width = (right1 - left1) * rate;
        
        CGRect rect = CGRectMake(left, top, width, height);
//        CGRect rect = CGRectMake(left1, top1, right1, bottom1);
        [self drawOnImage:rect];
        
    }

}


- (void)drawOnImage:(CGRect)rect
{
    
    
    NSLog(@"Creating image");
    
    CGRect rect1 = [imageUser bounds];
    UIGraphicsBeginImageContextWithOptions(rect1.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [imageUser.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    CGSize size = CGSizeMake(150.0f, 150.0f);
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    [capturedImage drawAtPoint:CGPointMake(0,0)];
    CGContextSetStrokeColorWithColor(context1, [[UIColor blackColor] CGColor]);
    
//    CGRect rect2 = CGRectMake(20, 20, 50, 50);
    CGContextSetStrokeColorWithColor(context1, [[UIColor whiteColor] CGColor]);
    CGContextAddRect(context1, rect);
    CGContextStrokeRectWithWidth(context1, rect, 2.0);
    NSLog(@"\nRect : %.2f,%.2f,%.2f,%.2f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    imageUser.image = result;
    [imageUser setNeedsDisplay];
    
    NSLog(@"Image creation finished");
 
    
    
    
    
    
    
    
    
    
    
    
    
//    UIGraphicsBeginImageContext(imageUser.image.size);
//    
//    // Pass 1: Draw the original image as the background
//    [imageUser.image drawAtPoint:CGPointMake(0,0)];
//    
//    // Pass 2: Draw the line on top of original image
//    UIColor *lineColor = [UIColor whiteColor];
//
//
////    CGContextSetLineWidth(context, 1.0);
////    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddRect(context, rect);
//    
////    CGContextAddLineToPoint(context, imageUser.image.size.width, 0);
//    CGContextSetStrokeColorWithColor(context, [lineColor CGColor]);
//    CGContextStrokePath(context);
//    
//    // Create new image
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    [imageUser setImage:newImage];
//    // Tidy up
//    UIGraphicsEndImageContext();
    
}

/*
- (void)HpFaceDetection
{
    
    NSData *imageData = UIImageJPEGRepresentation(imageUser.image, 90);
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *strContainer = @"https://region-a.geo-1.objects.hpcloudsvc.com/v1/10873218563681/FaceVarify";
    
    NSString *strUrl = [NSString stringWithFormat:@"http://map-api.hpl.hp.com/facedetect?url_object_store=%@/%@",strContainer,appdel.hpToken];

//        NSString *strUrl = [NSString stringWithFormat:@"http://map-api.hpl.hp.com/facedetect"];
    
//    NSString *strUrl = [NSString stringWithFormat:@"http://map-api.hpl.hp.com/facedetect?X-Auth-Token=%@",appdel.hpToken];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request setValue:appdel.hpToken forHTTPHeaderField:@"X-Auth-Token"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request addValue:strContainer forHTTPHeaderField:@"url_object_store"];
    
    [request setHTTPMethod: @"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // file
//     NSString *boundary = @"---------------------------14737809831466499882746641449";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: attachment; name=\"pic\"; filename=\"1.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // text parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"url_object_store\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[strContainer dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"X-Auth-Token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[appdel.hpToken dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
//    [request setValue:[NSString stringWithFormat:@"%d",[body length]] forHTTPHeaderField:@"Content-Length"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"returnString:%@",returnString);
}
*/

/*
- (void)HpFaceDetection
{
    NSData *imageData;
    if(!imageUser.image)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Upload Photo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
    }
    else
    {
        imageData = UIImageJPEGRepresentation(imageUser.image, 90);
    }
    
    
    NSString *strContainer = @"https://region-a.geo-1.objects.hpcloudsvc.com/v1/10873218563681/FaceVarify";
    
    NSString *strUrl = [NSString stringWithFormat:@"http://map-api.hpl.hp.com/facedetect"];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
//    [request setValue:appdel.hpToken forHTTPHeaderField:@"X-Auth-Token"];

    
    [request setHTTPMethod: @"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];

//    Now Lets Create the body of the POST
    NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
//	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photoName\"; filename=\"%@.png\"\r\n",@"1"] dataUsingEncoding:NSUTF8StringEncoding]];
    

    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; type=\"text\"; id=\"url_object_store\"\r\n; name=\"%@\" type=\"file\" id=\"pic\" name=\"pic.png\"",strContainer] dataUsingEncoding:NSUTF8StringEncoding]];

//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; pic=\"%@.png\"\r\n",@"1"] dataUsingEncoding:NSUTF8StringEncoding]];

    
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
//    [body appendData:[[NSString stringWithFormat:@"X-Auth-Token=%@",appdel.hpToken] dataUsingEncoding:NSUTF8StringEncoding]];
    
	[request setHTTPBody:body];
    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"returnString:%@",returnString);
    
}
*/

- (void)HpAuthentication
{

//    ********************************** HP Authentication Start ************************************
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"dnielsen",@"Deepblue1", nil] forKeys:[NSArray arrayWithObjects:@"username",@"password", nil]];
    
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"10873218563681",dict1, nil] forKeys:[NSArray arrayWithObjects:@"tenantId",@"passwordCredentials", nil]];
    
    NSDictionary *dict4 = [NSDictionary dictionaryWithObject:dict2 forKey:@"auth"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict4 options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@""];
    
    NSMutableData *requestData = [NSMutableData dataWithBytes: [requestString UTF8String] length: [requestString length]];
    [requestData appendData:jsonData];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/tokens"]];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setHTTPBody:requestData];
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil ];
    
    //    NSString *str = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSDictionary *DataDict = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *dictRe1 = [[DataDict objectForKey:@"access"] objectForKey:@"token"];
    NSString *token = [dictRe1 objectForKey:@"id"];
    
    appdel.hpToken = token;
    NSLog(@"\n\nToken::::::%@",token);
    [[NSUserDefaults standardUserDefaults] setObject:appdel.hpToken forKey:@"HpToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    *************************** HP Authentication Done *****************************************************
    

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
    
    appdel = [UIApplication sharedApplication].delegate;
    
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
