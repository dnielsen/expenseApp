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

#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"

#import "ExpenseModel.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"

#define prototypeName @"expenses"

@interface ExpenseListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

//@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSMutableArray *tableData;


@end

@implementation ExpenseListViewController


- (IBAction)actionCreateNewExpense:(id)sender {
    [ self createNewModel];
}

- (IBAction)actionRefereshExpenseList:(id)sender {
    [self getModels];
}

- (NSArray *) tableData
{
    if ( !_tableData) _tableData = [[NSMutableArray alloc] init];//_tableData = [[NSArray alloc] init];
    return _tableData;
};

- ( void ) getModels
{
    
};

- ( void ) createNewModel
{
    
    //ExpenseModel *newModel = [[ExpenseModel alloc] initWithAttributes:@{"name": "new expense"}];
    ExpenseModel *newModel = [ExpenseModel alloc];
    
    newModel.name = @"new";
    newModel.amount = @0.0;
    
    [ [self tableData] addObject:newModel];
    [ [self myTableView] reloadData];

};

- ( void ) updateExistingModel
{
  
}//end updateExistingModelAndPushToServer

- ( void ) deleteExistingModel
{

}//end deleteExistingModel

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
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ $ %@", [model name], [model amount] ];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        
        NSInteger row = [[self myTableView].indexPathForSelectedRow row];
        ExpenseModel *rowObject = [[self tableData] objectAtIndex:row];
        
        ExpenseDetailViewController *detailController = segue.destinationViewController;
        detailController.model = rowObject;
        
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [ [self myTableView] reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getModels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
