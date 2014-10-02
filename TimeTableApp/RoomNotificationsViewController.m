//
//  RoomNotificationsViewController.m
//  Timetableapp
//
//  Created by Ruud Visser on 11-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "RoomNotificationsViewController.h"
#import "RoomAlert.h"
#import "SBPickerSelector.h"
#import "UIAlertView+Blocks.h"
#import "MSNetworking.h"
@interface RoomNotificationsViewController () <SBPickerSelectorDelegate, UITextViewDelegate>
{
    NSArray *_roomAlerts;
    int _selectedIndex;
    SBPickerSelector *_alertPicker;
    BOOL _firstTimeEditRemarkField;
}


@end

@implementation RoomNotificationsViewController

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
    // Do any additional setup after loading the view.
    _roomAlerts = [RoomAlert allObjects];
    _firstTimeEditRemarkField = YES;
    self.remarkTextfield.delegate = self;
    _selectedIndex = 0;
    
    NSMutableArray *pickerData = [self pickerData];
    _alertPicker = [SBPickerSelector picker];
    _alertPicker.pickerData = pickerData; //picker content
    _alertPicker.pickerType = SBPickerSelectorTypeText;
    _alertPicker.delegate = self;
    
    if([pickerData count] > 0){
        [self.notificationDropdown setTitle:[pickerData objectAtIndex:0] forState:UIControlStateNormal];
    }else{
        [self.notificationDropdown setTitle:@"" forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *gestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    gestureRecogniser.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gestureRecogniser];
    
}



- (NSMutableArray *)pickerData
{
    NSMutableArray *pickerData = [[NSMutableArray alloc] init];
    //@TODO change in notification
    for(RoomAlert *roomAlert in _roomAlerts){
        
        [pickerData addObject:roomAlert.name];
        
    }
    return pickerData;
    
}

- (IBAction)selectAlert:(id)sender {
    
    DLog(@"Select!");
    [self.remarkTextfield resignFirstResponder];
    [_alertPicker showPickerOver:self.parentViewController]; //classic picker display
}

- (void)SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{
    
    _selectedIndex = (int)idx;
    [self.notificationDropdown setTitle:value forState:UIControlStateNormal];
    
}

- (IBAction)sendAlert:(id)sender {
    [self.remarkTextfield resignFirstResponder];
    [UIAlertView showWithTitle:@"" message:@"Weet je zeker dat je melding wilt maken?" cancelButtonTitle:@"Nee" otherButtonTitles:[NSArray arrayWithObject:@"Ja"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        
        if(buttonIndex == 1){
            RoomAlert *alert = [_roomAlerts objectAtIndex:_selectedIndex];
            NSString *remark = @"";
            if(!_firstTimeEditRemarkField){
                remark = self.remarkTextfield.text;
            }
            [[MSNetworking sharedMSClient] alert:alert.alertId withMessage:remark withSuccess:^{
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Melding is gemaakt." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
        }
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if(_firstTimeEditRemarkField){
        [textView setText:@""];
        _firstTimeEditRemarkField = NO;
    }
}

- (void)hideKeyboard:(UIGestureRecognizer*)tap {
    [self.remarkTextfield resignFirstResponder];
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
