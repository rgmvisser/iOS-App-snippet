//
//  MSLabel.m
//  Timetable
//
//  Created by Ruud Visser on 30-06-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "MSLabel.h"
#import "AppSettings.h"
@implementation MSLabel

- (void)commonInit
{
    CGFloat fontSize = self.font.pointSize;
    UIFontDescriptor *fontDescriptor = self.font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold);
    
    if(!isBold){
        [self setFont:[[AppSettings sharedInstance] regularFontWithFontSize:fontSize]];
    }else{
        [self setFont:[[AppSettings sharedInstance] boldFontWithFontSize:fontSize]];
    }
    
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
