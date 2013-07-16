//
//  NSManagedObjectContext+THAdditions.m
//  THCoreDataUtils
//
//  Created by Thomas Heß on 8.12.11.
//  Copyright (c) 2011 Thomas Heß. All rights reserved.
//

#import "NSManagedObjectContext+THAdditions.h"
#import "THLog.h"
#import "THWeakSelf.h"

#if !__has_feature(objc_arc)
#error THHybridCache must be built with ARC.
// You can turn on ARC for only THHybridCache files by adding -fobjc-arc to the build phase for each of its files.
#endif

@implementation NSManagedObjectContext (THAdditions)

#pragma mark - Count Fetcher

- (NSUInteger)countForEntityName:(NSString*)entityName
{
	return [self countForEntityName:entityName withPredicate:nil];
}

- (NSUInteger)countForEntityName:(NSString*)entityName withPredicateFormat:(NSString*)format, ...
{
	NSParameterAssert(entityName && format);
    
    va_list arguments;
	va_start(arguments, format);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format arguments:arguments];
	va_end(arguments);

	return [self countForEntityName:entityName withPredicate:predicate];
}

- (NSUInteger)countForEntityName:(NSString*)entityName withPredicate:(NSPredicate*)predicate
{
    NSParameterAssert(entityName);
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) [request setPredicate:predicate];
    return [self countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:entityName]];
}

- (NSUInteger)countForFetchRequest:(NSFetchRequest*)fetchRequest
{
	NSParameterAssert(fetchRequest);
	
    __block NSUInteger count = NSNotFound;
    THWeakSelf wself = self;
    [self performBlockAndWait:^{
        NSError* err = nil;
        count = [wself countForFetchRequest:fetchRequest error:&err];
        if (count == NSNotFound)
            DLog(@"Error fetching count: %@", [err localizedDescription]);
    }];
	
	return count;
}

#pragma mark - Objects Fetcher

- (NSArray*)objectsForEntityName:(NSString*)entityName
{
    return [self objectsForEntityName:entityName withPredicate:nil];
}

- (NSArray*)objectsForEntityName:(NSString*)entityName withPredicateFormat:(NSString*)format, ...
{
	NSParameterAssert(entityName && format);
    
    va_list arguments;
	va_start(arguments, format);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format arguments:arguments];
	va_end(arguments);
    
    return [self objectsForEntityName:entityName withPredicate:predicate];
}

- (NSArray*)objectsForEntityName:(NSString*)entityName withPredicate:(NSPredicate*)predicate
{
    NSParameterAssert(entityName);
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) [request setPredicate:predicate];
    return [self objectsForFetchRequest:request];
}

#pragma mark - Single Object Fetcher

- (NSManagedObject*)singleObjectForEntityName:(NSString*)entityName
{
    return [self singleObjectForEntityName:entityName withPredicate:nil];
}

- (NSManagedObject*)singleObjectForEntityName:(NSString*)entityName withPredicateFormat:(NSString*)format, ...
{
	NSParameterAssert(entityName && format);
    
    va_list arguments;
	va_start(arguments, format);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format arguments:arguments];
	va_end(arguments);
    
    return [self singleObjectForEntityName:entityName withPredicate:predicate];
}

- (NSManagedObject*)singleObjectForEntityName:(NSString*)entityName withPredicate:(NSPredicate*)predicate
{
    NSParameterAssert(entityName);
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) [request setPredicate:predicate];
    [request setFetchLimit:1];
    NSArray* objects = [self objectsForFetchRequest:request];
    
    return (objects) ? [objects lastObject] : nil;
}

- (NSArray*)objectsForFetchRequest:(NSFetchRequest*)fetchRequest
{
	NSParameterAssert(fetchRequest);
	
    __block NSArray* objects = nil;
    THWeakSelf wself = self;
    [self performBlockAndWait:^{
        NSError* err = nil;
        objects = [wself executeFetchRequest:fetchRequest error:&err];
        if (! objects)
            DLog(@"Error fetching objects: %@", [err localizedDescription]);
    }];
    
	return objects;
}

#pragma mark - Persist

- (void)persistAsync
{
    [self processPendingChanges];
    THWeakSelf wself = self;
    [self performBlock:^{
        [wself doPersist];
    }];
}

- (void)persist
{
    THWeakSelf wself = self;
    [self performBlockAndWait:^{
        [wself doPersist];
    }];
}

- (void)doPersist
{
    @autoreleasepool
    {
        @try {
            NSError* error = nil;
            if ([self save:&error]) {
                // DLog(@"Persisted %@ successfully.", wself);
            } else {
                DLog(@"Error while persisting %@: %@", self,
                     [[[NSString stringWithFormat:@"%@", error] stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""]
                      stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]);
                NSAssert(NO, @"Could not persist the MOC. See debug log.");
            }
        } @catch (NSException *e) {
            DLog(@"Exception while persisting %@: %@", self, e);
        }
    }
}

@end