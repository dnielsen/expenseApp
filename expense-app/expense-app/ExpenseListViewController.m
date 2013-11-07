//
//  ExpenseListViewController.m
//  expense-app
//
//  Created by Matt Schmulen on 9/28/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "ExpenseListViewController.h"

#import "AppDelegate.h"
#import "ExpenseDetailViewController.h"

//#import "AFHTTPRequestOperationManager.h"
//#import "AFHTTPRequestOperation.h"

#import "ExpenseModel.h"
//#import "UIActivityIndicatorView+AFNetworking.h"
//#import "UIAlertView+AFNetworking.h"

#define prototypeName @"expenses"

@interface ExpenseListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

//@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSMutableArray *tableData;


@end

@implementation ExpenseListViewController

@synthesize strFlag;

//- (IBAction)actionCreateNewExpense:(id)sender {
//    [ self createNewModel];
//}

- (IBAction)actionRefereshExpenseList:(id)sender
{
    [self.tableData removeAllObjects];
    [self addWaitView];
    [self performSelector:@selector(getModels) withObject:nil afterDelay:0.0];
}

- (NSArray *) tableData
{
    if ( !_tableData) _tableData = [[NSMutableArray alloc] init];//_tableData = [[NSArray alloc] init];
    return _tableData;
}

#pragma mark - Authenticate concur user

- (void)authenticateUser:(NSString *)uname1 : (NSString *)pass1
{
    NSString *loginId = uname1;
    NSString *password = pass1;
    NSString *credentials = [NSString stringWithFormat:@"%@:%@", loginId, password];
    NSData* credentialsData = [credentials dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedCredentials = [Base64 encode:credentialsData];
    NSString *strUrl = [NSString stringWithFormat:@"%@/net2/oauth2/accesstoken.ashx", kURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:kConsumerKey forHTTPHeaderField:@"X-ConsumerKey"];
    [request setValue:[NSString stringWithFormat:@"Basic %@",encodedCredentials] forHTTPHeaderField:@"Authorization"];
    
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *err = nil;
    NSURLResponse *resp = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    NSString *response;
    if (data != nil)
    {
        response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        RXMLElement *rootXML = [RXMLElement elementFromXMLString:response encoding:NSUTF8StringEncoding];
        if (rootXML)
        {
            RXMLElement *rxmlToken = [rootXML child:@"Token"];
            NSLog(@"token: %@", [rxmlToken text]);
            appdel.ConcurToken = [rxmlToken text];

            [self addWaitView];
            [self performSelector:@selector(getModels) withObject:nil afterDelay:0.0];

        }
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Authentication Failure" message:@"Something went wrong with authentication!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
    }
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
    
    //Close the screen
//    if([self.presentingViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
//        [self.presentingViewController dismissViewControllerAnimated:(YES) completion:nil];
//    else if([self.presentingViewController respondsToSelector:@selector(dismissModalViewControllerAnimated:)])
//        [self.presentingViewController dismissModalViewControllerAnimated:YES];
//    else
//        NSLog(@"Oooops, what system is this ?!!! - should never see this !");
//    

}

#pragma mark - Get concur User Reports

- ( void ) getModels
{

//    NSString *url = [NSString stringWithFormat:@"https://www.concursolutions.com/api/expense/expensereport/v1.1/Report"];
    
//    NSString *url = [NSString stringWithFormat:@"%@/api/expense/expensereport/v2.0/Reports/?status=ACTIVE",kURL];

    NSString *url = [NSString stringWithFormat:@"%@/api/expense/expensereport/v2.0/Reports/?loginid=%@",kURL,appdel.Cusername];
    

    NSString *authHeaderValue = [NSString stringWithFormat:@"OAuth %@", appdel.ConcurToken];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [request setHTTPMethod:@"GET"];
    [request addValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if(response.length > 0)
    {
        RXMLElement *rootXML = [RXMLElement elementFromXMLString:response encoding:NSUTF8StringEncoding];
        
        NSArray *list = [rootXML children:@"ReportSummary"];
        for(RXMLElement *qeXML in list)
        {
            ExpenseModel *newExp = [[ExpenseModel alloc] init];

            NSString *reName;
            NSString *reId;
//            NSString *reCurr;
            NSString *reTotal;
//            NSString *reDate;
//            NSString *reComment;
//            NSString *reStatus;
//            NSString *reDetailUrl;
//            NSString *reUserLogin;
//            NSString *reEmpname;
//            NSString *rePaystatus;
            
            
            if([qeXML child:@"ReportName"])
            {
                reName = [[qeXML child:@"ReportName"] text];
                if(reName)
                    newExp.ReportName = reName;
            }
            if([qeXML child:@"ReportId"])
            {
                reId = [[qeXML child:@"ReportId"]text];
                if(reId)
                    newExp.ReportId = reId;
            }
//            if([qeXML child:@"ReportCurrency"])
//            {
//                reCurr = [[qeXML child:@"ReportCurrency"]text];
//                if(reCurr)
//                    newExp.ReportCurrency = reCurr;
//            }
            if([qeXML child:@"ReportTotal"])
            {
                reTotal = [[qeXML child:@"ReportTotal"] text];
                if(reTotal)
                    newExp.ReportTotal = [reTotal doubleValue];
            }
//            if([qeXML child:@"ReportDate"])
//            {
//                reDate = [[qeXML child:@"ReportDate"] text];
//                if(reDate)
//                    newExp.ReportDate = reDate;
//            }
//            if([qeXML child:@"LastComment"])
//            {
//                reComment = [[qeXML child:@"LastComment"] text];
//                if(reComment)
//                    newExp.LastComment = reComment;
//            }
//            if([qeXML child:@"ApprovalStatus"])
//            {
//                reStatus = [[qeXML child:@"ApprovalStatus"] text];
//                if(reStatus)
//                    newExp.ApprovalStatus = reStatus;
//            }
//            if([qeXML child:@"ReportDetailsURL"])
//            {
//                reDetailUrl = [[qeXML child:@"ReportDetailsURL"] text];
//                if(reDetailUrl)
//                    newExp.ReportDetailsURL = reDetailUrl;
//            }
//            if([qeXML child:@"ExpenseUserLoginID"])
//            {
//                reUserLogin = [[qeXML child:@"ExpenseUserLoginID"] text];
//                if(reUserLogin)
//                    newExp.ExpenseUserLoginID = reUserLogin;
//            }
//            if([qeXML child:@"EmployeeName"])
//            {
//                reEmpname = [[qeXML child:@"EmployeeName"] text];
//                if(reEmpname)
//                    newExp.EmployeeName = reEmpname;
//            }
//            if([qeXML child:@"PaymentStatus"])
//            {
//                rePaystatus = [[qeXML child:@"PaymentStatus"] text];
//                if(rePaystatus)
//                    newExp.PaymentStatus = rePaystatus;
//            }
            [self.tableData addObject:newExp];

        }
        
        NSLog(@"%@",self.tableData);
        [[self myTableView] reloadData];

    }

    [self performSelectorOnMainThread:@selector(removeWaitView) withObject:Nil waitUntilDone:NO];
}



- (void)getReportDetails : (NSString *)repId
{
    NSString *url = [NSString stringWithFormat:@"%@/api/expense/expensereport/v2.0/report/%@",kURL,repId];
    
    NSString *authHeaderValue = [NSString stringWithFormat:@"OAuth %@", appdel.ConcurToken];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if(response.length > 0)
    {
        RXMLElement *rootXML = [RXMLElement elementFromXMLString:response encoding:NSUTF8StringEncoding];
        
        NSString *repname = [[rootXML child:@"ReportName"] text];
        NSString *reptotal = [[rootXML child:@"ReportTotal"] text];
        
        NSArray *entriesArr = [rootXML children:@"ExpenseEntriesList"];
        if(entriesArr.count > 0)
        {
            NSArray *entryArr = [[entriesArr objectAtIndex:0] children:@"ExpenseEntry"];
            if(entryArr.count > 0)
            {
                RXMLElement *qeXML = [entryArr objectAtIndex:0];
                NSString *expid = [[qeXML child:@"ExpenseTypeID"] text];
                NSString *repEntId = [[qeXML child:@"ReportEntryID"] text];
                
                detailModel = [ExpenseModel alloc];
                
                detailModel.ReportName = repname;
                detailModel.ReportTotal = [reptotal doubleValue];
                detailModel.ReportId = repId;
                detailModel.entryId = repEntId;
                detailModel.ExpenseTypeId = expid;
                
                if([expid isEqualToString:@"DINNR"])
                    detailModel.ExpenseType = @"Dinner";
                else if ([expid isEqualToString:@"LUNCH"])
                    detailModel.ExpenseType = @"Lunch";
                else
                    detailModel.ExpenseType = @"Breakfast";
                
            }
            else
            {
                detailModel = [ExpenseModel alloc];
                detailModel.ReportName = repname;
                detailModel.ReportTotal = [reptotal doubleValue];
                detailModel.ReportId = repId;
                detailModel.entryId = @"";
                detailModel.ExpenseTypeId = @"";
            }
        }
        else
        {
            detailModel = [ExpenseModel alloc];
            detailModel.ReportName = repname;
            detailModel.ReportTotal = [reptotal doubleValue];
            detailModel.ReportId = repId;
            detailModel.entryId = @"";
            detailModel.ExpenseTypeId = @"";
            
        }
    }
    else
    {
        detailModel = [ExpenseModel alloc];
        detailModel.ReportId = repId;
        detailModel.entryId = @"";
        detailModel.ExpenseTypeId = @"";
        detailModel.ReportName = @"";
        detailModel.ReportTotal = 0.00;
        
    }
    [self performSelectorOnMainThread:@selector(removeWaitView) withObject:Nil waitUntilDone:NO];
}




//- ( void ) createNewModel
//{
//    
//    //ExpenseModel *newModel = [[ExpenseModel alloc] initWithAttributes:@{"name": "new expense"}];
//    ExpenseModel *newModel = [ExpenseModel alloc];
//    
//    newModel.ReportName = @"new";
//    newModel.ReportTotal = 0.0;
//    
//    [[self tableData] addObject:newModel];
//    [[self myTableView] reloadData];
//
////    ExpenseDetailViewController *detailController = [[ExpenseDetailViewController alloc]init];
////    detailController.model = newModel;
////    
////    [self presentModalViewController:detailController animated:YES];
//
//    
//
//};

#pragma mark - TableView Delegate

// UITableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ExpenseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if ( [[ [self.tableData objectAtIndex:indexPath.row] class] isSubclassOfClass:[ExpenseModel class]])
    {
        ExpenseModel *model = (ExpenseModel *)[self.tableData objectAtIndex:indexPath.row];
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ $ %.2lf", [model ReportName], [model ReportTotal] ];
    }
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"showDetail"])
    {
        NSInteger row = [[self myTableView].indexPathForSelectedRow row];
        ExpenseModel *rowObject = [[self tableData] objectAtIndex:row];

//        [self addWaitView];
        [self getReportDetails:rowObject.ReportId];//        Get ReportDetails
        ExpenseDetailViewController *detailController = segue.destinationViewController;
        detailController.Flag = @"EDIT";
        
        detailController.model = detailModel;

    }
    else if ([segue.identifier isEqualToString:@"createNew"])
    {
        ExpenseModel *newModel = [ExpenseModel alloc];
        
        newModel.ReportName = @"new";
        newModel.ReportTotal = 0.0;
        newModel.ExpenseType = @"Breakfast";
        newModel.ExpenseTypeId = @"BRKFT";
        ExpenseDetailViewController *detailController = segue.destinationViewController;
        detailController.Flag = @"CREATE";
        detailController.model = newModel;
    }
}

#pragma mark - viewController Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(a > 0)
    {
        [self.tableData removeAllObjects];
        [self addWaitView];
        [self performSelector:@selector(getModels) withObject:nil afterDelay:0.0];
    }
    else
        a++;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appdel = [UIApplication sharedApplication].delegate;
    a = 0;
    if(!appdel.ConcurToken)
    {
        //    Code for asking user details
        NSLog(@"Authentication Details for Concur");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Login", nil];
        alert.tag = ALERTLOGIN;
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        
        [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
        [[alert textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeDefault];
        
        [[alert textFieldAtIndex:0]setText:@"dimplebhavsar@gmail.com"];
        [[alert textFieldAtIndex:1]setText:@"dimps9211"];
        
//        [[alert textFieldAtIndex:0]setText:@"dmplbhavsar@yahoo.co.in"];
//        [[alert textFieldAtIndex:1]setText:@"Dimps9211"];

//        [[alert textFieldAtIndex:0]setText:@"sandip2451984@gmail.com"];
//        [[alert textFieldAtIndex:1]setText:@"Dimps9211"];

        [alert show];

    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - alertview Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == ALERTLOGIN)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"Authentication process starts");
            
            NSString *uname = [[alertView textFieldAtIndex:0] text];
            appdel.Cusername = uname;
            NSString *pass = [[alertView textFieldAtIndex:1] text];
            appdel.Cpassword = pass;
            if([uname isEqualToString:@""] || [pass isEqualToString:@""])
            {
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"ALERT!" message:@"Please provide username and password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                al.tag = ALERTNOUSERPASS;
                [al show];
            }
            else
                [self authenticateUser:uname :pass];
        }
    }
    else if(alertView.tag == ALERTNOUSERPASS)
    {
        
    }
}



@end
