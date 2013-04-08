//
//  Global.h
//  Talentcove
//
//  Created by Neera Sharma on 04/04/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BoldFont @"HelveticaNeue-Bold"
#define MediumFont @"HelveticaNeue-Medium"
#define RegularFont @"HelveticaNeue"

@interface Global : NSObject

@end
