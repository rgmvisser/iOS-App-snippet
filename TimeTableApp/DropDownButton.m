//
//  DropDownButton.m
//  Timetable
//
//  Created by Ruud Visser on 01-07-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "DropDownButton.h"

@implementation DropDownButton

- (void)commonDropDownInit
{
    
    self.layer.cornerRadius=0.0f;
    self.layer.masksToBounds=YES;
    self.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.layer.borderWidth= 1.0f;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.frame.size.width - 20, 0, 0);
    
    [self setImage:[UIImage imageNamed:@"arrow_down_gray"] forState:UIControlStateNormal];
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
        [self commonDropDownInit];
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
