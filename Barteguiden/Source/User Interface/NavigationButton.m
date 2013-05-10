    //
//  NavigationButton.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 09.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "NavigationButton.h"


static CGFloat const kButtonMargin = 11;
static CGFloat const kImageTitleGap = 10;
static CGSize const kDisclosureIndicatorSize = {9, 13};


@interface NavigationButton ()

@property (nonatomic, strong) UIImageView *disclosureIndicatorImageView;

@end


@implementation NavigationButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set background images
        [self setBackgroundImage:[UIImage imageNamed:@"NavigationButtonBackground-Normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"NavigationButtonBackground-Highlighted"] forState:UIControlStateHighlighted];
        
        // Set text styles
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        // Align image and text
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.contentEdgeInsets = UIEdgeInsetsMake(0, kButtonMargin, 0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, kImageTitleGap, 0, 0);
        
        // Add disclosure indicator
        self.disclosureIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DisclosureIndicator-Normal"] highlightedImage:[UIImage imageNamed:@"DisclosureIndicator-Highlighted"]];
        self.disclosureIndicatorImageView.frame = CGRectMake(self.bounds.size.width - kDisclosureIndicatorSize.width - kButtonMargin, self.bounds.size.height / 2 - kDisclosureIndicatorSize.height / 2, kDisclosureIndicatorSize.width, kDisclosureIndicatorSize.height);
        self.disclosureIndicatorImageView.autoresizesSubviews = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        self.disclosureIndicatorImageView.translatesAutoresizingMaskIntoConstraints = YES;
        [self addSubview:self.disclosureIndicatorImageView];
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    return self.bounds.size;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.disclosureIndicatorImageView.highlighted = highlighted;
}

@end
