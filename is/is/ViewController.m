//
//  ViewController.m
//  is
//
//  Created by bakaneko on 13/08/2014.
//  Copyright (c) 2014 this.bundle.identifier. All rights reserved.
//

#import "ViewController.h"
#import <UICKeyChainStore.h>


@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Bundle seed ID: %@", [self.class bundleSeedID]);
    [self writeToKeychain];
}

- (void)writeToKeychain {
    UICKeyChainStore *store1 = [UICKeyChainStore keyChainStoreWithService:@"service" accessGroup:[self.class accessGroupWithSeedID:@"accessgroup"]];
    UICKeyChainStore *store2 = [UICKeyChainStore keyChainStoreWithService:@"service" accessGroup:[self.class accessGroupWithSeedID:@"it.doesnt.matter.what.this.is"]];
    [store1 setString:[NSDate date].description forKey:@"key1"];
    [store2 setString:[NSDate date].description forKey:@"key1"];

    [store1 synchronize];
    [store2 synchronize];
}

+ (NSString *)accessGroupWithSeedID:(NSString *)accessGroup
{
    NSString *keychainAccessGroup = [NSString stringWithFormat:@"%@.%@", [self bundleSeedID], accessGroup];
    NSLog(@"keychain-access-group: %@", keychainAccessGroup);

    return keychainAccessGroup;
}

// returns your bundle seed ID.
// This is the Apple generated ID that all your apps get prefixed with. e.g. 12345ABCDE.MyApp
// For newly created apps this is most likely your Team ID; for old apps it will probably be something else.
// This can be checked in the developer center under App Identifiers; it's the _Prefix_ of your App ID,
// _not_ any part of your Bundle ID.
// Your Bundle ID is irrelevant to shared keychain access.
+ (NSString *)bundleSeedID {
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)(kSecClassGenericPassword), kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge id)(kSecAttrAccessGroup)];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
