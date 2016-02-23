//
//  AppDelegate.m
//  Bragi
//
//  Created by Yvonne on 1/20/16.
//  Copyright (c) 2016 Yvonne. All rights reserved.
//
#import <pjsua-lib/pjsua.h>

#import "AppDelegate.h"
#import "MainViewController.h"
#import "IncomingCallViewController.h"
#import "HistoryViewController.h"
#import "ContactViewController.h"
static pjsua_acc_id acc_id;

static void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id, pjsip_rx_data *rdata);
static void on_call_state(pjsua_call_id call_id, pjsip_event *e);
static void on_call_media_state(pjsua_call_id call_id);
static void on_reg_state(pjsua_acc_id acc_id);

IncomingCallViewController *incomingcontroller;
@interface AppDelegate ()
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate
//@synthesize tabbarController = _tabbarController;

//used in restApi
static dispatch_once_t once;
static NSOperationQueue *connectionQueue;
+ (NSOperationQueue *)connectionQueue
{
    dispatch_once(&once, ^{
        connectionQueue = [[NSOperationQueue alloc] init];
        [connectionQueue setMaxConcurrentOperationCount:2];
        [connectionQueue setName:@"com.mycompany.connectionqueue"];
        
    });
    
    return connectionQueue;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:3.0];//time delay as loading

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleIncommingCall:)
                                                 name:@"SIPIncomingCallNotification"
                                               object:nil];

    pj_status_t status;
    
    status = pjsua_create();
    
    if (status != PJ_SUCCESS) {
        NSLog(@"error create pjsua"); return NO;
    }
    
    {
        pjsua_config cfg;
        pjsua_media_config media_cfg;
        pjsua_logging_config log_cfg;
        
        pjsua_config_default(&cfg);
        
        cfg.cb.on_incoming_call = &on_incoming_call;
        cfg.cb.on_call_media_state = &on_call_media_state;
        cfg.cb.on_call_state = &on_call_state;
        cfg.cb.on_reg_state = &on_reg_state;
        
        pjsua_media_config_default(&media_cfg);
        media_cfg.clock_rate = 16000;
        media_cfg.snd_clock_rate = 16000;
        media_cfg.ec_tail_len = 0;
        
        pjsua_logging_config_default(&log_cfg);
#ifdef DEBUG
        log_cfg.msg_logging = PJ_TRUE;
        log_cfg.console_level = 4;
        log_cfg.level = 5;
#else
        log_cfg.msg_logging = PJ_FALSE;
        log_cfg.console_level = 0;
        log_cfg.level = 0;
#endif
        
        // 初始化PJSUA
        status = pjsua_init(&cfg, &log_cfg, &media_cfg);
        if (status != PJ_SUCCESS) {
            NSLog(@"error init pjsua"); return NO;
        }
    }
    
    // udp transport
    {
        pjsua_transport_config cfg;
        pjsua_transport_config_default(&cfg);
        
        // 传输类型配置
        status = pjsua_transport_create(PJSIP_TRANSPORT_UDP, &cfg, NULL);
        if (status != PJ_SUCCESS) {
            NSLog(@"error add transport for pjsua"); return NO;
        }
    }
    
    // 启动PJSUA
    status = pjsua_start();
    if (status != PJ_SUCCESS) {
        NSLog(@"error start pjsua"); return NO;
    }
    
    // Register the account on local sip server
    {
        
        pjsua_acc_config cfg;
        pjsua_acc_config_default(&cfg);
        cfg.id = pj_str("sip:sip05@140.114.71.165:12373");
        cfg.reg_uri = pj_str("sip:140.114.71.165:12373");
        cfg.cred_count = 1;
        cfg.cred_info[0].realm = pj_str("asterisk");
        cfg.cred_info[0].scheme = pj_str("digest");
        cfg.cred_info[0].username = pj_str("sip05" );
        cfg.cred_info[0].data_type = PJSIP_CRED_DATA_PLAIN_PASSWD;
        cfg.cred_info[0].data = pj_str( "eliteisgood");
        // Register the account
        status = pjsua_acc_add(&cfg, PJ_TRUE, &acc_id);
        if (status != PJ_SUCCESS) NSLog(@"Error adding account %d", status);
    }

    return YES;
}

- (void)handleIncommingCall:(NSNotification *)notification {
    pjsua_call_id callId = [notification.userInfo[@"call_id"] intValue];
    NSString *phoneNumber = notification.userInfo[@"remote_address"];
    
//    mainviewcontroller.phoneNumber = phoneNumber;
//    mainviewcontroller.callId = callId;
    incomingcontroller = [[IncomingCallViewController alloc]init];
    incomingcontroller.phoneNumber = phoneNumber;
    incomingcontroller.callId = callId;
    
    UIViewController *rootViewController = self.window.rootViewController;
    [rootViewController presentViewController:incomingcontroller animated:YES completion:nil];

    
//    NSURL *username = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNumber]];
//    
//    if([[UIApplication sharedApplication] canOpenURL:username]){
//        [[UIApplication sharedApplication] openURL:username];
//    }
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    IncomingCallViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"IncomingCallViewController"];
//
    
//    viewController.phoneNumber = phoneNumber;
//    viewController.callId = callId;
    
//    UIViewController *rootViewController = self.window.rootViewController;
//    [rootViewController presentViewController:viewController animated:YES completion:nil];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Arcadyan.Bragi" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Bragi" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Bragi.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
static void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id, pjsip_rx_data *rdata) {
    pjsua_call_info ci;
    pjsua_call_get_info(call_id, &ci);
    
    NSString *remote_info = [NSString stringWithUTF8String:ci.remote_info.ptr];
    
    NSUInteger startIndex = [remote_info rangeOfString:@"<"].location;
    NSUInteger endIndex = [remote_info rangeOfString:@">"].location;
    
    NSString *remote_address = [remote_info substringWithRange:NSMakeRange(startIndex + 1, endIndex - startIndex - 1)];
    remote_address = [remote_address componentsSeparatedByString:@":"][1];
    
    id argument = @{
                    @"call_id"          : @(call_id),
                    @"remote_address"   : remote_address
                    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SIPIncomingCallNotification" object:nil userInfo:argument];
    });
    
}

static void on_call_state(pjsua_call_id call_id, pjsip_event *e) {
    pjsua_call_info ci;
    pjsua_call_get_info(call_id, &ci);
    
    id argument = @{
                    @"call_id"  : @(call_id),
                    @"state"    : @(ci.state)
                    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SIPCallStatusChangedNotification" object:nil userInfo:argument];
    });
}

static void on_call_media_state(pjsua_call_id call_id) {
    pjsua_call_info ci;
    pjsua_call_get_info(call_id, &ci);
    
    if (ci.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
        // When media is active, connect call to sound device.
        pjsua_conf_connect(ci.conf_slot, 0);
        pjsua_conf_connect(0, ci.conf_slot);
    }
}

static void on_reg_state(pjsua_acc_id acc_id) {
    
    pj_status_t status;
    pjsua_acc_info info;
    
    status = pjsua_acc_get_info(acc_id, &info);
    if (status != PJ_SUCCESS)
        return;
    
    id argument = @{
                    @"acc_id"       : @(acc_id),
                    @"status_text"  : [NSString stringWithUTF8String:info.status_text.ptr],
                    @"status"       : @(info.status)
                    };
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SIPRegisterStatusNotification" object:nil userInfo:argument];
    });
}

//- (void)initTabbar{
//    NSLog(@"initTabbar");
//    HistoryViewController *vc1 = [[HistoryViewController alloc] init];
//    UINavigationController *na1 = [[UINavigationController alloc] initWithRootViewController:vc1] ;
//    na1.navigationBar.barStyle = UIBarStyleBlack;
//    
//    
//    ContactViewController *vc2 = [[ContactViewController alloc] init];
//    UINavigationController *na2 = [[UINavigationController alloc] initWithRootViewController:vc2];
//    na2.navigationBar.barStyle = UIBarStyleBlack;
//    
//    
//    self.tabbarController = [[UITabBarController alloc] init];
//    self.tabbarController.viewControllers = [NSArray arrayWithObjects:na1, na2,  nil];
//    
//    
//    
//    
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
//    shadow.shadowOffset = CGSizeMake(0, 1);
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
//                                                           /*shadow, NSShadowAttributeName,*/
//                                                           [UIFont fontWithName:@"Markerfelt-Thin" size:22.0], NSFontAttributeName, nil]];
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//    //    KITsDataHolder * holder = [KITsDataHolder defaultHolder];//change tint color
//        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
//        [[UITabBar appearance] setTintColor:[UIColor blackColor]];
//  //      [[UITabBar appearance] setTintColor:holder.detailTextLabelColor];
//        //self.tabbarController.tabBar.barTintColor = [UIColor whiteColor];
//        //self.tabbarController.tabBar.tintColor = holder.detailTextLabelColor;
//    }
//
//    
//}

- (UINavigationController *)navigationController {
    if (_navigationController == nil) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
        navigationController.navigationBar.tintColor = [UIColor colorWithRed:26 / 255.0 green:178 / 255.0 blue:10 / 255.0 alpha:1];
        _navigationController = navigationController;
    }
    return _navigationController;
}

- (UITabBarController *)tabBarController {
    if (_tabBarController == nil) {
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        
        MainViewController *mainframeViewController = ({
            MainViewController *mainframeViewController = [[MainViewController alloc] init];
            
            UIImage *mainframeImage   = [UIImage imageNamed:@"dialpadtab"];
            UIImage *mainframeHLImage = [UIImage imageNamed:@"dialpadtab"];
            
           // mainframeViewController.title = @"數字鍵盤";
            mainframeViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"數字鍵盤" image:mainframeImage selectedImage:mainframeHLImage];
            mainframeViewController.view.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
            mainframeViewController;
        });
        
        HistoryViewController *contactsViewController = ({
            HistoryViewController *contactsViewController = [[HistoryViewController alloc] init];
            
            UIImage *contactsImage   = [UIImage imageNamed:@"recenttab"];
            UIImage *contactsHLImage = [UIImage imageNamed:@"recenttab"];
            
            //contactsViewController.title = @"通話紀錄";
            contactsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"通話紀錄" image:contactsImage selectedImage:contactsHLImage];
        //    contactsViewController.view.backgroundColor = [UIColor colorWithRed:115 / 255.0 green:155 / 255.0 blue:6 / 255.0 alpha:1];
            
            contactsViewController;
        });
        
        ContactViewController *discoverViewController = ({
            ContactViewController *discoverViewController = [[ContactViewController alloc] init];
            
            UIImage *discoverImage   = [UIImage imageNamed:@"contacttab"];
            UIImage *discoverHLImage = [UIImage imageNamed:@"contacttab"];
            
         //   discoverViewController.title = @"聯絡人";
            discoverViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"聯絡人" image:discoverImage selectedImage:discoverHLImage];
//            discoverViewController.view.backgroundColor = [UIColor colorWithRed:32 / 255.0 green:85 / 255.0 blue:128 / 255.0 alpha:1];
            
            discoverViewController;
        });
        
        
        tabBarController.tabBar.tintColor = [UIColor colorWithRed:26 / 255.0 green:178 / 255.0 blue:10 / 255.0 alpha:1];
        
        tabBarController.viewControllers = @[
                                             [[UINavigationController alloc] initWithRootViewController:mainframeViewController],
                                             [[UINavigationController alloc] initWithRootViewController:contactsViewController],
                                             [[UINavigationController alloc] initWithRootViewController:discoverViewController],
                                             ];
        
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

- (void)didClickAddButton:(id)sender {
//    ViewController *viewController = [[ViewController alloc] init];
//    
//    viewController.title = @"添加";
//    viewController.view.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:178 / 255.0 blue:10 / 255.0 alpha:1];
//    
//    [self.navigationController pushViewController:viewController animated:YES];
}



@end
