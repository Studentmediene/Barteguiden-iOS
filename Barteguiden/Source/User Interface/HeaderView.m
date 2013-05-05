//
//  HeaderView.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 11.04.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SectionHeader"]];
        [self.contentView addSubview:imageView];
        
        self.textLabel.textColor = [UIColor colorWithHue:0 saturation:0 brightness:33.0/100.0 alpha:1];
        
        [[UILabel appearanceWhenContainedIn:[self class], nil] setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:17]];
    }
    return self;
}

@end
