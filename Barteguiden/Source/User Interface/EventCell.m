//
//  EventCell.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 17.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
//        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)awakeFromNib
{
    self.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18];
    self.subtitleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:14];
    self.detailLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:15];
    
    // Add highlight color on iOS6
    if ([[[UIDevice currentDevice] systemVersion] integerValue] <= 6) {
        self.titleLabel.highlightedTextColor = [UIColor whiteColor];
        self.subtitleLabel.highlightedTextColor = [UIColor whiteColor];
        self.detailLabel.highlightedTextColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
