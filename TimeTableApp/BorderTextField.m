//
//  BorderTextField.m
//  Timetable
//
//  Created by Ruud Visser on 01-07-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "BorderTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "AppSettings.h"

@implementation BorderTextField

- (void)commonInit
{
    self.borderStyle = UITextBorderStyleNone;
    
    CGFloat fontSize = self.font.pointSize;
    [self setFont:[[AppSettings sharedInstance] regularFontWithFontSize:fontSize]];
    
    self.layer.cornerRadius=0.0f;
    self.layer.masksToBounds=YES;
    self.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.layer.borderWidth= 1.0f;
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
        [self commonInit];
    }
    return self;
    
}

// placeholder position inset
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}

// text position inset
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
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
