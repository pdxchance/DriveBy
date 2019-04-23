//
//  ContactViewController.m
//  DriveBy
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *lastContactedLabel;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;




@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Contact";
    
    self.nameTextField.text = [self.dwelling valueForKey:@"dwellingContactName"];
    self.phoneNumberTextField.text = [self.dwelling valueForKey:@"dwellingContactPhoneNumber"];
    self.emailTextField.text = [self.dwelling valueForKey:@"dwellingContactEmail"];
    self.lastContactedLabel.text = [self.dwelling valueForKey:@"dwellingContactLastContacted"];
    self.notesTextField.text = [self.dwelling valueForKey:@"dwellingContactNotes"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //Set self to start observing for keyboard show/hide notifications.

 }

-(void)viewWillDisappear:(BOOL)animated{

}

#pragma mark - Textfield Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"dateTimePickerViewSegue"]) {
        DateTimePickerViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


-(void)dateTimeReady:(NSString*)data{
    
    self.lastContactedLabel.text = data;
    
}
- (IBAction)saveBtn:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    [self.dwelling setValue:self.nameTextField.text forKey:@"dwellingContactName"];
    [self.dwelling setValue:self.phoneNumberTextField.text forKey:@"dwellingContactPhoneNumber"];
    [self.dwelling setValue:self.emailTextField.text forKey:@"dwellingContactEmail"];
    [self.dwelling setValue:self.lastContactedLabel.text forKey:@"dwellingContactLastContacted"];
    [self.dwelling setValue:self.notesTextField.text forKey:@"dwellingContactNotes"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        [self showAlertMsg:[NSString stringWithFormat:@"Error saving contact! %@ %@",error, [error localizedDescription]]];
    }
    else{
        [self showAlertMsg:@"Contact saved successfully"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)callBtn:(id)sender {
    
    NSString *phoneNumber = [@"tel://" stringByAppendingString:self.phoneNumberTextField.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}
- (IBAction)textMsgBtn:(id)sender {
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"";
        controller.recipients = [NSArray arrayWithObjects:self.phoneNumberTextField.text, nil];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case MessageComposeResultFailed:
            [self showAlertMsg:@"Error sending SMS"];
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case MessageComposeResultSent:
            [self showAlertMsg:@"SMS sent successfully"];
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)sendEmailBtn:(id)sender {
    
    // Email Subject
    NSString *emailTitle = @"";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:self.emailTextField.text];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            [self showAlertMsg:@"Draft saved"];
             break;
        case MFMailComposeResultSent:
            [self showAlertMsg:@"Mail successfully sent"];
            break;
        case MFMailComposeResultFailed:
            [self showAlertMsg:[NSString stringWithFormat:@"Mail send failure: %@",[error localizedDescription]]];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Core Data
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)showAlertMsg:(NSString*)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DriveBy" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
}


@end
