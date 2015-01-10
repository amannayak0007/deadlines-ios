//
//  ViewController.h
//  Deadlines
//
//  Created by Shiv Sakhuja on 1/7/15.
//  Copyright (c) 2015 Shiv Sakhuja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, ABPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    
    IBOutlet UITableView *toDoTableView;
    IBOutlet UITableView *completedTableView;
    
    IBOutlet UIDatePicker *datePicker;
    
    IBOutlet UITextField *taskTextField;
    IBOutlet UIView *addView;
    IBOutlet UIView *addViewBackground;
    
    IBOutlet UIView *completedView;
    IBOutlet UIView *completedViewBackground;
    
    IBOutlet UIImageView *coverImageView;
    IBOutlet UILabel *currentDateLabel;
    IBOutlet UILabel *currentDayLabel;
    
}

@property (strong, nonatomic) NSMutableArray *tasksToDo;
@property (strong, nonatomic) NSMutableArray *tasksDone;

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

-(IBAction)chooseDate:(id)sender;
-(IBAction)addButton:(id)sender;
-(IBAction)cancelButton:(id)sender;
-(IBAction)addTaskToList:(id)sender;

-(IBAction)showCompleted:(id)sender;
-(IBAction)hideCompleted:(id)sender;

-(IBAction)call:(id)sender;
-(IBAction)mail:(id)sender;
-(IBAction)message:(id)sender;

@end