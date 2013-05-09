//
//  GroupedTableViewButton.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 09.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "GroupedTableViewButton.h"


static CGFloat const kThumbnailImageViewWidth = 43;
static CGFloat const kAccessoryImageViewWith = 27;


@interface GroupedTableViewButton ()

@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UIImageView *accessoryImageView;

@end


@implementation GroupedTableViewButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUpView];
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage
{
    self.thumbnailImageView.image = thumbnailImage;
}

- (void)setHighlightedThumbnailImage:(UIImage *)highlightedThumbnailImage
{
    self.thumbnailImageView.highlightedImage = highlightedThumbnailImage;
}


#pragma mark - Private methods

- (void)setUpView
{
    NSLog(@"%@", NSStringFromCGRect(self.frame));
    // Set background image
    UIImage *backgroundImage = [[UIImage imageNamed:@"GroupedTableViewButton-Normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 11, 10)];
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    UIImage *highlightedBackgroundImage = [[UIImage imageNamed:@"GroupedTableViewButton-Highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 11, 10)];
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
    
    // Create thumnail image
    _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kThumbnailImageViewWidth, self.bounds.size.height)];
    
    _thumbnailImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_thumbnailImageView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    // Create accessory image view
    _accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - kAccessoryImageViewWith, 0, kAccessoryImageViewWith, self.bounds.size.height)];
    _accessoryImageView.backgroundColor = [UIColor redColor];
    _accessoryImageView.image = [UIImage imageNamed:@"GroupedTableViewArrow-Normal"];
    _accessoryImageView.highlightedImage = [UIImage imageNamed:@"GroupedTableViewArrow-Highlighted"];
    
    _accessoryImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_accessoryImageView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    // Add subviews
    [self addSubview:_thumbnailImageView];
    [self addSubview:_accessoryImageView];
}

@end
