//
//  EventResult.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 09.02.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "EventResultsController.h"
#import "EventResultsControllerDelegate.h"


@interface EventResultsController ()

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSDictionary *items;

@end



@implementation EventResultsController

- (instancetype)initWithResult:(NSArray *)result;
{
    self = [super init];
    if (self) {
//        _result = result;
    }
    return self;
}

- (NSUInteger)numberOfSections
{
    return [self.sections count];
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section
{
    return [[self.items objectForKey:[self titleForSection:section]] count];
}

- (NSString *)titleForSection:(NSUInteger)section
{
    return [self.sections objectAtIndex:section];
}

- (id<Event>)eventForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *section = [self.items objectForKey:[self titleForSection:indexPath.section]];
    return [section objectAtIndex:indexPath.row];
}


#pragma mark - Private methods

//- (NSArray *)sections
//{
//    if (_sections == nil) {
//        [self updateSectionsAndItems];
//    }
//    
//    return _sections;
//}
//
//- (NSDictionary *)items
//{
//    if (_items == nil) {
//        [self updateSectionsAndItems];
//    }
//    
//    return _items;
//}

//- (void)updateSectionsAndItems
//{
//    NSMutableArray *sections = [[NSMutableArray alloc] init];
//    NSDictionary *items = [_result classifyObjectsUsingBlock:^id<NSCopying>(id obj) {
//        EventFormatter *eventFormatter = [[EventFormatter alloc] initWithEvent:obj];
//        NSString *sectionName = [eventFormatter dateSectionName];
//        
//        if ([sectionName isEqual:[sections lastObject]] == NO) {
//            [sections addObject:sectionName];
//        }
//        
//        return sectionName;
//    }];
//    
//    self.sections = [sections copy];
//    self.items = [items copy];
//}

@end
