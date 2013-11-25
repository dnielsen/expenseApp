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

#define maxheight  150
#define maxwidth  150


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

- (IBAction)actionPhotoPick:(id)sender
{
    [arrAttendeeList removeAllObjects];
    [tblAttendeeList reloadData];
    self.usedCamera = NO;
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setAllowsEditing:YES];
    [imagePicker setWantsFullScreenLayout:YES];
    [imagePicker setHidesBottomBarWhenPushed:YES];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (IBAction)actionCamera:(id)sender
{
    [arrAttendeeList removeAllObjects];
    [tblAttendeeList reloadData];

    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        if (popover) return;
        
        // Create and initialize the picker
        UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
        picker1.sourceType =  UIImagePickerControllerSourceTypeCamera;
        picker1.allowsEditing = editSwitch.isOn;
        picker1.delegate = self;
        
        [self presentViewController:picker1 animated:YES completion:nil];
        //MAS TODO  !!!
    }
}


#pragma mark - Add Remove waitView

- (void)addWaitView
{
    [loadView setHidden:NO];
}

- (void)removeWaitView
{
    [loadView setHidden:YES];
}


#pragma mark-

- (IBAction)actionSubmitToConcur:(id)sender
{
    [self addWaitView];
    [self performSelector:@selector(saveAndClose) withObject:nil afterDelay:0.2];
}

- (IBAction)actionSubmitToHpLabs:(id)sender
{
    NSLog(@"actionSubmitToHpLabs");
    [self addWaitView];
    [self performSelector:@selector(callAllMethods) withObject:nil afterDelay:0.2];
    
}

- (void)callAllMethods
{
    [self HpAuthentication];
    [self uploadAllFaces];
    [self HpFaceDetection1];
//    [self HpFaceVerification1];
}

- (void)HpAuthentication
{
    
    //    ***************** HP Authentication Start *******************
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"dnielsen",@"Deepblue1", nil] forKeys:[NSArray arrayWithObjects:@"username",@"password", nil]];
    
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"10873218563681",dict1, nil] forKeys:[NSArray arrayWithObjects:@"tenantId",@"passwordCredentials", nil]];
    
    NSDictionary *dict4 = [NSDictionary dictionaryWithObject:dict2 forKey:@"auth"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict4 options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@""];
    
    NSMutableData *requestData = [NSMutableData dataWithBytes: [requestString UTF8String] length: [requestString length]];
    [requestData appendData:jsonData];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/tokens"]];
    
    [request setHTTPMethod:@"POST"];
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
    
    //    ******************* HP Authentication Done ********************************
    
    
}


- (void)uploadAllFaces
{
    /*
    appdel.arrUserImages = [[NSMutableArray alloc] init];
    for(int i=0 ; i<arrayOfUsers.count ; i++ )
    {
        NSDictionary *dict = [arrayOfUsers objectAtIndex:i];
        NSString *imgstr = [dict objectForKey:@"userImage"];
        NSString *pathOfImage = [[NSBundle mainBundle] pathForResource:imgstr ofType:@"jpg"];
        
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:pathOfImage];
        NSData *imageData = UIImageJPEGRepresentation(img, 90);
        
        int r = arc4random_uniform(100000);
        
        NSString *imgUrl = [NSString stringWithFormat:@"https://region-a.geo-1.objects.hpcloudsvc.com/v1/10873218563681/FaceVarify/ImageFace/Image%d.jpg",r];
        
        [appdel.arrUserImages addObject:imgUrl];
        
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:imgUrl]];
        [request setValue:appdel.hpToken forHTTPHeaderField:@"X-Auth-Token"];
        
        [request setHTTPMethod:@"PUT"];
        
        [request setHTTPBody:imageData];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        NSString *returnStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//        NSLog(@"OBJ_STORAGE:returnStr:%@",returnStr);

    }
    
    */
    
    NSData *imageDataGroup = UIImageJPEGRepresentation(_imageViewAttendee.image, 90);
    
    int r = arc4random_uniform(100000);
    
    groupImgStr = [NSString stringWithFormat:@"https://region-a.geo-1.objects.hpcloudsvc.com/v1/10873218563681/FaceVarify/ImageFace/Image%d.jpg",r];
    
    NSMutableURLRequest *request1=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:groupImgStr]];
    [request1 setValue:appdel.hpToken forHTTPHeaderField:@"X-Auth-Token"];
    
    [request1 setHTTPMethod:@"PUT"];
    
    [request1 setHTTPBody:imageDataGroup];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"OBJ_STORAGE:returnStr:%@",returnStr);

    
}


- (void)HpFaceDetection1
{
    
    NSString *strContainer = @"https://region-a.geo-1.objects.hpcloudsvc.com/v1/10873218563681/FaceVarify";
    
    NSString *strUrl = [NSString stringWithFormat:@"http://map-api.hpl.hp.com/facedetect?url_pic=%@&url_object_store=%@/%@",groupImgStr,strContainer,appdel.hpToken];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [request setValue:appdel.hpToken forHTTPHeaderField:@"X-Auth-Token"];
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil ];
    
    NSString *str = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //    NSLog(@"Response::%@",str);
    if([str length]> 0)
    {
        NSDictionary *DataDict = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
        
        if(DataDict.count > 0)
        {
            NSArray *arrFace = [DataDict objectForKey:@"face"];
            if(arrFace.count > 0)
            {
                //            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Face detection" message:[NSString stringWithFormat:@"%d face(s) detected",[arrFace count]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                //            [al show];
                [self drawFaces:arrFace];
                [self HpFaceVerification1];
                return;
                
            }
            else
            {
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Face detection" message:@"No faces detected" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [al show];
            }
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
    [self performSelectorOnMainThread:@selector(removeWaitView) withObject:nil waitUntilDone:NO];
    
}


- (void)HpFaceVerification1
{
    
    NSString *strContainer = @"https://region-a.geo-1.objects.hpcloudsvc.com/v1/10873218563681/FaceVarify";
    
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"http://map-api.hpl.hp.com/faceverify?url_pic_source=%@",groupImgStr];
    
    NSString *pathOfUsersTitle = [[NSBundle mainBundle] pathForResource:@"Users" ofType:@"plist"];
    NSMutableArray *arrayOfUsers = [[NSMutableArray alloc] initWithContentsOfFile:pathOfUsersTitle];
    
    for(int i=0 ; i<arrayOfUsers.count ; i++ )
    {
        NSString *strUrlTemp = [NSString stringWithFormat:@"&url_pic=%@",[[arrayOfUsers objectAtIndex:i] objectForKey:@"userImage"]];
        [strUrl appendString:strUrlTemp];
    }
    
    [strUrl appendFormat:@"&url_object_store=%@/%@",strContainer,appdel.hpToken];
    
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [request setValue:appdel.hpToken forHTTPHeaderField:@"X-Auth-Token"];
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil ];
    
    NSString *str = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    //    NSLog(@"%@",str);
    if(str.length > 0)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
        
        if([dict objectForKey:@"type"])
        {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [al show];
            [self performSelectorOnMainThread:@selector(removeWaitView) withObject:nil waitUntilDone:NO];
            return;
        }
        
        NSMutableArray *arrFaceIds = [[NSMutableArray alloc] init];
        NSMutableArray *arrFaceCompare = [[NSMutableArray alloc] init];
        
        NSArray *arrFace = [dict objectForKey:@"face"];
        NSArray *arrFaceMatrix = [dict objectForKey:@"face_matrix"];
        NSString *id_pic_sourceStr = [[dict objectForKey:@"faceverify"] objectForKey:@"id_pic_source"];
        
        for(int k=0;k<arrFace.count;k++)
        {
            if([[[arrFace objectAtIndex:k] objectForKey:@"id_pic"] isEqualToString:id_pic_sourceStr])
            {
                [arrFaceIds addObject:[arrFace objectAtIndex:k]];
            }
            else
            {
                NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
                [dictTemp addEntriesFromDictionary:[arrFace objectAtIndex:k]];
                for(int g = 0 ;g<arrayOfUsers.count;g++)
                {
                    if([[[arrayOfUsers objectAtIndex:g] objectForKey:@"picId"] isEqualToString:[dictTemp objectForKey:@"id_pic"]])
                    {
                        [dictTemp setObject:[[arrayOfUsers objectAtIndex:g]objectForKey:@"userName"] forKey:@"userName"];
                        [arrFaceCompare addObject:dictTemp];
                        break;
                    }
                }
            }
        }
        
        NSMutableArray *arrResults = [[NSMutableArray alloc] init];
        
        for(int g = 0; g < arrFaceIds.count; g++)
        {
            NSMutableArray *arrTempFaces = [[NSMutableArray alloc] init];
            
            for(int f = 0; f< arrFaceMatrix.count;f++)
            {
                if([[[arrFaceMatrix objectAtIndex:f] objectForKey:@"id_face1"] isEqualToString:[[arrFaceIds objectAtIndex:g] objectForKey:@"id_face"]] || [[[arrFaceMatrix objectAtIndex:f] objectForKey:@"id_face2"] isEqualToString:[[arrFaceIds objectAtIndex:g] objectForKey:@"id_face"]])
                {
                    [arrTempFaces addObject:[arrFaceMatrix objectAtIndex:f]];
                }
                
            }
            
            [arrResults addObject:arrTempFaces];
        }
        
        NSMutableArray *finalResults = [[NSMutableArray alloc] init];
        //        NSLog(@"arrResults:%@",[arrResults description]);
        for(int q=0;q<arrResults.count;q++)
        {
            NSMutableArray *arrTemp1 = [[NSMutableArray alloc] init];
            NSArray *arrTemp = [arrResults objectAtIndex:q];
            //            For avg values of Sim > 0.6
            float simTemp = 0.60;
            
            for(int w=0;w<arrTemp.count;w++)
            {
                if(simTemp < [[[arrTemp objectAtIndex:w] objectForKey:@"sim"] floatValue])
                {
                    [arrTemp1 addObject:[arrTemp objectAtIndex:w]];
                }
            }
            [finalResults addObject:arrTemp1];
        }
        
        arrFinal = [[NSMutableArray alloc] init];
        
        for(int k =0;k<finalResults.count;k++)
        {
            NSArray *arrTemp = [finalResults objectAtIndex:k];
            NSMutableArray *arrTempR = [[NSMutableArray alloc] init];
            for(int j = 0;j<arrTemp.count;j++)
            {
                for(int f = 0;f< arrFaceCompare.count;f++)
                {
                    if([[[arrTemp objectAtIndex:j] objectForKey:@"id_face1"] isEqualToString:[[arrFaceCompare objectAtIndex:f] objectForKey:@"id_face"]] || [[[arrTemp objectAtIndex:j] objectForKey:@"id_face2"] isEqualToString:[[arrFaceCompare objectAtIndex:f] objectForKey:@"id_face"]])
                    {
                        [arrTempR addObject:[arrFaceCompare objectAtIndex:f]];
                    }
                }
            }
            [arrFinal addObject:arrTempR];
        }
        NSLog(@"%@",[arrFinal description]);

        for (int e = 0; e < arrFinal.count; e++)
        {
            if([[arrFinal objectAtIndex:e]count] > 0)
                [arrAttendeeList addObject:[[arrFinal objectAtIndex:e] objectAtIndex:0]];
        }
        NSLog(@"%@",arrAttendeeList);
        if(arrAttendeeList.count > 0)
        {
            [tblAttendeeList reloadData];
            [tblAttendeeList flashScrollIndicators];
        }
        else
        {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Faces Varified" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [al show];
        }
    }
    else
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please check internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [al show];
    }
    [self performSelectorOnMainThread:@selector(removeWaitView) withObject:Nil waitUntilDone:NO];
    
}

//Face Verification with Diffrent Faces

/*

 
 - (void)HpFaceVerification1
 {
 
 NSString *strContainer = @"https://region-a.geo-1.objects.hpcloudsvc.com/v1/10873218563681/FaceVarify";
 
 NSMutableString *strUrl = [NSMutableString stringWithFormat:@"http://map-api.hpl.hp.com/faceverify?url_pic_source=%@",groupImgStr];
 
 NSString *pathOfUsersTitle = [[NSBundle mainBundle] pathForResource:@"Users" ofType:@"plist"];
 NSMutableArray *arrayOfUsers = [[NSMutableArray alloc] initWithContentsOfFile:pathOfUsersTitle];
 
 for(int i=0 ; i<arrayOfUsers.count ; i++ )
 {
 NSString *strUrlTemp = [NSString stringWithFormat:@"&url_pic=%@",[[arrayOfUsers objectAtIndex:i] objectForKey:@"userImage"]];
 [strUrl appendString:strUrlTemp];
 }
 
 [strUrl appendFormat:@"&url_object_store=%@/%@",strContainer,appdel.hpToken];
 
 
 NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
 
 [request setValue:appdel.hpToken forHTTPHeaderField:@"X-Auth-Token"];
 
 NSURLResponse *response;
 NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil ];
 
 NSString *str = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
 
 //    NSLog(@"%@",str);
 if(str.length > 0)
 {
 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
 
 if([dict objectForKey:@"type"])
 {
 UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
 [al show];
 [self performSelectorOnMainThread:@selector(removeWaitView) withObject:nil waitUntilDone:NO];
 return;
 }
 
 NSMutableArray *arrFaceIds = [[NSMutableArray alloc] init];
 NSMutableArray *arrFaceCompare = [[NSMutableArray alloc] init];
 
 NSArray *arrFace = [dict objectForKey:@"face"];
 NSArray *arrFaceMatrix = [dict objectForKey:@"face_matrix"];
 NSString *id_pic_sourceStr = [[dict objectForKey:@"faceverify"] objectForKey:@"id_pic_source"];
 
 for(int k=0;k<arrFace.count;k++)
 {
 if([[[arrFace objectAtIndex:k] objectForKey:@"id_pic"] isEqualToString:id_pic_sourceStr])
 {
 [arrFaceIds addObject:[arrFace objectAtIndex:k]];
 }
 else
 {
 NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
 [dictTemp addEntriesFromDictionary:[arrFace objectAtIndex:k]];
 for(int g = 0 ;g<arrayOfUsers.count;g++)
 {
 if([[[arrayOfUsers objectAtIndex:g] objectForKey:@"picId"] isEqualToString:[dictTemp objectForKey:@"id_pic"]])
 {
 [dictTemp setObject:[[arrayOfUsers objectAtIndex:g]objectForKey:@"userName"] forKey:@"userName"];
 [arrFaceCompare addObject:dictTemp];
 break;
 }
 }
 }
 }
 
 NSMutableArray *arrResults = [[NSMutableArray alloc] init];
 
 for(int g = 0; g < arrFaceIds.count; g++)
 {
 NSMutableArray *arrTempFaces = [[NSMutableArray alloc] init];
 
 for(int f = 0; f< arrFaceMatrix.count;f++)
 {
 if([[[arrFaceMatrix objectAtIndex:f] objectForKey:@"id_face1"] isEqualToString:[[arrFaceIds objectAtIndex:g] objectForKey:@"id_face"]] || [[[arrFaceMatrix objectAtIndex:f] objectForKey:@"id_face2"] isEqualToString:[[arrFaceIds objectAtIndex:g] objectForKey:@"id_face"]])
 {
 [arrTempFaces addObject:[arrFaceMatrix objectAtIndex:f]];
 }
 
 }
 
 [arrResults addObject:arrTempFaces];
 }
 
 NSMutableArray *finalResults = [[NSMutableArray alloc] init];
 //        NSLog(@"arrResults:%@",[arrResults description]);
 for(int q=0;q<arrResults.count;q++)
 {
 NSMutableArray *arrTemp1 = [[NSMutableArray alloc] init];
 NSArray *arrTemp = [arrResults objectAtIndex:q];
 //            For avg values of Sim > 0.6
 float simTemp = 0.60;
 
 for(int w=0;w<arrTemp.count;w++)
 {
 if(simTemp < [[[arrTemp objectAtIndex:w] objectForKey:@"sim"] floatValue])
 {
 [arrTemp1 addObject:[arrTemp objectAtIndex:w]];
 }
 }
 [finalResults addObject:arrTemp1];
 }
 
 arrFinal = [[NSMutableArray alloc] init];
 
 for(int k =0;k<finalResults.count;k++)
 {
 NSArray *arrTemp = [finalResults objectAtIndex:k];
 NSMutableArray *arrTempR = [[NSMutableArray alloc] init];
 for(int j = 0;j<arrTemp.count;j++)
 {
 for(int f = 0;f< arrFaceCompare.count;f++)
 {
 if([[[arrTemp objectAtIndex:j] objectForKey:@"id_face1"] isEqualToString:[[arrFaceCompare objectAtIndex:f] objectForKey:@"id_face"]] || [[[arrTemp objectAtIndex:j] objectForKey:@"id_face2"] isEqualToString:[[arrFaceCompare objectAtIndex:f] objectForKey:@"id_face"]])
 {
 [arrTempR addObject:[arrFaceCompare objectAtIndex:f]];
 }
 }
 }
 [arrFinal addObject:arrTempR];
 }
 NSLog(@"%@",[arrFinal description]);
 }
 else
 {
 UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please check internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
 [al show];
 }
 [self performSelectorOnMainThread:@selector(removeWaitView) withObject:Nil waitUntilDone:NO];
 
 }
 
*/

//For compariosion with face_ids
/*
- (void)HpFaceVerification1
{
 
    NSString *strContainer = @"https://region-a.geo-1.objects.hpcloudsvc.com/v1/10873218563681/FaceVarify";
 
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"http://map-api.hpl.hp.com/faceverify?url_pic_source=%@",groupImgStr];
 
    NSString *pathOfUsersTitle = [[NSBundle mainBundle] pathForResource:@"Users" ofType:@"plist"];
    NSMutableArray *arrayOfUsers = [[NSMutableArray alloc] initWithContentsOfFile:pathOfUsersTitle];
 
    for(int i=0 ; i<arrayOfUsers.count ; i++ )
    {
        NSString *strUrlTemp = [NSString stringWithFormat:@"&url_pic=%@",[[arrayOfUsers objectAtIndex:i] objectForKey:@"userImage"]];
        [strUrl appendString:strUrlTemp];
    }
 
    [strUrl appendFormat:@"&url_object_store=%@/%@",strContainer,appdel.hpToken];
 
 
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
 
    [request setValue:appdel.hpToken forHTTPHeaderField:@"X-Auth-Token"];
 
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil ];
 
    NSString *str = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
//    NSLog(@"%@",str);
    if(str.length > 0)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *arrFaceIds = [[NSMutableArray alloc] init];
        NSMutableArray *arrFaceCompare = [[NSMutableArray alloc] init];
        
        NSArray *arrFace = [dict objectForKey:@"face"];
        NSArray *arrFaceMatrix = [dict objectForKey:@"face_matrix"];
        NSString *id_pic_sourceStr = [[dict objectForKey:@"faceverify"] objectForKey:@"id_pic_source"];
//        int j=0;
        
        for(int k=0;k<arrFace.count;k++)
        {
            if([[[arrFace objectAtIndex:k] objectForKey:@"id_pic"] isEqualToString:id_pic_sourceStr])
            {
                [arrFaceIds addObject:[arrFace objectAtIndex:k]];
            }
            else
            {
                NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
                [dictTemp addEntriesFromDictionary:[arrFace objectAtIndex:k]];
                for(int g = 0 ;g<arrayOfUsers.count;g++)
                {
                    if([[[arrayOfUsers objectAtIndex:g] objectForKey:@"faceId"] isEqualToString:[dictTemp objectForKey:@"id_face"]])
                    {
                        [dictTemp setObject:[[arrayOfUsers objectAtIndex:g]objectForKey:@"userName"] forKey:@"userName"];
                        [arrFaceCompare addObject:dictTemp];
                        break;
                    }
                }
            }
        }
        
        NSMutableArray *arrResults = [[NSMutableArray alloc] init];
        
        for(int g = 0; g < arrFaceIds.count; g++)
        {
            NSMutableArray *arrTempFaces = [[NSMutableArray alloc] init];
            
            for(int f = 0; f< arrFaceMatrix.count;f++)
            {
                if([[[arrFaceMatrix objectAtIndex:f] objectForKey:@"id_face1"] isEqualToString:[[arrFaceIds objectAtIndex:g] objectForKey:@"id_face"]] || [[[arrFaceMatrix objectAtIndex:f] objectForKey:@"id_face2"] isEqualToString:[[arrFaceIds objectAtIndex:g] objectForKey:@"id_face"]])
                {
                    [arrTempFaces addObject:[arrFaceMatrix objectAtIndex:f]];
                }
                
            }
            
            [arrResults addObject:arrTempFaces];
        }
        
        NSMutableArray *finalResults = [[NSMutableArray alloc] init];
        //        NSLog(@"arrResults:%@",[arrResults description]);
        for(int q=0;q<arrResults.count;q++)
        {
            NSMutableArray *arrTemp1 = [[NSMutableArray alloc] init];
            NSArray *arrTemp = [arrResults objectAtIndex:q];
//            For avg values of Sim > 0.6
            float simTemp = 0.60;
            
            for(int w=0;w<arrTemp.count;w++)
            {
                if(simTemp < [[[arrTemp objectAtIndex:w] objectForKey:@"sim"] floatValue])
                {
                    [arrTemp1 addObject:[arrTemp objectAtIndex:w]];
                }
            }
            [finalResults addObject:arrTemp1];
        }
        
        arrFinal = [[NSMutableArray alloc] init];
        
        for(int k =0;k<finalResults.count;k++)
        {
            NSArray *arrTemp = [finalResults objectAtIndex:k];
            NSMutableArray *arrTempR = [[NSMutableArray alloc] init];
            for(int j = 0;j<arrTemp.count;j++)
            {
                for(int f = 0;f< arrFaceCompare.count;f++)
                {
                    if([[[arrTemp objectAtIndex:j] objectForKey:@"id_face1"] isEqualToString:[[arrFaceCompare objectAtIndex:f] objectForKey:@"id_face"]] || [[[arrTemp objectAtIndex:j] objectForKey:@"id_face2"] isEqualToString:[[arrFaceCompare objectAtIndex:f] objectForKey:@"id_face"]])
                    {
                        [arrTempR addObject:[arrFaceCompare objectAtIndex:f]];
                    }
                }
            }
            [arrFinal addObject:arrTempR];
        }
        NSLog(@"%@",[arrFinal description]);
    }
    else
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please check internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [al show];
    }

    [self performSelectorOnMainThread:@selector(removeWaitView) withObject:Nil waitUntilDone:NO];
    
}
*/

-(void) drawFaces:(NSArray *)arrFace
{
    NSLog(@"%d Faces Detected",arrFace.count);
    
    float rate = 1;
    float imgwidth = 150;
    float imgheight = 150;
    float imgH = _imageViewAttendee.image.size.height;
    float imgw = _imageViewAttendee.image.size.width;
    
    
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
        
        NSString *s = [NSString stringWithFormat:@"%d",i];
        [self drawOnImage:rect :s];
        
    }
    
}


- (void)drawOnImage:(CGRect)rect :(NSString *)strCount
{
    NSLog(@"Creating image");
    
    CGRect rect1 = [_imageViewAttendee bounds];
    UIGraphicsBeginImageContextWithOptions(rect1.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_imageViewAttendee.layer renderInContext:context];
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
    
    _imageViewAttendee.image = result;
    [_imageViewAttendee setNeedsDisplay];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:rect];
    btn.userInteractionEnabled = TRUE;
    btn.enabled = TRUE;
    btn.tag = [strCount intValue];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(faceTouched:) forControlEvents:UIControlEventTouchDown];
    [_imageViewAttendee addSubview:btn];
    
    NSLog(@"Image creation finished");

}

- (void)faceTouched:(id)sender
{
    UIButton *b = (UIButton *)sender;
    NSLog(@"%d Oh My Face!!! :(",b.tag);
    arrTable = [arrFinal objectAtIndex:b.tag];
    if (arrTable.count == 0)
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Face matches" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [al show];
    }
}

- (IBAction)actionSave:(id)sender
{
    //Close the screen
    if([self.presentingViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        [self.presentingViewController dismissViewControllerAnimated:(YES) completion:nil];
    else if([self.presentingViewController respondsToSelector:@selector(dismissModalViewControllerAnimated:)])
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    else
        NSLog(@"Oooops, what system is this ?!!! - should never see this !");
    
}

- (void) saveAndClose
{
    model.ReportName = self.textFieldName.text;
    model.ReportTotal = [self.textFieldAmount.text doubleValue];
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


#pragma mark - TableView Delegate

// UITableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrAttendeeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ExpenseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [[arrAttendeeList objectAtIndex:indexPath.row] objectForKey:@"userName"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([_labelAttendeeOne.text isEqualToString:@"--"])
//        [_labelAttendeeOne setText:[[arrTable objectAtIndex:indexPath.row] objectForKey:@"userName"]];
//    else
//        [_labelAttendeeTwo setText:[[arrTable objectAtIndex:indexPath.row] objectForKey:@"userName"]];
//    
//    tbl.hidden = TRUE;
}


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
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    tbl.hidden = TRUE;
//    _labelAttendeeOne.text = @"--";
//    _labelAttendeeTwo.text = @"--";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //configure the model stuff
    arrAttendeeList = [[NSMutableArray alloc] init];

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
    
    self.labelCurrentLocation.text = @"San Francisco, CA";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
