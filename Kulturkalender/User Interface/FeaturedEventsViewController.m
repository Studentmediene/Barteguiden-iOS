//
//  FeaturedEventsViewController.m
//  Kulturkalender
//
//  Created by Christian Rasmussen on 02.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import "FeaturedEventsViewController.h"

#import "AppDelegate.h"
#import "NSManagedObject+CIMGF.h" // TODO: Temp

@implementation FeaturedEventsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"Featured Events Tab");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (IBAction)tempAddItem:(id)sender
{
    AppDelegate *appDelegate = (id)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Example" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@", values);
    
    NSArray *events = values[@"events"];
    for (NSDictionary *event in events) {
        NSManagedObject *managedEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
        [managedEvent safeSetValuesForKeysWithDictionary:event dateFormatter:nil];
        [managedEvent setValue:[NSDate date] forKey:@"dateTime"];
    }
    [appDelegate saveContext];
}

@end
