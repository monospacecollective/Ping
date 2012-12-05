#import "AFIncrementalStore.h"
#import "AFRestClient.h"

@interface CUUCD2012APIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (CUUCD2012APIClient *)sharedClient;

@end
