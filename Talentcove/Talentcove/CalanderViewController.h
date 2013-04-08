//
//  ViewController.h
//  Talentcove
//
//  Created by Apple on 01/04/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>



@interface CalanderViewController : UIViewController< UITableViewDelegate,UITableViewDataSource>
{
    
    EKEventStore *eventStore;
    EKEvent *event;
    EKEventViewController *detailViewController;
    NSMutableArray *eventsList;
    
    //To save event data for the given date.
    NSMutableDictionary *eventDataForDate;
    
    UIActivityIndicatorView *headerActivityIndicator;
    UIActivityIndicatorView *footerActivityIndicator;
    
    BOOL isCurrentEventDotDisplayed;
    BOOL isNextEventDotDisplayed;
    
    //Check if dragging is done by user and not automatically dragged on table view data load.
    BOOL draggingEnabled;
}

@property (strong, nonatomic) IBOutlet UITableView *eventTable;

//To save all the data for events
@property (nonatomic, retain) NSMutableArray *eventsData;


@end
