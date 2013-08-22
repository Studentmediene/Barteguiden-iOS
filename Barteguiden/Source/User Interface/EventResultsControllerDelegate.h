//
//  EventResultsControllerDelegate.h
//  Barteguiden
//
//  Created by Christian Rasmussen on 09.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import <Foundation/Foundation.h>


@class EventResultsController;
@protocol EventResultsSectionInfo;

@protocol EventResultsControllerDelegate <NSObject>

@optional

// Customizing Section Names
//- (NSString *)eventResultsController:(EventResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName;

@end
