//
//  GroupedTableViewButton.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 09.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GroupedTableViewButton : UIButton

@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UIImageView *accessoryImageView;

@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) UIImage *highlightedThumbnailImage;

@end
