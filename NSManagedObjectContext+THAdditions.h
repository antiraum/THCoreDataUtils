//
//  NSManagedObjectContext+THAdditions.h
//  THCoreDataUtils
//
//  Created by Thomas Heß on 8.12.11.
//  Copyright (c) 2011 Thomas Heß. All rights reserved.
//

@interface NSManagedObjectContext (THAdditions)

- (NSUInteger)th_countForEntityName:(NSString*)entityName;
- (NSUInteger)th_countForEntityName:(NSString*)entityName withPredicateFormat:(NSString*)format, ...;
- (NSUInteger)th_countForEntityName:(NSString*)entityName withPredicate:(NSPredicate*)predicate;

- (NSArray*)th_objectsForEntityName:(NSString*)entityName;
- (NSArray*)th_objectsForEntityName:(NSString*)entityName withPredicateFormat:(NSString*)format, ...;
- (NSArray*)th_objectsForEntityName:(NSString*)entityName withPredicate:(NSPredicate*)predicate;
- (NSArray*)th_objectsForFetchRequest:(NSFetchRequest*)fetchRequest;

- (NSManagedObject*)th_singleObjectForEntityName:(NSString*)entityName;
- (NSManagedObject*)th_singleObjectForEntityName:(NSString*)entityName withPredicateFormat:(NSString*)format, ...;
- (NSManagedObject*)th_singleObjectForEntityName:(NSString*)entityName withPredicate:(NSPredicate*)predicate;
- (NSManagedObject*)th_singleObjectForFetchRequest:(NSFetchRequest*)fetchRequest;

- (void)th_persistAsync;
- (void)th_persist;

@end
