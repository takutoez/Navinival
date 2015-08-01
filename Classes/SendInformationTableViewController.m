//
//  SendInformationTableViewController.m
//  Navinival
//
//  Created by 六車卓土 on 7/28/15.
//
//

#import "SendInformationTableViewController.h"
#import "MyAppDelegate.h"

@interface SendInformationTableViewController ()

@end

@implementation SendInformationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self toggleCellVissibility:_datePickerCell animated:NO];
    _memoTextView.placeholder = @"内容";
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"M/d H:mm"];
    [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    
    _isoDateFormatter = [[NSDateFormatter alloc] init];
    [_isoDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [_isoDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.tableView cellForRowAtIndexPath:indexPath] == _setPlaceCell) {
        UINavigationController *placePicker = [self.storyboard instantiateViewControllerWithIdentifier:@"placePicker"];
        [self presentViewController:placePicker animated:YES completion:nil];
    }
    
    if([self.tableView cellForRowAtIndexPath:indexPath] == _setTimeCell) {
        [self toggleCellVissibility:_datePickerCell animated:YES];
    }
    
    if([self.tableView cellForRowAtIndexPath:indexPath] == _setImageCell) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePickerController setAllowsEditing:NO];
            [imagePickerController setDelegate:self];
        
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
    
}

- (void) toggleCellVissibility:(UITableViewCell *)cell animated:(BOOL)animate{
    [self cell:cell setHidden:![self cellIsHidden:cell]];
    [self reloadDataAnimated:animate];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [self imageWithImage:(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]];
    if (image) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = image;
        _imageView.frame = CGRectMake(self.view.frame.size.width - 74, 0, 58, 43.5);
        [_setImageCell addSubview:_imageView];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage*)imageWithImage:(UIImage*)sourceImage {
    float x = 0;
    float y = 0;
    float newWidth = sourceImage.size.width;
    float newHeight = sourceImage.size.height;
    if(sourceImage.size.width/sourceImage.size.height > 4/3) {
        newWidth = sourceImage.size.height * 4 / 3;
        x = (sourceImage.size.width - newWidth)/2;
    }else{
        newHeight = sourceImage.size.width * 3 / 4;
        y = (sourceImage.size.height - newHeight)/2;
    }
    CGImageRef srcImageRef = [sourceImage CGImage];
    CGImageRef trimmedImageRef;
    if(sourceImage.imageOrientation == UIImageOrientationUp){
        trimmedImageRef = CGImageCreateWithImageInRect(srcImageRef, CGRectMake(x, y, newWidth, newHeight));
    }else{
        trimmedImageRef = CGImageCreateWithImageInRect(srcImageRef, CGRectMake(y, x, newHeight, newWidth));
    }
    UIImage *trimmedImage = [UIImage imageWithCGImage:trimmedImageRef scale:sourceImage.scale orientation:sourceImage.imageOrientation];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 240), NO, 0.0);
    [trimmedImage drawInRect:CGRectMake(0, 0, 320, 240)];
    trimmedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return trimmedImage;
}

- (IBAction)send:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: config delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString* boundary = @"TaKTmuGrumA";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSMutableData* data = [NSMutableData data];
    
    [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", @"number"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"%@\r\n", [_dictionary objectForKey:@"number"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", @"title"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"%@\r\n", _titleTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", @"time"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"%@\r\n", [_isoDateFormatter stringFromDate:_datePicker.date]] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", @"content"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"%@\r\n", _memoTextView.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"name=\"%@\";", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"filename=\"%@\"\r\n", @"information.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:UIImageJPEGRepresentation(_imageView.image, 0.2)];
    [data appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [data appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/gakuin/form/push/", BASE_URL]]];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    
    self.navigationController.navigationBar.topItem.title = @"送信中...";
    
    [[delegateFreeSession dataTaskWithRequest:request
                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                if (error != nil){
                                    self.navigationController.navigationBar.topItem.title = @"送信失敗";
                                    NSLog(@"%@", error);
                                }else{
                                    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                    for (NSDictionary *jsonDictionary in jsonArray)
                                    {
                                        if([[jsonDictionary objectForKey:@"status"] isEqualToString:@"OK"]){
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        }else{
                                            self.navigationController.navigationBar.topItem.title = @"送信失敗";
                                        }
                                    }
                                }
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            }] resume];
}

- (void)setDictionaryAndSetPlace:(NSDictionary *)dictionary {
    _dictionary = dictionary;
    _place.text = [dictionary objectForKey:@"place"];
}

- (IBAction)unwindSegue:(UIStoryboardSegue *)segue {
    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)datePicked:(id)sender {
    UIDatePicker *targetedDatePicker = sender;
    _time.text = [_dateFormatter stringFromDate:targetedDatePicker.date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
