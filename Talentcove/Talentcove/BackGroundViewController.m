//
//  RBViewController.m
//  Roadbud
//
//  Created by Anton Minin on 2/4/11.
//

#import "BackGroundViewController.h"

@implementation BackGroundViewController

- (void) viewDidLoad {
	
	// add background image
	UIImageView* bgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_grey.png"]];
	bgview.contentMode = UIViewContentModeTopLeft;
	bgview.frame = CGRectMake(0, 0, 320, 480);
	[self.view addSubview:bgview];
	[self.view sendSubviewToBack:bgview];
	
}

@end
