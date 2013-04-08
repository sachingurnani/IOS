//
//  MeetingViewController.m
//  Talentcove
//
//  Created by Apple on 05/04/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MeetingViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "Global.h"

@interface MeetingViewController ()

@end

@implementation MeetingViewController
@synthesize attendeeName,comments,skillUse,selectTag;
@synthesize editComments, rating;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"MeetingViewController" owner:self options:nil] objectAtIndex:0]];
    }
    return self;
}

/*- (void)viewDidLoad
{
    //[super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setDefaultBackgroundImageForButtonTag:1];
    [self setDefaultBackgroundImageForButtonTag:2];
    [self setDefaultBackgroundImageForButtonTag:3];
    [self setDefaultBackgroundImageForButtonTag:4];
    [self setDefaultBackgroundImageForButtonTag:5];
    
    [self formatLabel:comments];
    [self formatLabel:selectTag];
    [self formatLabel:skillUse];

    [editComments setBackgroundColor:[UIColor clearColor]];
    [editComments setFont:[UIFont fontWithName:MediumFont size:14.0]];
    [editComments setTextColor:UIColorFromRGB(0xa5bbb9)];
    [editComments setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"comments_txt.png"]]];
    
    [attendeeName setBackgroundColor:[UIColor clearColor]];
    [attendeeName setFont:[UIFont fontWithName:BoldFont size:15.0]];
    [attendeeName setShadowColor:[UIColor whiteColor]];
    [attendeeName setTextColor:UIColorFromRGB(0x191919)];
}

-(void) setDefaultBackgroundImageForButtonTag:(NSInteger)tag{
    
    UIButton *button = (UIButton *)[self.view viewWithTag:tag];
    UIImage *buttonImage = [[UIImage imageNamed:@"tag-default.png"]stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitleShadowColor:UIColorFromRGB(0xa2a2a2) forState:UIControlStateNormal];
}

-(void) formatLabel:(UILabel*)label{

    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:BoldFont size:15.0]];
    [label setShadowColor:[UIColor whiteColor]];
    [label setTextColor:UIColorFromRGB(0x00b09d)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
- (IBAction)saveButtonClick:(id)sender{
    
   // [self dismissSemiModalView];
}

- (IBAction)ratingButtonClick:(id)sender{
    
    UIButton *selectionButton = [[UIButton alloc] init];
    selectionButton = sender;
    
    UIImage *img = selectionButton.currentImage;
    UIImage *image = [UIImage imageNamed:@"star-default.png"];
    
    if(img == image){
        image = [UIImage imageNamed:@"star-selected.png"];
    }
    
    [sender setImage:image forState:UIControlStateNormal];
}
@end
