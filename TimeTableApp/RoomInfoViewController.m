//
//  RoomInfoViewController.m
//  Timetableapp
//
//  Created by Ruud Visser on 11-09-14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "RoomInfoViewController.h"
#import "Room2.h"
#import "MSButton.h"
@interface RoomInfoViewController ()
{
    Room2 *_room2;
}

@end

@implementation RoomInfoViewController

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
    [self.roomDescription setText:_room2.roomDescription];
    if(_room2.locationName){
        [self.roomLocation setText:_room2.locationName];
    }else{
        [self.roomLocation setText:@"Geen locatie beschikbaar"];
    }
    [self setExtraOptions];
}

- (void)setRoom:(Room *)room
{
    _room = room;
    _room2 = (Room2 *)[Room2 objectWithId:room.roomId];
    
    
}

- (void)setExtraOptions
{
    NSArray *objects = [_room2.objects allObjects];
    
    int y = 5;
    int x = 20;
    int i = 0;
    for (SearchableObject *searchableObject in objects) {
        
        
        if(i != 0){
            if(i % 2){
                x = 160;
            }else{
                x = 20;
                y = y+32;
            }
        }
        DLog(@"%d \t %d \t %d \t %d", x, y, 140, 24);
        MSButton *objectButton = [[MSButton alloc] initWithFrame:CGRectMake(x, y, 140, 24)];
        
        [objectButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [objectButton setTitle:searchableObject.description forState:UIControlStateNormal];
        [objectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [objectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [objectButton setImage:[UIImage imageNamed:@"checkbox_bg"] forState:UIControlStateNormal];
        [objectButton setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
        objectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [objectButton setTag:i];
        [objectButton setSelected:YES];
        [self.extraScrollview addSubview:objectButton];
        i++;
    }
    [self.extraScrollview setContentSize:CGSizeMake(320, y+32)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
