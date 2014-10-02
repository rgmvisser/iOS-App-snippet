//
//  BoekenBevestigenViewController.m
//  Timetable
//
//  Created by Mark Ramakers on 20/06/14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "BoekenBevestigenViewController.h"
#import "SBPickerSelector.h"
#import "DropDownButton.h"
#import "AppSettings.h"
#import "MSLabel.h"
#import "NSDateFormatter+Locale.h"
#import "NSDate+Extras.h"
#import "MSNetworking.h"

@interface BoekenBevestigenViewController () <SBPickerSelectorDelegate,UITextViewDelegate>
{
    SBPickerSelector *_timePicker;
    CGRect _originalFrame;
    BOOL _firstTimeEditNoteField;
}
@property (weak, nonatomic) IBOutlet MSLabel *fromLabel;
@property (weak, nonatomic) IBOutlet MSLabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@end

@implementation BoekenBevestigenViewController

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
    _originalFrame = self.view.frame;
    _firstTimeEditNoteField = YES;
    
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *gestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    gestureRecogniser.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gestureRecogniser];
    
    //load in teh
    [self setTitle:[NSString stringWithFormat:@"%@ boeken",self.room]];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] initWithLocale];
    [dateFormatter setDateFormat:@"EEEE d MMMM"];
    [self.dateLabel setText:[[dateFormatter stringFromDate:self.startTime] capitalizedString]];
    [self.fromLabel setText:[NSString stringWithFormat:@"%@ uur",[NSDateFormatter timeStringFromDate:self.startTime]]];
    [self.toLabel setText:[NSString stringWithFormat:@"%@ uur",[NSDateFormatter timeStringFromDate:self.endTime]]];
    
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bookRoom:(id)sender {
    
    [[MSNetworking sharedMSClient] makeBookingForRooms:[NSArray arrayWithObject:self.room.roomId] from:self.startTime to:self.endTime withSuccess:^(NSNumber *booked) {
        if([booked boolValue]){
            
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Reservering gemaakt" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self.navigationController popViewControllerAnimated:YES];
        
        }else{
            
            [[[UIAlertView alloc] initWithTitle:@"Fout" message:@"Reservering niet gelukt" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
        }
        
    }];
    
}

- (IBAction)cancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if(_firstTimeEditNoteField){
        [textView setText:@""];
        _firstTimeEditNoteField = NO;
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        if(!IS_IPHONE5){
            self.view.frame = CGRectInset(_originalFrame, 0, -130);
        }else{
            self.view.frame = CGRectInset(_originalFrame, 0, -50);
        }
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = _originalFrame;
    }];
    
}

//hide keyboard when tapped
- (void)hideKeyboard:(UIGestureRecognizer*)tap {
    [self.notesTextView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = _originalFrame;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

