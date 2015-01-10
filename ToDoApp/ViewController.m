//
//  ViewController.m
//  Deadlines
//
//  Created by Shiv Sakhuja on 1/7/15.
//  Copyright (c) 2015 Shiv Sakhuja. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "CompletedCustomCell.h"
#import "UMTableViewCell.h"

@interface ViewController ()

@property NSDate *choice;
@property NSUserDefaults *defaults;

@end

@implementation ViewController

@synthesize tasksToDo, datePicker, choice, tasksDone, defaults;

int contactType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    NSLog(@"%@", [defaults objectForKey:@"toDoList"]);
    
    tasksToDo = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"toDoList"]];
    tasksDone = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"doneList"]];
    
    
    [self initialPositions:nil];

    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EEEE"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd"];

    currentDayLabel.text = [[dayFormatter stringFromDate:[NSDate date]] uppercaseString];
    currentDateLabel.text = [[dateFormatter stringFromDate:[NSDate date]] uppercaseString];
    coverImageView.image = [UIImage imageNamed:@"nyc.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)returnKeyPressed:(id)sender {
    
    [sender resignFirstResponder];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:toDoTableView]) {
        return 1;
    }
    else if ([tableView isEqual:completedTableView]) {
        return 1;
    }
    else {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:toDoTableView]) {
        return [tasksToDo count];;
    }
    else if ([tableView isEqual:completedTableView]) {
        return [tasksDone count];
    }
    else {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:toDoTableView]) {
        
        //Cell
        static NSString *simpleIdentifier = @"Cell";
        
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentifier];
        if (cell == nil) {
            cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
        }
        
        NSString *cellTitle = [[tasksToDo objectAtIndex:indexPath.row] objectAtIndex:0];
        NSString *dateText = [NSDateFormatter localizedStringFromDate:[[tasksToDo objectAtIndex:indexPath.row] objectAtIndex:1] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    
        cell.title.text = cellTitle;
        cell.deadline.text = dateText;
        
        [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:100.0f];
    
        BOOL isEmailTask = [cell.title.text containsString:@"Email"] || [cell.title.text containsString:@"email"];
        BOOL isMessageTask = [cell.title.text containsString:@"Message"] || [cell.title.text containsString:@"message"]
                            || [cell.title.text containsString:@"SMS"] || [cell.title.text containsString:@"iMessage"];
        BOOL isCallTask = [cell.title.text containsString:@"Call"] || [cell.title.text containsString:@"call"];
        
        if (isEmailTask) {
            cell.emailButton.hidden = NO;
            cell.emailButton.frame = CGRectMake(self.view.frame.size.width-50, 25, 30, 20);
        }
        else if (isMessageTask) {
            cell.messageButton.hidden = NO;
            cell.messageButton.frame = CGRectMake(self.view.frame.size.width-50, 22, 30, 24);
        }
        else if (isCallTask) {
            cell.callButton.hidden = NO;
            cell.callButton.frame = CGRectMake(self.view.frame.size.width-50, 25, 17, 24);
        }
        else {
            cell.callButton.hidden = YES;
            cell.messageButton.hidden = YES;
            cell.emailButton.hidden = YES;
        }
        cell.delegate = self;
        
        return cell;
    
    }
    else if ([tableView isEqual:completedTableView]) {
        
        //Completed Cell
        
        static NSString *simpleIdentifier = @"CompletedCell";
        
        CompletedCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentifier];
        if (cell == nil) {
            cell = [[CompletedCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
        }
        
        NSString *cellTitle = [[tasksDone objectAtIndex:indexPath.row] objectAtIndex:0];
        NSString *dateText = [NSDateFormatter localizedStringFromDate:[[tasksDone objectAtIndex:indexPath.row] objectAtIndex:1] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
        
        cell.title.text = cellTitle;
        cell.dateCompleted.text = dateText;
        cell.delegate = self;
        
        return cell;
    }
    
    else {
        static NSString *simpleIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
        }
        return cell;
    }
    
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
      [UIColor colorWithRed:0.0 green:1.0 blue:0.2 alpha:1.0]
                                               title:@"Done"];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0 green:0.5 blue:0.4 alpha:1.0]
                                                title:@"Extend"];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.8 green:0.3 blue:0.5 alpha:1.0]
                                               title:@"Assign"];
    
    return leftUtilityButtons;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:toDoTableView]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [tasksToDo removeObjectAtIndex:indexPath.row];
            [toDoTableView reloadData];
        }
    }
    else if ([tableView isEqual:completedTableView]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [tasksDone removeObjectAtIndex:indexPath.row];
            [completedTableView reloadData];
        }
    }
    else {
        
    }
}

-(IBAction)addButton:(id)sender {
    
    addViewBackground.hidden = NO;
    
    CGRect frame_addView = addView.frame;
    frame_addView.origin.x = (self.view.frame.size.width - frame_addView.size.width)/2;
    frame_addView.origin.y = (self.view.frame.size.height - frame_addView.size.height)/2;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    addView.frame = frame_addView;
    
    [UIView commitAnimations];
    
    taskTextField.text = [NSString stringWithFormat:@""];
}

-(IBAction)cancelButton:(id)sender {
    CGRect frame_addView = addView.frame;
    frame_addView.origin.x = (self.view.frame.size.width - frame_addView.size.width)/2;
    frame_addView.origin.y = self.view.frame.size.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    addView.frame = frame_addView;
    
    [UIView commitAnimations];
    
    addViewBackground.hidden = YES;
    
    [self returnKeyPressed:nil];
}

-(IBAction)showCompleted:(id)sender {
    
    completedViewBackground.hidden = NO;
    
    CGRect frame_completedView = completedView.frame;
    frame_completedView.origin.x = (self.view.frame.size.width - frame_completedView.size.width)/2;
    frame_completedView.origin.y = (self.view.frame.size.height - frame_completedView.size.height)/2;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    completedView.frame = frame_completedView;
    
    [UIView commitAnimations];
    
    [completedTableView reloadData];

}

-(IBAction)hideCompleted:(id)sender {
    
    completedViewBackground.hidden = YES;
    
    CGRect frame_completedView = completedView.frame;
    frame_completedView.origin.x = (self.view.frame.size.width - frame_completedView.size.width)/2;
    frame_completedView.origin.y = self.view.frame.size.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    completedView.frame = frame_completedView;
    
    [UIView commitAnimations];
    
}

-(IBAction)initialPositions:(id)sender {
    CALayer *addViewLayer = addView.layer;
    addViewLayer.cornerRadius = 15;
    addViewLayer.shadowColor = [[UIColor blackColor] CGColor];
    addViewLayer.shadowRadius = 3.0f;
    addViewLayer.shadowOpacity = 1.0f;
    addViewLayer.shadowOffset = CGSizeMake(1.0, 1.0);
    addViewLayer.masksToBounds = NO;
    
    CALayer *completedViewLayer = completedView.layer;
    completedViewLayer.cornerRadius = 15;
    completedViewLayer.shadowColor = [[UIColor blackColor] CGColor];
    completedViewLayer.shadowRadius = 3.0f;
    completedViewLayer.shadowOpacity = 1.0f;
    completedViewLayer.shadowOffset = CGSizeMake(1.0, 1.0);
    completedViewLayer.masksToBounds = NO;
    
    completedViewBackground.hidden = YES;
    addViewBackground.hidden = YES;
    
    CGRect frame_addView = addView.frame;
    CGRect frame_completedView = completedView.frame;
    
    frame_addView.origin.y = self.view.frame.size.height;
    frame_completedView.origin.y = self.view.frame.size.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    addView.frame = frame_addView;
    completedView.frame = frame_completedView;
    
    [UIView commitAnimations];
}

-(IBAction)addTaskToList:(id)sender {
    NSDate *currentDateTime = [NSDate date];
    choice = [datePicker date];
    
    if (taskTextField.text.length > 0 && [choice timeIntervalSinceDate:currentDateTime] >= 0) {
        NSString *taskTitle = taskTextField.text;
        
        NSMutableArray *innerArray = [[NSMutableArray alloc] initWithObjects:taskTitle, choice, nil];
        [tasksToDo addObject:innerArray];
        
        [toDoTableView reloadData];
        [self cancelButton:nil];
        
        NSLog(@"%@ to be completed by %@", taskTitle, choice);
        
        
        NSDate *notificationDate1 = [choice dateByAddingTimeInterval:-86400]; //One Day earlier
        NSDate *notificationDate2 = [choice dateByAddingTimeInterval:-7200]; //Two Hours earlier
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        [notification setFireDate:notificationDate1];
        [notification setAlertBody:[NSString stringWithFormat:@"You have 24 hours to finish %@", taskTitle]];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        UILocalNotification *notification2 = [[UILocalNotification alloc] init];
        [notification2 setFireDate:notificationDate2];
        [notification2 setAlertBody:[NSString stringWithFormat:@"You have 2 hours to finish %@", taskTitle]];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification2];
        
    }
    
    else if (taskTextField.text.length <= 0) {
        UIAlertView *noTitleAlert = [[UIAlertView alloc] initWithTitle:@"No Title!" message:@"Please enter a title for the task." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [noTitleAlert show];
    }
    
    else {
        UIAlertView *noDeadlineAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Deadline!" message:@"Deadline cannot be in the past." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [noDeadlineAlert show];
    }
    
    [self saveData];
}

-(void)saveData {
    
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:tasksToDo forKey:@"toDoList"];
    [defaults setValue:tasksDone forKey:@"doneList"];
    NSLog(@"%@", [defaults objectForKey:@"toDoList"]);
    [defaults synchronize];
}

#pragma mark - Swipe Actions

- (void)swipeableTableViewCell:(CustomCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            //Done Button
            [self taskCompleted:cell];
            break;
        case 1:
            //Extend Button
            [self extendTask:cell];
            break;
        case 2:
            //Assign Button
            [self assignTask:cell];
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            //Delete Button
            
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

-(void)taskCompleted:(CustomCell *)cell {
    NSMutableArray *innerArray = [[NSMutableArray alloc] initWithObjects:cell.title.text, [NSDate date], nil];
    [tasksDone addObject:innerArray];
    
    CGPoint cellPosition = [cell convertPoint:CGPointZero toView:toDoTableView];
    NSIndexPath *indexPath = [toDoTableView indexPathForRowAtPoint:cellPosition];
    
    [tasksToDo removeObjectAtIndex:indexPath.row];
    [toDoTableView reloadData];
    
}

-(void)extendTask:(CustomCell *)cell {
    
    CGPoint cellPosition = [cell convertPoint:CGPointZero toView:toDoTableView];
    NSIndexPath *indexPath = [toDoTableView indexPathForRowAtPoint:cellPosition];
    
    NSDate *newDate = [[[tasksToDo objectAtIndex:indexPath.row] objectAtIndex:1] dateByAddingTimeInterval:86400];
    [[tasksToDo objectAtIndex:indexPath.row] replaceObjectAtIndex:1 withObject:newDate];
    
    [toDoTableView reloadData];
    
    UIAlertView *extendedTaskAlert = [[UIAlertView alloc] initWithTitle:@"Deadline Extended" message:@"The deadline for your task has been extended by 24 Hours" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [extendedTaskAlert show];
}

-(void)assignTask:(CustomCell *)cell {
    
    CGPoint cellPosition = [cell convertPoint:CGPointZero toView:toDoTableView];
    NSIndexPath *indexPath = [toDoTableView indexPathForRowAtPoint:cellPosition];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *assignMail = [[MFMailComposeViewController alloc] init];
        assignMail.mailComposeDelegate = self;
        
        NSString *taskName = [[tasksToDo objectAtIndex:indexPath.row] objectAtIndex:0];
        NSDateFormatter *dateFormatForEmail = [[NSDateFormatter alloc] init];
        [dateFormatForEmail setDateStyle:NSDateFormatterFullStyle];
        NSString *taskDeadline = [dateFormatForEmail stringFromDate:[[tasksToDo objectAtIndex:indexPath.row] objectAtIndex:1]];
        
        [assignMail setSubject:@"Task Assigned"];
        NSString *assignMessageBody = [NSString stringWithFormat:@"You have been assigned to complete the task: %@ by the deadline %@", taskName, taskDeadline];
        [assignMail setMessageBody:assignMessageBody isHTML:NO];
        
        [self presentViewController:assignMail animated:YES completion:nil];
        
    }
}

-(IBAction)call:(id)sender {
    contactType = 0;
    
    NSLog(@"From Call Method");
    ABPeoplePickerNavigationController *contactPicker = [[ABPeoplePickerNavigationController alloc] init];
    contactPicker.peoplePickerDelegate = self;
    
    [self presentViewController:contactPicker animated:YES completion:nil];
}

-(IBAction)message:(id)sender {
    contactType = 1;
    
    ABPeoplePickerNavigationController *contactPicker = [[ABPeoplePickerNavigationController alloc] init];
    contactPicker.peoplePickerDelegate = self;
    
    [self presentViewController:contactPicker animated:YES completion:nil];
}

-(IBAction)mail:(id)sender {
    contactType = 2;
    
    ABPeoplePickerNavigationController *contactPicker = [[ABPeoplePickerNavigationController alloc] init];
    contactPicker.peoplePickerDelegate = self;
    
    [self presentViewController:contactPicker animated:YES completion:nil];
}

//Handle Address Book

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    CFRelease(phoneNumbers);

}

-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    NSString* phone = nil;
    NSString* emailID = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"";
    }
    
    if (ABMultiValueGetCount(ABRecordCopyValue(person, kABPersonEmailProperty)) > 0) {
        emailID = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex((ABRecordCopyValue(person, kABPersonEmailProperty)), 0);
    }
    else {
        emailID = @"";
    }

    if (contactType == 0) {
        
        //Call
        NSLog(@"Call Type Action Received");
        NSString *phoneNumberLink = [NSString stringWithFormat:@"tel:%@", phone];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberLink]];
        CFRelease(phoneNumbers);
    }
    else if (contactType == 1) {
        //SMS
        NSString *phoneNumberLink = [NSString stringWithFormat:@"sms:%@", phone];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberLink]];
        CFRelease(phoneNumbers);
    }
    else if (contactType == 2) {
        //Mail
        NSString *emailLink = [NSString stringWithFormat:@"mailto:%@", emailID];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailLink]];
    }
}



@end
