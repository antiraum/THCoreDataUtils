//
//  NSManagedObjectContext+THAdditions.h
//  THCoreDataUtils
//
//  Created by Thomas Heß on 8.12.11.
//  Copyright (c) 2011 Thomas Heß. All rights reserved.
//

@interface NSManagedObjectContext (THAdditions)

- (NSUInteger)countForEntityName:(NSString*)entityName;
- (NSUInteger)countForEntityName:(NSString*)entityName withPredicateFormat:(NSString*)format, ...;
- (NSUInteger)countForEntityName:(NSString*)entityName withPredicate:(NSPredicate*)predicate;

- (NSArray*)objectsForEntityName:(NSString*)entityName;
- (NSArray*)objectsForEntityName:(NSString*)entityName withPredicateFormat:(NSString*)format, ...;
- (NSArray*)objectsForEntityName:(NSString*)entityName withPredicate:(NSPredicate*)predicate;
- (NSArray*)objectsForFetchRequest:(NSFetchRequest*)fetchRequest;

- (NSManagedObject*)singleObjectForEntityName:(NSString*)entityName;
- (NSManagedObject*)singleObjectForEntityName:(NSString*)entityName withPredicateFormat:(NSString*)format, ...;
- (NSManagedObject*)singleObjectForEntityName:(NSString*)entityName withPredicate:(NSPredicate*)predicate;
- (NSManagedObject*)singleObjectForFetchRequest:(NSFetchRequest*)fetchRequest;

- (void)persistAsync;
- (void)persist;

@end
