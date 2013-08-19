//
//  NSManagedObject+CIMGF_SafeSetValuesForKeysWithDictionary.m
//  http://www.cimgf.com/2011/06/02/saving-json-to-core-data/
//

#import "NSManagedObject+CIMGFSafeSetValuesForKeysWithDictionary.h"

@implementation NSManagedObject (CIMGFSafeSetValuesForKeysWithDictionary)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    return [self safeSetValuesForKeysWithDictionary:keyedValues dateFormatter:nil];
}

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter
{
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
        id value = [keyedValues objectForKey:attribute];
        [self safeSetValue:value forKey:attribute dateFormatter:dateFormatter];
    }
}

- (void)safeSetValue:(id)value forKey:(NSString *)key
{
    [self safeSetValue:value forKey:key dateFormatter:nil];
}

- (void)safeSetValue:(id)value forKey:(NSString *)key dateFormatter:(NSDateFormatter *)dateFormatter
{
    NSDictionary *attributes = [[self entity] attributesByName];
    NSAttributeDescription *attributeDescription = [attributes objectForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        id defaultValue = [attributeDescription defaultValue];
        [self setValue:defaultValue forKey:key];
        return;
    }
    
    NSAttributeType attributeType = [attributeDescription attributeType];
    if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
        value = [value stringValue];
    } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
        value = [NSNumber numberWithInteger:[value integerValue]];
    } else if (((attributeType == NSFloatAttributeType) || (attributeType == NSDoubleAttributeType)) && ([value isKindOfClass:[NSString class]])) {
        value = [NSNumber numberWithDouble:[value doubleValue]];
    } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) && (dateFormatter != nil)) {
        value = [dateFormatter dateFromString:value];
    } else if ((attributeType == NSDecimalAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
        value = [[NSDecimalNumber alloc] initWithDouble:[value doubleValue]];
    }
    
    Class attributeTypeClass = [[self attributeTypeToClassMapping] objectForKey:@(attributeType)];
    if (attributeTypeClass != Nil && [value isKindOfClass:attributeTypeClass]) {
        [self setValue:value forKey:key];
    }
}

- (NSDictionary *)attributeTypeToClassMapping
{
    static NSDictionary *attributeTypeToClassMapping;
    if (attributeTypeToClassMapping == nil) {
        attributeTypeToClassMapping = @{
            @(NSInteger16AttributeType): [NSNumber class],
            @(NSInteger32AttributeType): [NSNumber class],
            @(NSInteger64AttributeType): [NSNumber class],
            @(NSDecimalAttributeType): [NSDecimalNumber class],
            @(NSDoubleAttributeType): [NSNumber class],
            @(NSFloatAttributeType): [NSNumber class],
            @(NSStringAttributeType): [NSString class],
            @(NSBooleanAttributeType): [NSNumber class],
            @(NSDateAttributeType): [NSDate class]
        };
    }
    
    return attributeTypeToClassMapping;
}

@end
