#import "OfflineDatabaseManager.h"
#import "PlayerData.h"
#import "LandData.h"
#import "IslandIndex.h"
#import "PlayerManager.h"

@interface OfflineDatabasePlayerEntry : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) PlayerData* playerData;
@property (nonatomic, retain) LandData* landData;
@property (nonatomic, retain) NSString* password;
@end

@implementation OfflineDatabasePlayerEntry

- (NSDictionary*)serializedRepresentationForOfflineDatabase
{
    
    NSMutableDictionary* offlineDatabaseTemplate = [NSMutableDictionary object];
    
    [offlineDatabaseTemplate setValue:_playerData.serializedRepresentationForOfflineDatabase
                           forKeyPath:@"playerData"];
    
    [offlineDatabaseTemplate setValue:_landData.serializedRepresentationForOfflineDatabase
                           forKeyPath:@"landData"];
    
    [offlineDatabaseTemplate setValue:_password
                           forKeyPath:@"password"];
    
    return offlineDatabaseTemplate;
}

@end

@interface OfflineDatabaseManager ()
{
	
}
@property (nonatomic, retain) NSMutableDictionary* offlineDatabasePlayerEntryByLoginId;
@end


@implementation OfflineDatabaseManager

- (id)init
{
    if (self = [super init])
    {
        _offlineDatabasePlayerEntryByLoginId = [NSMutableDictionary new];
    }
    return self;
}

- (NSString*)internal_offlineDatabaseRoot
{
    return @"/myapps/towerIsles/iosClientCode/game/resources/offlineDatabase";
}

- (void)createPlayerWithLoginId:(NSString*)loginId
                       password:(NSString*)password
{
    OfflineDatabasePlayerEntry* offlineDatabasePlayerEntry = [self internal_offlineDatabasePlayerEntryForLoginId:kDefaultPlayerName];
    
    offlineDatabasePlayerEntry.password = password;
    
    [_offlineDatabasePlayerEntryByLoginId setObject:offlineDatabasePlayerEntry
                                             forKey:loginId];
    
    [self internal_saveOfflineDatabasePlayerEntry:offlineDatabasePlayerEntry
                                        withLogin:loginId];
}

- (void)deleteUserWithLoginId:(NSString*)loginId
{
    // delete entry from dictionaries.
    // remove files
}

- (PlayerData*)retreivePlayerData:(NSString*)loginId
{
    OfflineDatabasePlayerEntry* offlineDatabasePlayerEntry = [self internal_offlineDatabasePlayerEntryForLoginId:loginId];
    return offlineDatabasePlayerEntry.playerData;
}

- (LandData*)retreiveLandData:(NSString*)loginId
{
    OfflineDatabasePlayerEntry* offlineDatabasePlayerEntry = [self internal_offlineDatabasePlayerEntryForLoginId:loginId];
    return offlineDatabasePlayerEntry.landData;
}

- (OfflineDatabasePlayerEntry*)internal_offlineDatabasePlayerEntryForLoginId:(NSString*)loginId
{
    OfflineDatabasePlayerEntry* entry = [_offlineDatabasePlayerEntryByLoginId objectForKey:loginId];
    
    if (entry == nil ||
        [loginId isEqualToString:kDefaultPlayerName])
    {
        NSString* path = Format(@"%@/%@.json", [self internal_offlineDatabaseRoot], loginId);
        
        CheckTrue([ResourceManager doesResourceAtPathExist:path])
        
        entry = [ResourceManager configurationObjectForResourceAtPath:path
                                                           usingClass:OfflineDatabasePlayerEntry.class];
    }
    
    return entry;
}

- (void)internal_saveOfflineDatabasePlayerEntry:(OfflineDatabasePlayerEntry*)offlineDatabasePlayerEntry
                                      withLogin:(NSString*)loginId
{
    NSString* path = Format(@"%@/%@.json", [self internal_offlineDatabaseRoot], loginId);
    
    NSDictionary* databaseEntry = [offlineDatabasePlayerEntry serializedRepresentationForOfflineDatabase];
    
    NSString* outputString = [databaseEntry JSONStringWithOptions:JKSerializeOptionPretty
                                                                      error:nil];
    
    [outputString writeToFile:path
                   atomically:YES
                     encoding:NSUTF8StringEncoding
                        error:nil];
}

@end
