//
//  TimetableButton.m
//  Timetable
//
//  Created by Ruud Visser on 30-06-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "BlueButton.h"
#import "AppSettings.h"

@implementation BlueButton



- (void)blueButtonInit
{
    
    [self setBackgroundImage:[UIImage imageNamed:@"bt_background"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"bt_background_pressed"] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageNamed:@"bt_background_pressed"] forState:UIControlStateHighlighted];
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if ((self = [super initWithCoder:aDecoder])) {
        [self blueButtonInit];
    }
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
