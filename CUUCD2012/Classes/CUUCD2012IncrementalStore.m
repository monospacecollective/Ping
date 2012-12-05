#import "CUUCD2012IncrementalStore.h"
#import "CUUCD2012APIClient.h"

@implementation CUUCD2012IncrementalStore

+ (void)initialize {
    [NSPersistentStoreCoordinator registerStoreClass:self forStoreType:[self type]];
}

+ (NSString *)type {
    return NSStringFromClass(self);
}

+ (NSManagedObjectModel *)model {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CUUCD2012" withExtension:@"xcdatamodeld"]];
}

- (id <AFIncrementalStoreHTTPClient>)HTTPClient {
    return [CUUCD2012APIClient sharedClient];
}

@end