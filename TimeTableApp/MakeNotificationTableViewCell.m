//
//  MakeNotificationTableViewCell.m
//  Timetableapp
//
//  Created by Ruud Visser on 11-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "MakeNotificationTableViewCell.h"
#import "SBPickerSelector.h"
#import "UIAlertView+Blocks.h"
#import "GeneralAlert.h"
@interface MakeNotificationTableViewCell() <SBPickerSelectorDelegate,UITextViewDelegate>
{
    SBPickerSelector *_notificationPicker;
    int _selectedIndex;
    BOOL _firstTimeEditCommentField;
}
@end

@implementation MakeNotificationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews{
    _selectedIndex = 0;
    _firstTimeEditCommentField = YES;
    NSMutableArray *pickerData = [self pickerData];
    _notificationPicker = [SBPickerSelector picker];
    _notificationPicker.pickerData = pickerData; //picker content
    _notificationPicker.pickerType = SBPickerSelectorTypeText;
    _notificationPicker.delegate = self;
    
    if([pickerData count] > 0){
        [self.selectNotification setTitle:[pickerData objectAtIndex:0] forState:UIControlStateNormal];
    }else{
        [self.selectNotification setTitle:@"" forState:UIControlStateNormal];
    }
    [super layoutSubviews];
    
    UITapGestureRecognizer *gestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    gestureRecogniser.numberOfTapsRequired = 1;
    [[[self superview] superview] addGestureRecognizer:gestureRecogniser];
    
}

- (NSMutableArray *)pickerData
{
    NSMutableArray *pickerData = [[NSMutableArray alloc] init];
    //@TODO change in notification
    for(GeneralAlert *alert in self.allNotifications){
        
        [pickerData addObject:alert.name];
        
    }
    return pickerData;
    
}

- (IBAction)selectNotification:(id)sender {
    
    DLog(@"Select!");
    [self.commentsTextview resignFirstResponder];
    [_notificationPicker showPickerOver:self.delegate]; //classic picker display
}

- (void)SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx
{
    _selectedIndex = (int)idx;
    [self.selectNotification setTitle:value forState:UIControlStateNormal];
}

- (IBAction)sendNotification:(id)sender {
    
    
    [UIAlertView showWithTitle:@"" message:@"Weet je zeker dat je melding wilt maken?" cancelButtonTitle:@"Nee" otherButtonTitles:[NSArray arrayWithObject:@"Ja"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        
        if(buttonIndex == 1){
            
            GeneralAlert *alert = [self.allNotifications objectAtIndex:_selectedIndex];
            NSString *comment = @"";
            if(!_firstTimeEditCommentField){
                comment = self.commentsTextview.text;
            }
            [self.delegate notify:alert withComment:comment];
        }
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if(_firstTimeEditCommentField){
        [textView setText:@""];
        _firstTimeEditCommentField = NO;
    }
}

- (void)hideKeyboard:(UIGestureRecognizer*)tap {
    [self.commentsTextview resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
