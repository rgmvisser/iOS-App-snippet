//
//  ZoekEnBoekViewController.m
//  Timetable
//
//  Created by Mark Ramakers on 16/06/14.
//  Copyright (c) 2014 Dockbite. All rights reserved.
//

#import "ZoekEnBoekViewController.h"
#import "VrijeLokalenViewController.h"
#import "AppSettings.h"
#import "SBPickerSelector.h"
#import "DropDownButton.h"
#import "MSButton.h"
#import "SearchableObject.h"
#import "LocationType.h"
#import "Location.h"
#import "NSDateFormatter+Locale.h"

@interface ZoekEnBoekViewController () <UIScrollViewDelegate,SBPickerSelectorDelegate>
{
    BOOL _extrasVisible;
    CGRect _initialFrameSizeScrollView;
    NSDate *_currentDate;
    SBPickerSelector *_datePicker;
    SBPickerSelector *_locationPicker;
    NSArray *_searchableObjects;
    NSMutableArray *_selectedObjects;
    BOOL _onlyFreeRooms;
    BOOL _specifickLocation;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *extrasScrollView;
@property (weak, nonatomic) IBOutlet UIButton *toggleExtrasButton;
@property (weak, nonatomic) IBOutlet DropDownButton *selectDateDropDown;
@property (weak, nonatomic) IBOutlet DropDownButton *selectHourDropDown;
@property (weak, nonatomic) IBOutlet DropDownButton *selectMinutesDropDown;

@end

@implementation ZoekEnBoekViewController

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
    _specifickLocation = 0;
    _onlyFreeRooms = YES;
    _extrasVisible = YES;
    _initialFrameSizeScrollView = self.extrasScrollView.frame;
    [self.toggleExtrasButton setTransform:CGAffineTransformRotate(CGAffineTransformIdentity,
                                                                  RADIANSFROMDEGREE(180))];
    
    
    _datePicker = [SBPickerSelector picker];
    _datePicker.pickerType = SBPickerSelectorTypeDate; //select date(needs implements delegate methid with date)
    _datePicker.onlyDayPicker = NO;  //if i want select only year, month and day, without hour (default NO)
    //_datePicker.datePickerType = SBPickerSelectorDateTypeOnlyDay; //type of date picker (complete, only day, only hour)
    _datePicker.delegate = self;
    
    _locationPicker = [SBPickerSelector picker];
    _locationPicker.pickerType = SBPickerSelectorTypeText;
    _locationPicker.delegate = self;
    [self setLocationsForPicker];
    
    
    //select current time 
    [self selectNow:self];
    _selectedObjects = [[NSMutableArray alloc] init];
    NSMutableArray *objects = [SearchableObject getAllAvailableObjects];
    NSMutableArray *locationTypes = [LocationType getAllAvailableObjects];
    _searchableObjects = [objects arrayByAddingObjectsFromArray:locationTypes];
    
    int y = 5;
    int x = 20;
    int i = 0;
    for (TimetableManagedObject *searchableObject in _searchableObjects) {

        
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
        [objectButton addTarget:self action:@selector(CheckboxButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.extrasScrollView addSubview:objectButton];
        i++;
    }
    [self.extrasScrollView setContentSize:CGSizeMake(320, y+32)];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)setLocationsForPicker
{
    NSArray *locations = [Location allObjectsOrderByID];
    NSMutableArray *pickerLocations = [[NSMutableArray alloc] init];
    for(Location *location in locations){
        
        [pickerLocations addObject:location.value];
        
    }
    _locationPicker.pickerData = pickerLocations;
    
    
}

- (IBAction)toggleExtras:(id)sender {
    
    if(_extrasVisible){
        
        [UIView animateWithDuration:0.4 animations:^{
           
            [self.toggleExtrasButton setTransform:CGAffineTransformRotate(CGAffineTransformIdentity,
                                                                          RADIANSFROMDEGREE(0))];
            [self.extrasScrollView setFrame:CGRectMake(_initialFrameSizeScrollView.origin.x, _initialFrameSizeScrollView.origin.y, _initialFrameSizeScrollView.size.width, 0)];
            

        } completion:^(BOOL finished) {
            
            _extrasVisible = NO;
            
        }];
    }else{
        
        [UIView animateWithDuration:0.4 animations:^{
            
            [self.toggleExtrasButton setTransform:CGAffineTransformRotate(CGAffineTransformIdentity,
                                                                          RADIANSFROMDEGREE(180))];
            [self.extrasScrollView setFrame:_initialFrameSizeScrollView];
            
        } completion:^(BOOL finished) {
            
            _extrasVisible = YES;
            
        }];
        
    }
    
}
//if your picker is a date selection
-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date;
{
    if(selector == _datePicker){
        //date
        _currentDate = date;
        [self updateButtonsWithDate:date];
    }
}

- (void)SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx
{
    if(selector == _locationPicker){
        [self.locationPickButton setTitle:value forState:UIControlStateNormal];
    }
}



- (void)updateButtonsWithDate:(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc] initWithLocale];
    [df setDateFormat:@"HH"];
    NSString *hours = [df stringFromDate:date];
    [df setDateFormat:@"mm"];
    NSString *minutes = [df stringFromDate:date];
    [df setDateFormat:@"EEE, d MMM"];
    NSString *day = [df stringFromDate:date];
    
    [self.selectDateDropDown setTitle:day forState:UIControlStateNormal];
    [self.selectHourDropDown setTitle:hours forState:UIControlStateNormal];
    [self.selectMinutesDropDown setTitle:minutes forState:UIControlStateNormal];
}

- (IBAction)selectNow:(id)sender {
    
    _currentDate = [NSDate date];
    [self updateButtonsWithDate: _currentDate];
}

- (IBAction)selectDate:(id)sender {
    [_datePicker setDefaultDate:_currentDate];
    [_datePicker showPickerOver:self]; //classic picker display
}

- (IBAction)selectHours:(id)sender {
    [_datePicker setDefaultDate:_currentDate];
    [_datePicker showPickerOver:self]; //classic picker display
}

- (IBAction)selectMinutes:(id)sender {
    [_datePicker setDefaultDate:_currentDate];
    [_datePicker showPickerOver:self]; //classic picker display
}

- (IBAction)selectLocation:(id)sender {
    
    [_locationPicker showPickerOver:self];
    
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

- (IBAction)CheckboxButtonPressed:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSInteger tag = button.tag;
    [button setSelected:!button.isSelected];
    
    TimetableManagedObject *searchableObject = [_searchableObjects objectAtIndex:tag];
    if(![_selectedObjects containsObject:searchableObject])
    {
        [_selectedObjects addObject:searchableObject];
    }else{
        [_selectedObjects removeObject:searchableObject];
    }
    DLog(@"Current selected: %@",_selectedObjects);
    
}

- (IBAction)radioButtonPressed:(id)sender {
    if(sender == self.vrijeLokalenRadioButton){
        if (![sender isSelected]) {
            DLog(@"vrijelokalen");
            _onlyFreeRooms = YES;
            _specifickLocation = NO;
            [self.vrijeLokalenRadioButton setSelected:YES];
            [self.alleLokalenRadioButton setSelected:NO];
        }
    }else if (sender == self.alleLokalenRadioButton){
        if(![sender isSelected]){
            DLog(@"alle lokalen");
            _onlyFreeRooms = NO;
            _specifickLocation = NO;
            [self.alleLokalenRadioButton setSelected:YES];
            [self.vrijeLokalenRadioButton setSelected:NO];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"searchRoom"]){
        
        VrijeLokalenViewController *vlvc = (VrijeLokalenViewController *)segue.destinationViewController;
        vlvc.showOnlyFreeRooms = [NSNumber numberWithBool:_onlyFreeRooms];
        vlvc.selectedDate = _currentDate;
        vlvc.selectedObjects = _searchableObjects;
        
    }
    
    
}

@end
