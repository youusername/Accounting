//
//  AppDelegate.m
//  mount
//
//  Created by zd2011 on 13-5-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "loginViewController.h"

@implementation AppDelegate{
    IIViewDeckController*IIViewDeck;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


    UIViewController* deckController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    if ([[UserDefaults objectForKey:@"user"] length]<2) {
        loginViewController *t = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        UINavigationController* center = [[UINavigationController alloc] initWithRootViewController:t];
        deckController=center;
//        [self.navigationController pushViewController:t animated:YES];
    }else{
        //            ViewController *t = [storyboard instantiateViewControllerWithIdentifier:@"aView"];
        if (IIViewDeck==nil) {
            IIViewDeck=[self generateControllerStack];
            
        }
        IIViewDeck.delegate=self;
        deckController=IIViewDeck;
//        [self.navigationController pushViewController:IIViewDeck animated:NO];
    }
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    [ShareSDK registerApp:@"iosv1101"];
    
    //2. 初始化社交平台
    //2.1 代码初始化社交平台的方法
    [self initializePlat];
    return YES;
}

-(void)viewDeckController:(IIViewDeckController *)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated{
    if (viewDeckSide==IIViewDeckRightSide) {
        [[(UINavigationController*)viewDeckController.rightController topViewController] viewWillAppear:YES];
    }
}
-(void)initializePlat{
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    [ShareSDK connectSMS];
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
                           wechatCls:[WXApi class]];
    [ShareSDK connectCopy];
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
- (IIViewDeckController*)generateControllerStack {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    displayViewController*display=[storyboard instantiateViewControllerWithIdentifier:@"display"];
    settingViewController*set=[storyboard instantiateViewControllerWithIdentifier:@"setting"];
    ViewController*view=[storyboard instantiateViewControllerWithIdentifier:@"aView"];
    
    UINavigationController* leftViewController = [[UINavigationController alloc] initWithRootViewController:set];
    UINavigationController* rightViewController = [[UINavigationController alloc] initWithRootViewController:display];
    UINavigationController* center = [[UINavigationController alloc] initWithRootViewController:view];
    
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:center
                                                                                    leftViewController:leftViewController
                                                                                   rightViewController:rightViewController];
    deckController.rightSize = 10;
    deckController.leftSize=10;
    deckController.shadowEnabled=NO;
    view.deckController=deckController;
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    return deckController;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
