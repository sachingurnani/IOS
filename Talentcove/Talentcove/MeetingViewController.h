//
//  MeetingViewController.h
//  Talentcove
//
//  Created by Apple on 05/04/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingViewController : UIView{
    
}


@property (strong, nonatomic) IBOutlet UILabel *attendeeName;
@property (strong, nonatomic) IBOutlet UILabel *skillUse;
@property (strong, nonatomic) IBOutlet UILabel *selectTag;
@property (strong, nonatomic) IBOutlet UILabel *comments;
@property (strong, nonatomic) IBOutlet UIButton *save;
@property (strong, nonatomic) IBOutlet UITextView *editComments;
@property (strong, nonatomic) IBOutlet UIButton *rating;

- (void) setDefaultBackgroundImageForButtonTag:(NSInteger)tag;
- (void) formatLabel:(UILabel*)label;
- (IBAction)saveButtonClick:(id)sender;
- (IBAction)ratingButtonClick:(id)sender;

@end
