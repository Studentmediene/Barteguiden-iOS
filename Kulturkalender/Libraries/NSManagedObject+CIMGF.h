//
//  NSManagedObject+CIMGF.h
//  Kulturkalender
//
//  http://www.cimgf.com/2011/06/02/saving-json-to-core-data/
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (CIMGF)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter;

@end
