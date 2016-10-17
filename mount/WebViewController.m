//
//  WebViewController.m
//  mount
//
//  Created by mac on 15/5/4.
//
//

#import "WebViewController.h"

@interface WebViewController (){
    UIWebView*web;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    web=[[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:web];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wap.591hx.com/"]]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
