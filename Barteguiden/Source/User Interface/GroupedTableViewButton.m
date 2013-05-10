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

- (void)layoutSubviews
{
//    if () {
//        
//    }
    if (self.thumbnailImageView == nil) {
        UIImage *backgroundImage = [[UIImage imageNamed:@"GroupedTableViewButton-Normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 11, 10)];
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        UIImage *highlightedBackgroundImage = [[UIImage imageNamed:@"GroupedTableViewButton-Highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 11, 10)];
        [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
        [self setUpThumbnailImageView];
    }
    
    if (self.accessoryImageView == nil) {
        [self setUpAccessoryImageView];
    }
}


#pragma mark - Private methods

- (void)setUpView
{
    
}

- (void)setUpThumbnailImageView
{
    _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kThumbnailImageViewWidth, self.bounds.size.height)];
    
    _thumbnailImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_thumbnailImageView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [self addSubview:_thumbnailImageView];
}

- (void)setUpAccessoryImageView
{
    _accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - kAccessoryImageViewWith, 0, kAccessoryImageViewWith, self.bounds.size.height)];
    _accessoryImageView.backgroundColor = [UIColor redColor];
    _accessoryImageView.image = [UIImage imageNamed:@"GroupedTableViewArrow-Normal"];
    _accessoryImageView.highlightedImage = [UIImage imageNamed:@"GroupedTableViewArrow-Highlighted"];
    
    _accessoryImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_accessoryImageView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [self addSubview:_accessoryImageView];
}

@end
