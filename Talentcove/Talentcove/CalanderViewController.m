
#define TABLEVIEW_PAGE_SIZE 10
#define TABLEVIEW_CELL_HEIGHT 35.0

#import "CalanderViewController.h"
#import "AttendeesViewController.h"
#import "Global.h"

@interface CalanderViewController ()

@end

@implementation CalanderViewController

@synthesize eventsData,eventTable;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    eventStore = [[EKEventStore alloc] init];
    eventsList = [[NSMutableArray alloc] initWithArray:0];
    self.eventsData = [[NSMutableArray alloc] init];
    
    isNextEventDotDisplayed = FALSE;
    draggingEnabled = FALSE;
    
    //set header and footer to show the animation while loading data
    [self setTableViewHeaderAndFooter];
    
    // Adding Navigation Bar background image
    UIImage *image = [UIImage imageNamed:@"header.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    [titleView setFont:[UIFont fontWithName:BoldFont size:20]];
    [titleView setShadowColor:UIColorFromRGB(0x008678)];
    self.navigationItem.titleView = titleView;
    
    
    //Ask for permission to access Calender events.
    if([eventStore respondsToSelector:
        @selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [eventStore
         requestAccessToEntityType:EKEntityTypeEvent
         completion:^(BOOL granted, NSError *error) {
             [self performSelectorOnMainThread:
              @selector(presentEventEditViewControllerWithEventStore:)
                                    withObject:eventStore
                                 waitUntilDone:NO];
         }];
    }else{
        [self performSelectorOnMainThread:
         @selector(presentEventEditViewControllerWithEventStore:)
                               withObject:eventStore
                            waitUntilDone:NO];
    }

     
    self.eventTable.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    //scroll up to hide the table view header.
    [self.eventTable setContentOffset:CGPointMake(0, 1*TABLEVIEW_CELL_HEIGHT)];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.eventsData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    eventsList = [[self.eventsData objectAtIndex:section] valueForKey:[[[self.eventsData objectAtIndex:section] allKeys] objectAtIndex:0]];
    return [eventsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"EventCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    

    eventsList = [[self.eventsData objectAtIndex:indexPath.section] valueForKey:[[[self.eventsData objectAtIndex:indexPath.section] allKeys] objectAtIndex:0]];
    EKEvent *eventAtIndex = [eventsList objectAtIndex:indexPath.row];
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:eventAtIndex.startDate  toDate:eventAtIndex.endDate  options:0];
    
    NSString *hourString = [[NSString stringWithFormat:@"%d", [breakdownInfo hour]] stringByAppendingString:@":"];
    hourString= [hourString stringByAppendingString:[NSString stringWithFormat:@"%d", [breakdownInfo minute]]];
    
    //Cell formatting
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:1];
    [dateLabel setFont:[UIFont fontWithName:MediumFont size:14]];
    [dateLabel setShadowColor:[UIColor whiteColor]];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
    [nameLabel setFont:[UIFont fontWithName:BoldFont size:14]];
    [nameLabel setTextColor:UIColorFromRGB(0x191919)];
    [nameLabel setShadowColor:[UIColor whiteColor]];
    
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:3];
    [timeLabel setFont:[UIFont fontWithName:MediumFont size:14]];
    [timeLabel setTextColor:UIColorFromRGB(0x8f8f8f)];
    [timeLabel setShadowColor:[UIColor whiteColor]];
    
    UIImageView *colorDotForevent = (UIImageView *)[cell viewWithTag:4];
    
        
    UIImage *image;
    
    //set image for all the other event other then current and next immediate event.
     
    if (([[NSDate date] compare: eventAtIndex.startDate]== NSOrderedAscending || ([[NSDate date] compare: eventAtIndex.startDate]== NSOrderedAscending && [[NSDate date] compare: eventAtIndex.endDate]== NSOrderedDescending)) &&  [self isCurrentDate:eventAtIndex.startDate]) {

        
         if (isCurrentEventDotDisplayed == FALSE && isNextEventDotDisplayed == FALSE) {
             //set image for current event
             image = [UIImage imageNamed:@"calander_circle_red.png"];
             isCurrentEventDotDisplayed = TRUE;
         }else if (isCurrentEventDotDisplayed == TRUE && isNextEventDotDisplayed == FALSE) {
             //set image for Next event after current event.
                  image = [UIImage imageNamed:@"calander_circle_orange.png"];
                 isNextEventDotDisplayed = TRUE;
         }else{
             //set image for all the next events.
             image = [UIImage imageNamed:@"calander_circle_ochre.png"];

         }
        
    }else if ([[NSDate date] compare: eventAtIndex.startDate] == NSOrderedDescending) {
        //Set image for past events.
        image = [UIImage imageNamed:@"calander_circle_grey.png"];
    }
    
    [colorDotForevent setImage:image];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    //Optionally for time zone converstions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:eventAtIndex.startDate];
    
    //format data to show in calendar view.
    if(eventAtIndex.allDay){
        nameLabel.text = eventAtIndex.title;
        timeLabel.text = @"";
        dateLabel.text = @"All Day";
        
    }
    else{
        nameLabel.text = eventAtIndex.title;
        dateLabel.text = stringFromDate;
        
        if([breakdownInfo hour] == 0){
            hourString= [hourString stringByAppendingString:@"m"];
            timeLabel.text =hourString;
        }
        else{
            if([breakdownInfo minute] == 0){
                hourString= [hourString stringByAppendingString:@"0h"];
                timeLabel.text =hourString;
            }
            else
            {
                hourString= [hourString stringByAppendingString:@"h"];
                timeLabel.text =hourString;
            }
            
        }
        
        
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 25;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320 , 25)];
    [imageView setImage:[UIImage imageNamed:@"calander_date_bg.png"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSDate*  eventDate = [dateFormatter dateFromString:[[[self.eventsData objectAtIndex:section] allKeys] objectAtIndex:0]];
    
    
    NSString *str = [self getSectionHeaderForDate:eventDate];
  
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, 320 , 25)];
    headerLabel.text = str;
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[UIFont fontWithName:MediumFont size:14.0]];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setShadowColor:UIColorFromRGB(0x5e5e5e)];
    headerLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    
    [imageView addSubview:headerLabel];
    return imageView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56;
}

-(void) setTableViewHeaderAndFooter{
    
    //set tableview header
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(5,5, 320 , 35)];
    headerActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 5, 29 , 35)];
    [headerActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [headerview addSubview:headerActivityIndicator];
    [[self eventTable] setTableHeaderView:headerview];
    
    //set tableview footer
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 320 , 35)];
    footerActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 5, 29 , 35)];   
    [footerActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [footerview addSubview:footerActivityIndicator];
    [[self eventTable] setTableFooterView:footerview];
    
}

#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //Check if scrolling is done by user.
    if (draggingEnabled) {

        if (([scrollView contentOffset].y + scrollView.frame.size.height) == [scrollView contentSize].height) {
            NSLog(@"scrolled to bottom");
            [footerActivityIndicator startAnimating];
            [self performSelector:@selector(stopAnimatingFooter) withObject:nil afterDelay:0.2];
            return;
        }
        if ([scrollView contentOffset].y == scrollView.frame.origin.y ) {
            NSLog(@"scrolled to top");
            [headerActivityIndicator startAnimating];
            [self performSelector:@selector(stopAnimatingHeader) withObject:nil afterDelay:0.2];
        }
    }

}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    draggingEnabled = TRUE;
}

//stop the header spinner
- (void) stopAnimatingHeader{
    //add the data
    [headerActivityIndicator stopAnimating];
    [self addItemsToStartOfTableView];
    
    //set an offset so visible cells aren't blasted
   // [self.eventTable setContentOffset:CGPointMake(0, TABLEVIEW_PAGE_SIZE*TABLEVIEW_CELL_HEIGHT)];
    [self.eventTable setContentOffset:CGPointMake(0, 1*TABLEVIEW_CELL_HEIGHT)];
    
    isCurrentEventDotDisplayed = FALSE;
    isNextEventDotDisplayed = FALSE;
    [[self eventTable] reloadData];
    
  
}

//stop the footer spinner
- (void) stopAnimatingFooter{
    //add the data
    [footerActivityIndicator stopAnimating];
    [self addItemsToEndOfTableView];
    
    isCurrentEventDotDisplayed = FALSE;
    isNextEventDotDisplayed = FALSE;
    [[self eventTable] reloadData];
    
   
}

- (void) addItemsToEndOfTableView{
    [self fetchEventsForDays:7 WithFlag:YES];
}

- (void) addItemsToStartOfTableView{
    [self fetchEventsForDays:7 WithFlag:NO];
}


#pragma EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController*)controller
          didCompleteWithAction:(EKEventEditViewAction)action{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentEventEditViewControllerWithEventStore:(EKEventStore*)eventStore{
    
    //On first load get the data for first three days from Today.
    [self fetchEventsForDays:3 WithFlag:YES];
    
    isCurrentEventDotDisplayed = FALSE;
    isNextEventDotDisplayed = FALSE;
    
    [[self eventTable] reloadData];
    [self.eventTable setContentOffset:CGPointMake(0, 1*TABLEVIEW_CELL_HEIGHT)];
}

- (void)fetchEventsForDays:(NSInteger)days WithFlag:(BOOL)newEvents {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *dateTmp;
    int indexToAddDataForOLdEvents;
    int noOfDaysToGetEvents;
    
    noOfDaysToGetEvents = days;
    
    if ([self.eventsData count] > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if (newEvents) {
            //if loading new data get the next date.
            dateTmp = [dateFormatter dateFromString:[[[self.eventsData objectAtIndex:[self.eventsData count] - 1] allKeys] objectAtIndex:0]];
            dateTmp = [dateTmp dateByAddingTimeInterval:24 * 3600];
        }else{
            //if loading old events get the date of 7th date before first date in table view.
            dateTmp = [dateFormatter dateFromString:[[[self.eventsData objectAtIndex:0] allKeys] objectAtIndex:0]];
            dateTmp = [dateTmp dateByAddingTimeInterval:-7 * 24 * 3600];
            //variable to check no of dates on which event exist to add data on index in events array.
            indexToAddDataForOLdEvents = 0;
        }
    }
    
    //Loop for getting events for all the dates.
    for (int count = 0; count < noOfDaysToGetEvents; count++) {
        
        NSDateComponents *dayComponents = [[NSDateComponents alloc] init];
        dayComponents.day = count;
        
        NSDate *startDate;
        if (dateTmp == NULL ) {
            startDate = [calendar dateByAddingComponents:dayComponents toDate:[NSDate date] options:0];
        }else{
            startDate = [calendar dateByAddingComponents:dayComponents toDate:dateTmp options:0];
        }
        
        //Get start and end date of a date to fetch the events for whole Day.
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *weekdayComponents = [gregorian
                                               components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:startDate];
        weekdayComponents.hour = 00;
        NSDate *startDateToGetEvent = [gregorian dateFromComponents:weekdayComponents];
        
        NSTimeInterval secondsInHours = 24 * 3600;
        NSDate *endDateToGetEvent = [startDateToGetEvent dateByAddingTimeInterval:secondsInHours];
        
        // Create the predicate from the event store's instance method
        NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDateToGetEvent
                                                                     endDate:endDateToGetEvent
                                                                   calendars:nil];
        // Fetch all events that match the predicate
        NSArray *events = [eventStore eventsMatchingPredicate:predicate];
        
        if ([events count] > 0) {
            EKEvent *eventAtIndex = [events
                                     objectAtIndex:0];
            
            NSDate *date = eventAtIndex.startDate;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            
            NSString *dateString = [dateFormatter stringFromDate: date];
            eventDataForDate = [[NSMutableDictionary alloc] init];
            [eventDataForDate setValue:events forKey:dateString];
            
            if (newEvents) {
                [self.eventsData addObject:eventDataForDate];
            }else{
                [self.eventsData insertObject:eventDataForDate atIndex:indexToAddDataForOLdEvents];
                //while loading old data save the incremented index to save data next time.
                indexToAddDataForOLdEvents += 1;
            }
        }
        
        //Check if data doesn't exist for 3 days from Today then get the data of next day.
        if (count >= 2 && days == 3) {
            if ([eventsData count] < 3) {
                noOfDaysToGetEvents += 1;
            }
        }
    }
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Open next view on cell select.
    if ([segue.identifier isEqualToString:@"AttendeesDetail"]) {
        
        NSIndexPath *indexPath = [self.eventTable indexPathForSelectedRow];
        [eventTable deselectRowAtIndexPath:indexPath animated:NO];
        
        eventsList = [[self.eventsData objectAtIndex:indexPath.section] valueForKey:[[[self.eventsData objectAtIndex:indexPath.section] allKeys] objectAtIndex:0]];
        AttendeesViewController *attendeesViewController = segue.destinationViewController;
        attendeesViewController.event =  [eventsList objectAtIndex:indexPath.row];
    }
}


- (NSString*) getSectionHeaderForDate:(NSDate*) date{
    
    //Formatted section header.
    
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* componentsForCurrentDate = [calendar components:flags fromDate:[NSDate date]];
    NSDate* currentDate = [calendar dateFromComponents:componentsForCurrentDate];
    
    NSDateComponents* componentsForSectionHeader = [calendar components:flags fromDate:date];
    NSDate* dateForSectionHeader = [calendar dateFromComponents:componentsForSectionHeader];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMMM dd"];
    
    if ([currentDate isEqual:dateForSectionHeader]) {
        
        return [NSString stringWithFormat:@"%@%@", @"Today - ",[formatter stringFromDate:dateForSectionHeader]];
        
    }else if([[currentDate dateByAddingTimeInterval:24 * 60 * 60] isEqual:dateForSectionHeader]){
        
        return [NSString stringWithFormat:@"%@%@", @"Tomorrow - ",[formatter stringFromDate:dateForSectionHeader]];
    }
    else{
        
        return [formatter stringFromDate:dateForSectionHeader];
    }
}

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate{
    
    if ([date compare:beginDate] == NSOrderedAscending)
    	return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
    	return NO;
    
    return YES;
}

- (BOOL)isCurrentDate:(NSDate*)date {
    
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* componentsForCurrentDate = [calendar components:flags fromDate:[NSDate date]];
    NSDate* currentDate = [calendar dateFromComponents:componentsForCurrentDate];

    NSDateComponents* componentsForSectionHeader = [calendar components:flags fromDate:date];
    date = [calendar dateFromComponents:componentsForSectionHeader];
    
    if ([currentDate isEqual:date])
        return YES;
    
    return NO;
}




@end
