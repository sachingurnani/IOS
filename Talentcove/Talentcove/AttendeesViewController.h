//
//  Attendees.h
//  Talentcove
//
//  Created by Apple on 01/04/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "BackGroundViewController.h"

@interface AttendeesViewController : BackGroundViewController<UITableViewDelegate,UITableViewDataSource>
{
    EKEvent *event;
    NSMutableDictionary *attendees;
}

@property (nonatomic, retain) EKEvent *event;
@property (strong, nonatomic) IBOutlet UITableView *attendeesTable;
@property (strong, nonatomic) IBOutlet UIImageView *requestActionBackground;
@property (strong, nonatomic) IBOutlet UIButton *requestAction;


- (IBAction)sendRequestAction:(id)sender;
- (IBAction)backButtonClick:(id)sender;

@end
