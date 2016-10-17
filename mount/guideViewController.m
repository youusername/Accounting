//
//  guideViewController.m
//  mount
//
//  Created by zd2011ss on 13-6-26.
//
//

#import "guideViewController.h"
#import "ViewController.h"
#import "loginViewController.h"

@interface guideViewController (){
    IIViewDeckController* IIViewDeck;
}

@end

@implementation guideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"long.png"]];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    [[UINavigationBar appearance] setTranslucent:YES];
self.navigationItem.backBarButtonItem=nil;
//    UIColor *bgcolor = [UIColor colorWithRed:0.0f/255.0f green:158.0f/255.0f blue:183.0f/255.0f alpha:1.0f];
//    self.navigationController.navigationBar.tintColor = bgcolor;
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:0.0f/255.0f green:158.0f/255.0f blue:183.0f/255.0f alpha:1.0f];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"view.png"]];
	// Do any additional setup after loading the view.
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
    deckController.rightSize = 20;
    deckController.leftSize=20;
    view.deckController=deckController;
    deckController.shadowEnabled=NO;
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    return deckController;
}
-(void)viewWillAppear:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        NSLog(@"这是第一次进入");
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        if ([[UserDefaults objectForKey:@"user"] length]<2) {
            loginViewController *t = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            [self.navigationController pushViewController:t animated:YES];
        }else{
//            ViewController *t = [storyboard instantiateViewControllerWithIdentifier:@"aView"];
            if (IIViewDeck==nil) {
                IIViewDeck=[self generateControllerStack];
            }
            
            [self.navigationController pushViewController:IIViewDeck animated:NO];
        }
//
        
        NSLog(@"这不是第一次进入");
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
