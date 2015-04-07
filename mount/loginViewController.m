//
//  loginViewController.m
//  mount
//
//  Created by mac on 15/4/7.
//
//

#import "loginViewController.h"
#import "ViewController.h"
@interface loginViewController (){
    NSMutableDictionary*dic;
}
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *pass;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.login.layer setMasksToBounds:YES];
    [self.login.layer setCornerRadius:10.0];//设置矩形四个圆角半径
     [self.login.layer setBorderWidth:1.0];//边框宽度
    [self.login.layer setBorderColor:[UIColor blackColor].CGColor];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 22, 22)];
//    [button addTarget:self action:@selector(popOfDismss) forControlEvents:UIControlEventTouchUpInside];
//    [button setImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
    [button addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    dic=[[UserDefaults objectForKey:@"userInfo"] mutableCopy];
    if (dic==nil) {
        dic=[[NSMutableDictionary alloc]init];
        [UserDefaults setValue:dic forKey:@"userInfo"];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (IBAction)login:(id)sender {
    NSString*user1=self.user.text;
    NSString*pass1=self.pass.text;
    
    NSString*user2;
    NSString*pass2;
    for (NSString*str in dic) {
        if ([str isEqualToString:user1]) {
            user2=user1;
            if ([pass1 isEqualToString:dic[user1]]) {
                pass2=pass1;
            }
        }
    }
    
    if ([user1 isEqualToString:user2]&&[pass1 isEqualToString:pass2]) {
        [UserDefaults setValue:user1 forKey:@"user"];
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];

            
            ViewController*svc=[storyboard instantiateViewControllerWithIdentifier:@"aView"];
        [self.navigationController pushViewController:svc animated:YES];
    }else{
        SHOW_ALERT(@"用户或密码错误", @"");
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
