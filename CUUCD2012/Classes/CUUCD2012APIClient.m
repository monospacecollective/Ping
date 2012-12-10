#import "CUUCD2012APIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kCUUCD2012APIBaseURLString = @"http://ping.monospacecollective.com/";

@implementation CUUCD2012APIClient

+ (CUUCD2012APIClient *)sharedClient {
    static CUUCD2012APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kCUUCD2012APIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

#pragma mark - AFIncrementalStore

- (id)representationOrArrayOfRepresentationsFromResponseObject:(id)responseObject {
    return responseObject;
}

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation 
                                     ofEntity:(NSEntityDescription *)entity 
                                 fromResponse:(NSHTTPURLResponse *)response 
{
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];
    
    if ([entity.name isEqualToString:@"Place"]) {
        [mutablePropertyValues setValue:@([[representation valueForKey:@"people_here"] integerValue]) forKey:@"peopleHere"];
    }
    if ([entity.name isEqualToString:@"User"]) {
        if (![[representation valueForKey:@"location_accuracy_radius"] isKindOfClass:NSNull.class]) {
            [mutablePropertyValues setValue:@([[representation valueForKey:@"location_accuracy_radius"] integerValue]) forKey:@"locationAccuracyRadius"];
        }
        if (![[representation valueForKey:@"location_collection_interval"] isKindOfClass:NSNull.class]) {
            [mutablePropertyValues setValue:@([[representation valueForKey:@"location_collection_interval"] integerValue]) forKey:@"locationCollectionInterval"];
        }
        [mutablePropertyValues setValue:[representation valueForKey:@"gender"] forKey:@"gender"];
        [mutablePropertyValues setValue:[representation valueForKey:@"occupation"] forKey:@"occupation"];
    }
    
    return mutablePropertyValues;
}

- (NSDictionary *)representationOfAttributes:(NSDictionary *)attributes
                             ofManagedObject:(NSManagedObject *)managedObject

{
    if ([managedObject.entity.name isEqualToString:@"User"]) {
        NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
        [mutableAttributes setValue:nil forKey:@"locationAccuracyRadius"];
        [mutableAttributes setValue:nil forKey:@"locationCollectionInterval"];
        [mutableAttributes setValue:[attributes valueForKey:@"locationAccuracyRadius"] forKey:@"location_accuracy_radius"];
        [mutableAttributes setValue:[attributes valueForKey:@"locationCollectionInterval"] forKey:@"location_collection_interval"];
        return @{@"user" : mutableAttributes};
    }
    return attributes;
}

- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
                                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
                               forObjectWithID:(NSManagedObjectID *)objectID
                        inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

@end
