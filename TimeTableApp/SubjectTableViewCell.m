//
//  SubjectTableViewCell.m
//  TimetableApp
//
//  Created by Ruud Visser on 07-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "SubjectTableViewCell.h"
#import "UIAlertView+Blocks.h"
@implementation SubjectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSubject:(Subject2 *)subject{
    _subject = subject;
    [self.subjectName setText:subject.name];
}

- (IBAction)cancelSubject:(id)sender {
    [UIAlertView showWithTitle:@"" message:@"Weet je zeker dat je je wilt afmelden?" cancelButtonTitle:@"Nee" otherButtonTitles:[NSArray arrayWithObject:@"Ja"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        
        if(buttonIndex == 1){
            
            [self.delegate cancelSubject:self.subject sender:self];
        }
    }];
    
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
