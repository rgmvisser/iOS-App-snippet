//
//  AddSubjectTableViewCell.m
//  Timetableapp
//
//  Created by Ruud Visser on 10-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "AddSubjectTableViewCell.h"
#import "MSNetworking.h"
#import "Subject2.h"
#import "SBPickerSelector.h"
#import "UIAlertView+Blocks.h"
@interface AddSubjectTableViewCell() <SBPickerSelectorDelegate>
{
    SBPickerSelector *_classPicker;
    int _selectedIndex;
}
@end

@implementation AddSubjectTableViewCell

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
    
}

- (void)layoutSubviews{
    _selectedIndex = 0;
    
    NSMutableArray *pickerData = [self pickerData];
    _classPicker = [SBPickerSelector picker];
    _classPicker.pickerData = pickerData; //picker content
    _classPicker.pickerType = SBPickerSelectorTypeText;
    _classPicker.delegate = self;
    
    if([pickerData count] > 0){
        [self.selectClassDropDown setTitle:[pickerData objectAtIndex:0] forState:UIControlStateNormal];
    }else{
        [self.selectClassDropDown setTitle:@"" forState:UIControlStateNormal];
    }
    
    [self checkSubscribeButton];
    [super layoutSubviews];
}

- (void)refresh{
    
    _classPicker.pickerData = [self pickerData];
    [self checkSubscribeButton];
    [self.selectClassDropDown setTitle:[_classPicker.pickerData objectAtIndex:_selectedIndex] forState:UIControlStateNormal];
}

- (NSMutableArray *)pickerData
{
    NSMutableArray *pickerData = [[NSMutableArray alloc] init];
    for(Subject2 *subject in self.allSubjects){
        
        NSString *subjectName = subject.name;
        if([self.subscriptions containsObject:subject.subjectId]){
            subjectName = [subjectName stringByAppendingString:@" (Geabboneerd)"];
        }
        [pickerData addObject:subjectName];
        
    }
    return pickerData;
    
}

- (IBAction)selectClass:(id)sender {
    
    DLog(@"Select!");
    [_classPicker showPickerOver:self.delegate]; //classic picker display
}

-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx;
{
    _selectedIndex = (int)idx;
    [self.selectClassDropDown setTitle:value forState:UIControlStateNormal];
    [self checkSubscribeButton];
    
}

- (void)checkSubscribeButton
{
    Subject2 *subject = [self.allSubjects objectAtIndex:_selectedIndex];
    
    //disable button if already subscribed
    if([self.subscriptions containsObject:subject.subjectId]){
        [self.subscribeButton setEnabled:NO];
    }else{
        [self.subscribeButton setEnabled:YES];
    }
}


- (IBAction)registerForClass:(id)sender {
    
    
    [UIAlertView showWithTitle:@"" message:@"Weet je zeker dat je je wilt abonneren op dit onderwerp?" cancelButtonTitle:@"Nee" otherButtonTitles:[NSArray arrayWithObject:@"Ja"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        
        if(buttonIndex == 1){
            
            Subject2 *subject = [self.allSubjects objectAtIndex:_selectedIndex];
            [self.delegate addSubject:subject sender:self];
            DLog(@"Subj: %@",subject);
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
