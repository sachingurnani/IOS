//
//  Attendees.m
//  Talentcove
//
//  Created by Apple on 01/04/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "AttendeesViewController.h"
#import "MeetingViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "Global.h"

@interface AttendeesViewController ()

@end

@implementation AttendeesViewController

@synthesize attendeesTable,event;
@synthesize requestAction,requestActionBackground;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    attendees = [[NSMutableDictionary alloc] init];
    [self.requestAction setTitleShadowColor:UIColorFromRGB(0xc73e00) forState:UIControlStateNormal];    
    self.attendeesTable.delegate = self;
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        
        return 1;
    }
    
    if(section == 1){
        
      return  [event.attendees count];
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if(indexPath.section == 0){
        
        static NSString *simpleTableIdentifier = @"Section1";
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        UILabel *eventLabel = (UILabel *)[cell viewWithTag:1];
        [eventLabel setFont:[UIFont fontWithName:BoldFont size:15]];
        [eventLabel setTextColor:UIColorFromRGB(0x191919)];
        [eventLabel setShadowColor:[UIColor whiteColor]];

        UILabel *dateLabel = (UILabel *)[cell viewWithTag:2];
        [dateLabel setFont:[UIFont fontWithName:RegularFont size:13]];
        [dateLabel setTextColor:UIColorFromRGB(0x7b7b7b)];
        [dateLabel setShadowColor:[UIColor whiteColor]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEEE, dd MMMM yyyy"];
        
        eventLabel.text = event.title;
        dateLabel.text =  [NSString stringWithFormat:@"%@%@", @"Today, ",[formatter stringFromDate:event.startDate]];
    }
    
    if(indexPath.section == 1){
        
        static NSString *simpleTableIdentifier = @"Section2";
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        //Get the Imageview by Tag and assign the background image.
        UIImageView *backgroundImageView = (UIImageView *)[cell viewWithTag:5];
        UIImage *image;        
        if (indexPath.row == 0) {
            image = [UIImage imageNamed:@"top_user_cell.png"];
        }else if (indexPath.row == [event.attendees count] - 1){
            image = [UIImage imageNamed:@"bottom_user_cell.png"];
        }else{
            image = [UIImage imageNamed:@"middle_user_cell.png"];
        }
        [backgroundImageView setImage:image];
        //Get the attendee label by Tag and assign the text.
        UILabel *nameLable = (UILabel *)[cell viewWithTag:3];
        
        [nameLable setFont:[UIFont fontWithName:BoldFont size:15]];
        [nameLable setTextColor:UIColorFromRGB(0x191919)];
        [nameLable setShadowColor:[UIColor whiteColor]];
        
        EKParticipant *attendee = [event.attendees objectAtIndex:indexPath.row];
        nameLable.text = [[attendee URL] absoluteString];
        
        //Add events on buttons on table view cell.
        UIButton *selectionButton = (UIButton *)[cell viewWithTag:6];
        UIButton *feedBackButton = (UIButton *)[cell viewWithTag:7];
        [selectionButton addTarget:self action:@selector(onClickedCheckMark:) forControlEvents:UIControlEventTouchUpInside];
        [feedBackButton addTarget:self action:@selector(onClickedFeedback:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //Ask for permission to access address book.
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                // First time access has been granted, add the contact
                [self assignImageAndNameDataToCell:cell];
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            // The user has previously given access, add the contact
            [self assignImageAndNameDataToCell:cell];
        }
        else {
            // The user has previously denied access
            // Send an alert telling user to change privacy setting in settings app
            if (indexPath.row == 0) {
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"" message:@"Please enable access to your contacts in privacy settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
                
                [alertView show];
            }
           
            
        }

    }
    
     return cell;
}

-(void) assignImageAndNameDataToCell : (UITableViewCell*) cell{
    
    UILabel *nameLable = (UILabel *)[cell viewWithTag:3];
    EKParticipant *attendee = [event.attendees objectAtIndex:[attendeesTable indexPathForCell:cell].row];
    //Get image and name from Contacts.
    ABAddressBookRef addressBook = ABAddressBookCreate( );
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    
    NSArray* peopleArray = [NSArray arrayWithArray:(__bridge NSArray *)(allPeople)];
    
    for (int i = 0; i<CFArrayGetCount(allPeople); i++) {
        
        ABRecordRef person = (__bridge ABRecordRef)([peopleArray objectAtIndex:i]);
        NSString *personName = [NSString stringWithFormat:@"%@ %@",
                                (__bridge NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty),
                                (__bridge NSString*)ABRecordCopyValue(person,kABPersonLastNameProperty)
                                ];
        NSData  *personImageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        UIImage *personImage = [UIImage imageWithData:personImageData];
        
        if([personName isEqualToString:[attendee name]]){
            
            nameLable.text = [NSString stringWithFormat:@"%@ %@",
                              (__bridge NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty),
                              [(__bridge NSString*)ABRecordCopyValue(person,kABPersonLastNameProperty) substringToIndex:1]
                              ];
            
            [attendees setValue:[NSNumber numberWithBool:FALSE] forKey:nameLable.text];
            
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:4];
            [imageView setImage:personImage];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 53;
    }else{
        return 68;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 1) {
        return 7.0;
    }else{
        return 6.0;

    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIImageView *imageView;
    
    if (section == 1) {
       imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320 , 7.0)];
        
   }else{
       imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320 , 6.0)];
        
    }
    
    
    [imageView setBackgroundColor:[UIColor clearColor]];
    return imageView;
    
}

- (IBAction)sendRequestAction:(id)sender {
}

- (IBAction)backButtonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onClickedCheckMark: (id) sender{
    
    // Change image check mark on click as enabled and disabled.
    // Hide and show RequestAction button afte checking all the check marks.
    UITableViewCell *cell = (UITableViewCell*) [[sender superview] superview];
    UIButton *selectionButton = [[UIButton alloc] init];
    selectionButton = sender;
    
    UILabel *nameLable = (UILabel *)[cell viewWithTag:3];
    
    UIImage *img = selectionButton.currentImage;
    UIImage *image = [UIImage imageNamed:@"checkmark-selected.png"];
    
    if(img == image){
        image = [UIImage imageNamed:@"checkmark-default.png"];
        [attendees setValue:[NSNumber numberWithBool:FALSE] forKey:nameLable.text];
    }else{
        requestAction.hidden = FALSE;
        requestActionBackground.hidden = FALSE;
        [attendees setValue:[NSNumber numberWithBool:TRUE]  forKey:nameLable.text];
    }
    
    [sender setImage:image forState:UIControlStateNormal];
    [self searchAttendeesToHideActionButton];
}

-(void) searchAttendeesToHideActionButton{
    
    for (id key in attendees)
    {
        id value = [attendees objectForKey:key];
        if ([value boolValue] == TRUE) {
            requestAction.hidden = FALSE;
            requestActionBackground.hidden = FALSE;
            return;
        }
    }
    
    requestAction.hidden = TRUE;
    requestActionBackground.hidden = TRUE;

}

- (void) onClickedFeedback: (id) sender{
 
  /*  UIButton *selectionButton = [[UIButton alloc] init];
    selectionButton = sender;
    
    UIImage *img = selectionButton.currentImage;
    UIImage *image = [UIImage imageNamed:@"feedback_ic_selected.png"];
    
    if(img != image){
        
        image = [UIImage imageNamed:@"feedback_ic_selected.png"];
    }
    
    [sender setImage:image forState:UIControlStateNormal];*/
    
    //Open Meeting view from bottom.
    MeetingViewController *view = [[MeetingViewController alloc] init];//initWithNibName:@"MeetingViewController" bundle:nil];
    [self presentSemiView:view];
}



@end
