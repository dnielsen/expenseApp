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

//#define ALERTLOGIN                  101
//#define ALERTNOUSERPASS             102

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

@synthesize imagePicker, usedCamera, model,txtExpType,picker,Flag;

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


#pragma mark - XML Response delegate method
-(void)xmlResponse:(RXMLElement *)theRoot
{
//    [General removeWaitView];
//    RXMLElement *loginId = [theRoot child:@"LoginId"];
    
//    [Settings sharedInstance].loginId = [loginId text];
//    [_delegate didLogin];
}

#pragma mark - Add Remove waitView

- (void)addWaitView
{
    controller = [self.storyboard instantiateViewControllerWithIdentifier:@"waitView"];
    [self.view addSubview:controller.view];
}

- (void)removeWaitView
{
    [controller.view removeFromSuperview];
}


#pragma mark-



- (IBAction)actionSubmitToConcur:(id)sender
{
    
    [self addWaitView];
    [self performSelector:@selector(saveAndClose) withObject:nil afterDelay:0.0];


//    [self saveAndClose];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Submit to Concur"
//                                                    message:@"Expense report has been submitted to Concur"
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
}

- (IBAction)actionUpdate:(id)sender {
    
    NSLog(@"actionUpdate");
    
    
    if ( false )
    {
//        [AppDelegate identifyFacesFromPicture:@""];
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
    
//    [self saveAndClose];
    
    
    //Close the screen
    if([self.presentingViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        [self.presentingViewController dismissViewControllerAnimated:(YES) completion:nil];
    else if([self.presentingViewController respondsToSelector:@selector(dismissModalViewControllerAnimated:)])
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    else
        NSLog(@"Oooops, what system is this ?!!! - should never see this !");
    
}

- (void) saveAndClose {
    
    
    model.ReportName = self.textFieldName.text;
    
//    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//    [f setNumberStyle:NSNumberFormatterDecimalStyle];
//    model.ReportTotal = [f numberFromString:self.textFieldAmount.text];
    model.ReportTotal = [self.textFieldAmount.text doubleValue];
//    model.location = self.labelCurrentLocation.text;
    model.ReportDate = self.labelCurrentTime.text;
    
    if(model.ReportId)
    {
        [self EditReport];
    }
    else
    {
        [self CreateReport];
    }
    
    
    //Close the screen
    if([self.presentingViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        [self.presentingViewController dismissViewControllerAnimated:(YES) completion:nil];
    else if([self.presentingViewController respondsToSelector:@selector(dismissModalViewControllerAnimated:)])
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    else
        NSLog(@"Oooops, what system is this ?!!! - should never see this !");
    
}

- (void)CreateReport
{
    NSLog(@"Create Report");

    NSString *url = [NSString stringWithFormat:@"%@/api/expense/expensereport/v1.1/report",kURL];
    
    NSString *authHeaderValue = [NSString stringWithFormat:@"OAuth %@", appdel.ConcurToken];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request addValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    NSString *str = [NSString stringWithFormat:@"<Report xmlns=\"http://www.concursolutions.com/api/expense/expensereport/2011/03\"><Name>%@</Name></Report>",_textFieldName.text];
    
    NSData *data1 = [NSMutableData dataWithBytes: [str UTF8String] length: [str length]];
    [request setHTTPBody:data1];
    
    NSData *data12 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *response = [[NSString alloc] initWithData:data12 encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",response);
    
    if(response.length > 0)
    {
        RXMLElement *rootXML = [RXMLElement elementFromXMLString:response encoding:NSUTF8StringEncoding];
        if([rootXML child:@"Status"])
        {
            NSString *status = [[rootXML child:@"Status"] text];
            if(status)
            {
                if([status isEqualToString:@"SUCCESS"])
                {
                    NSLog(@"Report Created SUCCESS");
                    
                    NSString *detailurl = [[rootXML child:@"Report-Details-Url"]text];

                    
//                  to Create Entry in report
                    
                    
                    NSArray *arr = [detailurl componentsSeparatedByString:@"/"];
                    NSString *strReportId = [arr lastObject];
                    
                    NSDate *objdate = [NSDate date];
                    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
                    [dateformatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *strdate = [dateformatter stringFromDate:objdate];
                    
                    NSString *strUrl1 = [NSString stringWithFormat:@"%@/api/expense/expensereport/v1.1/report/%@/entry/",kURL,strReportId];
                    NSMutableURLRequest *requestCreateEntry = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl1]];
                    
                    NSString *strXml = [NSString stringWithFormat:@"<ReportEntries xmlns=\"http://www.concursolutions.com/api/expense/expensereport/2011/03\"><Expense><CrnCode>USD</CrnCode><ExpKey>%@</ExpKey><TransactionDate>%@</TransactionDate><TransactionAmount>%@</TransactionAmount><IsPersonal>N</IsPersonal></Expense></ReportEntries>",strExpKey,strdate,_textFieldAmount.text];
                    
                    [requestCreateEntry addValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
                    
                    [requestCreateEntry addValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
                    
                    [requestCreateEntry setHTTPMethod:@"POST"];
                    
                    NSData *dataXML = [NSMutableData dataWithBytes: [strXml UTF8String] length: [strXml length]];
                    [requestCreateEntry setHTTPBody:dataXML];
                    
                    NSData *dataEntryResponse = [NSURLConnection sendSynchronousRequest:requestCreateEntry returningResponse:nil error:nil];
                    NSString *responsexml = [[NSString alloc] initWithData:dataEntryResponse encoding:NSUTF8StringEncoding];
//                    NSLog(@"%@",responsexml);
                    if(responsexml.length > 0)
                    {
                        RXMLElement *rootEntryXML = [RXMLElement elementFromXMLString:responsexml encoding:NSUTF8StringEncoding];
                        if([rootEntryXML child:@"Status"])
                        {
                            NSString *statusEntry = [[rootEntryXML child:@"Status"] text];
                            if(statusEntry)
                            {
                                if([statusEntry isEqualToString:@"SUCCESS"])
                                {
                                    NSLog(@"Report Entry Created SUCCESS");
                                }
                            }
                        }
                    }
                    else
                    {
                        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some error has occured.Please tyr again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [al show];
                    }
                    
                }
            }
        }
    }
    else
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some error has occured.Please tyr again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [al show];

    }
    
    [self performSelectorOnMainThread:@selector(removeWaitView) withObject:Nil waitUntilDone:NO];

}

- (void)EditReport
{
    NSLog(@"Edit Report");
//    NSString *url = [NSString stringWithFormat:@"%@/api/expense/expensereport/v1.1/report/%@",kURL,model.ReportId];
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
    NSString *authHeaderValue = [NSString stringWithFormat:@"OAuth %@", appdel.ConcurToken];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [request setHTTPMethod:@"POST"];
//    [request addValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
//    //    [request addValue:@"dimplebhvasar@gmail.com" forHTTPHeaderField:@"X-UserID"];
//    
//    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
//    
//    NSString *str = [NSString stringWithFormat:@"<Report xmlns=\"http://www.concursolutions.com/api/expense/expensereport/2011/03\"><Name>%@</Name></Report>",_textFieldName.text];
//    
//    NSData *data1 = [NSMutableData dataWithBytes: [str UTF8String] length: [str length]];
//    [request setHTTPBody:data1];
//    
//    NSData *data12 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *response = [[NSString alloc] initWithData:data12 encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",response);
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    if(response.length > 0)
//    {
//        RXMLElement *rootXML = [RXMLElement elementFromXMLString:response encoding:NSUTF8StringEncoding];
//        if([rootXML child:@"Status"])
//        {
//            NSString *status = [[rootXML child:@"Status"] text];
//            if(status)
//            {
//                if([status isEqualToString:@"SUCCESS"])
//                {
//                    NSLog(@"Report Edited SUCCESS");
//                    
//                    NSString *detailurl = [[rootXML child:@"Report-Details-Url"]text];
//                    
    
//                  To Edit Entry in report
                    
                    
//                    NSArray *arr = [detailurl componentsSeparatedByString:@"/"];
//                    NSString *strReportId = [arr lastObject];
    
                    NSDate *objdate = [NSDate date];
                    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
                    [dateformatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *strdate = [dateformatter stringFromDate:objdate];
                    
                    NSString *strUrl1 = [NSString stringWithFormat:@"%@/api/expense/expensereport/v1.1/report/%@/entry/%@",kURL,model.ReportId,self.model.entryId];
                    NSMutableURLRequest *requestCreateEntry = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl1]];
                    
                    NSString *strXml = [NSString stringWithFormat:@"<ReportEntries xmlns=\"http://www.concursolutions.com/api/expense/expensereport/2011/03\"><Expense><CrnCode>USD</CrnCode><ExpKey>%@</ExpKey><TransactionDate>%@</TransactionDate><TransactionAmount>%@</TransactionAmount><IsPersonal>N</IsPersonal></Expense></ReportEntries>",strExpKey,strdate,_textFieldAmount.text];
                    
                    [requestCreateEntry addValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
                    
                    [requestCreateEntry addValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
                    
                    [requestCreateEntry setHTTPMethod:@"POST"];
                    
                    NSData *dataXML = [NSMutableData dataWithBytes: [strXml UTF8String] length: [strXml length]];
                    [requestCreateEntry setHTTPBody:dataXML];
                    
                    NSData *dataEntryResponse = [NSURLConnection sendSynchronousRequest:requestCreateEntry returningResponse:nil error:nil];
                    NSString *responsexml = [[NSString alloc] initWithData:dataEntryResponse encoding:NSUTF8StringEncoding];
                    //                    NSLog(@"%@",responsexml);
                    if(responsexml.length > 0)
                    {
                        RXMLElement *rootEntryXML = [RXMLElement elementFromXMLString:responsexml encoding:NSUTF8StringEncoding];
                        

                        if([rootEntryXML children:@"ReportEntryStatus"])
                        {
                            RXMLElement *entryxml = [[rootEntryXML children:@"ReportEntryStatus"] objectAtIndex:0];
                            NSString *statusEntry = [[entryxml child:@"Status"] text];
                            if(statusEntry)
                            {
                                if([statusEntry isEqualToString:@"SUCCESS"])
                                {
                                    NSLog(@"Report Entry Edited SUCCESS");
                                }
                            }
                        }
                    }
                    else
                    {
                        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some error has occured.Please tyr again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [al show];
                    }
                    
//                }
//            }
//        }
//    }
//    else
//    {
//        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some error has occured.Please tyr again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [al show];
//        
//    }

[self performSelectorOnMainThread:@selector(removeWaitView) withObject:Nil waitUntilDone:NO];
    
}


//- (NSString *) xmlEscape: (NSString*)src
//{
//    NSMutableString *str = [NSMutableString stringWithString:src];
//    [str replaceOccurrencesOfString:@"&"  withString:@"&amp;"  options:NSLiteralSearch range:NSMakeRange(0, [str length])];
//    [str replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
//    [str replaceOccurrencesOfString:@"'"  withString:@"&apos;" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
//    [str replaceOccurrencesOfString:@">"  withString:@"&gt;"   options:NSLiteralSearch range:NSMakeRange(0, [str length])];
//    [str replaceOccurrencesOfString:@"<"  withString:@"&lt;"   options:NSLiteralSearch range:NSMakeRange(0, [str length])];
//    
//    return str;
//    
//}



#pragma mark - textfield delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag == 3)
    {
        [_textFieldAmount resignFirstResponder];
        [_textFieldName resignFirstResponder];
        
        picker.hidden = FALSE;
        if(textField.text.length == 0)
        {
            [picker selectRow:0 inComponent:0 animated:NO];
        }
        else if([textField.text isEqualToString:@"Breakfast"])
        {
            [picker selectRow:0 inComponent:0 animated:NO];
        }
        else if([textField.text isEqualToString:@"Lunch"])
        {
            [picker selectRow:1 inComponent:0 animated:NO];
        }
        else if([textField.text isEqualToString:@"Dinner"])
        {
            [picker selectRow:2 inComponent:0 animated:NO];
        }
        
        return NO;
    }
    else
        return YES;
}

#pragma mark - UIPickerView Delegate


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrPicker.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrPicker objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [txtExpType setText:[arrPicker objectAtIndex:row]];
    picker.hidden = TRUE;
    
    if(row == 0)
        strExpKey = @"BRKFT";
    else if(row == 1)
        strExpKey = @"LUNCH";
    else
        strExpKey = @"DINNR";
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
    appdel = [UIApplication sharedApplication].delegate;
    
    if([self.Flag isEqualToString:@"CREATE"])
    {
        txtExpType.userInteractionEnabled = TRUE;
        _textFieldName.userInteractionEnabled = TRUE;
        _textFieldName.backgroundColor = [UIColor clearColor];
        txtExpType.backgroundColor =[UIColor whiteColor];
    }
    else
    {
        txtExpType.userInteractionEnabled = FALSE;
        _textFieldName.userInteractionEnabled = FALSE;
        _textFieldName.backgroundColor = [UIColor lightGrayColor];
        txtExpType.backgroundColor =[UIColor lightGrayColor];

    }
    
    arrPicker = [NSArray arrayWithObjects:@"Breakfast",@"Lunch",@"Dinner",nil];
    
    NSLog(@"Model Loaded %@",[[NSString alloc] initWithFormat:@"%@ $ %.2lf",
                                      [[self model] ReportName],
                                      [[self model] ReportTotal]
                                      ] );
    
//    self.labelCurrentLocation.text = [[NSString alloc] initWithFormat:@"%@", [[self model] location] ];
    self.textFieldName.text = [[NSString alloc] initWithFormat:@"%@", [[self model] ReportName] ];
    self.textFieldAmount.text = [[NSString alloc] initWithFormat:@"%.2lf", [[self model] ReportTotal] ];
    self.txtExpType.text = [[NSString alloc] initWithFormat:@"%@", [[self model] ExpenseType] ];
    strExpKey = [[self model] ExpenseTypeId];
    
//    NSDate *today = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    NSString *currentTime = [dateFormatter stringFromDate:today];
    
//    self.labelCurrentTime.text = [[NSString alloc] initWithFormat:@"%@", currentTime ];
    self.labelCurrentLocation.text = @"San Francisco, CA";

//    txtExpType.text = [[self model] ExpenseType];
//    if([strExpKey isEqualToString:@"DINNR"])
//        txtExpType.text = @"Dinner";
//    else if ([strExpKey isEqualToString:@"LUNCH"])
//        txtExpType.text = @"Lunch";
//    else
//        txtExpType.text = @"Breakfast";


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
