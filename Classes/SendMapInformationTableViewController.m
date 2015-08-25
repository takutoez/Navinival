//
//  SendMapInformationTableViewController.m
//  Navinival
//
//  Created by 六車卓土 on 7/27/15.
//
//

#import "SendMapInformationTableViewController.h"
#import "MyAppDelegate.h"

@interface SendMapInformationTableViewController ()

@end

@implementation SendMapInformationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contentTextView.placeholder = @"内容";
    
    _titleTextField.text = _titleString;
    _contentTextView.text = _contentString;
}

- (void)viewWillAppear:(BOOL)animated {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"パスワード"
                                          message:@"編集のためのパスワードを入力してください"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"パスワード";
         textField.secureTextEntry = YES;
         [textField addTarget:self
                       action:@selector(alertTextFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
     }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                                NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                                config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
                                NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: config delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
                                   
                                UITextField *field = alertController.textFields.firstObject;
                                   
                                NSData *data = [[NSString stringWithFormat:@"password=%@&map_number=%@&information_number=%@", field.text, _number, _informationNumber] dataUsingEncoding:NSUTF8StringEncoding];
                                   
                                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/gakuin/form/map/information/password/", BASE_URL]]];
                                request.HTTPMethod = @"POST";
                                request.HTTPBody = data;
                                   
                                [[delegateFreeSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               if (error != nil){
                                                                   alertController.message = @"エラー";
                                                                   [self presentViewController:alertController animated:YES completion:nil];
                                                               }else{
                                                                   NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                                   NSLog(@"%@", jsonArray);
                                                                   for (NSDictionary *jsonDictionary in jsonArray)
                                                                   {
                                                                       if(![[jsonDictionary objectForKey:@"status"] isEqualToString:@"ok"]){
                                                                           alertController.message = @"パスワードが間違っています";
                                                                           [self presentViewController:alertController animated:YES completion:nil];
                                                                       }
                                                                   }
                                                               }
                                                               [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                           }] resume];
                               }];
    okAction.enabled = NO;
    UIAlertAction *cancelAction = [UIAlertAction
                               actionWithTitle:@"キャンセル"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self dismissViewControllerAnimated:YES completion:^(void){[self dismissViewControllerAnimated:YES completion:nil];}];
                               }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    if(_edit){
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = login.text.length > 7;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)send:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: config delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSData *data;
    
    if(_edit) {
        data = [[NSString stringWithFormat:@"number=%@&information_number=%@&title=%@&content=%@", _number, _informationNumber, _titleTextField.text, _contentTextView.text] dataUsingEncoding:NSUTF8StringEncoding];
    }else{
        data = [[NSString stringWithFormat:@"number=%@&information_number=%@&title=%@&content=%@", _number, @"0", _titleTextField.text, _contentTextView.text] dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/gakuin/form/map/information/", BASE_URL]]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    
    self.navigationController.navigationBar.topItem.title = @"送信中...";

    if(_edit) {
        [[delegateFreeSession dataTaskWithRequest:request
                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                    if (error != nil){
                                        self.navigationController.navigationBar.topItem.title = @"送信失敗";
                                    }else{
                                        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                        for (NSDictionary *jsonDictionary in jsonArray)
                                        {
                                            if([[jsonDictionary objectForKey:@"status"] isEqualToString:@"ok"]){
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                            }else{
                                                self.navigationController.navigationBar.topItem.title = @"送信失敗";
                                            }
                                        }
                                    }
                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                }] resume];
    }else{
        [[delegateFreeSession dataTaskWithRequest:request
                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                if (error != nil){
                                    self.navigationController.navigationBar.topItem.title = @"送信失敗";
                                }else{
                                    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                    for (NSDictionary *jsonDictionary in jsonArray)
                                    {
                                        if([jsonDictionary objectForKey:@"password"]){
                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString  stringWithFormat:@"パスワード:%@", [jsonDictionary objectForKey:@"password"]] message:@"すぐにメモしてください。同じ団体以外の人には絶対に教えないでください。" preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction* ok = [UIAlertAction
                                                                 actionWithTitle:@"閉じる"
                                                                 style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action)
                                                                 {
                                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                                     [self dismissViewControllerAnimated:YES completion:nil];
                                                                     
                                                                 }];
                                            [alert addAction:ok];
                                            [self presentViewController:alert animated:YES completion:nil];
                                        }else{
                                            self.navigationController.navigationBar.topItem.title = @"送信失敗";
                                        }
                                    }
                                }
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            }] resume];
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
