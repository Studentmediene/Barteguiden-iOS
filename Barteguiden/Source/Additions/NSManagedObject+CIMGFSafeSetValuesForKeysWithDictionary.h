//
//  NSManagedObject+CIMGF_SafeSetValuesForKeysWithDictionary.h
//  http://www.cimgf.com/2011/06/02/saving-json-to-core-data/
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (CIMGFSafeSetValuesForKeysWithDictionary)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues;
- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter;
- (void)safeSetValue:(id)value forKey:(NSString *)key;
- (void)safeSetValue:(id)value forKey:(NSString *)key dateFormatter:(NSDateFormatter *)dateFormatter;

@end
