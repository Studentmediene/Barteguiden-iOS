//
//  EventDetailsViewController.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 10.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;

@interface EventDetailsViewController : UITableViewController

@property (nonatomic, strong) Event *event;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *categoryLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel *ageLimitLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) IBOutlet UILabel *featuredLabel;

@property (nonatomic, strong) IBOutlet UILabel *placeNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;

//@property (nonatomic, strong) IBOutlet UIImageView *poster;

- (IBAction)addToFavorite:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)addToCalendar:(id)sender;

@end
