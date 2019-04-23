//
//  NotesViewController.m
//  DriveBy
//
//  Created by Mac on 3/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "NotesViewController.h"

@interface NotesViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView.text = [self.dwelling valueForKey:@"dwellingNotes"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveBtn:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    [self.dwelling setValue:self.textView.text forKey:@"dwellingNotes"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        [self showAlertMsg:[NSString stringWithFormat:@"Error saving notes! %@ %@",error, [error localizedDescription]]];
    }
    else{
        [self showAlertMsg:@"Notes saved successfully"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
