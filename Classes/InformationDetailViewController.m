//
//  InformationDetailViewController.m
//  Navinival
//
//  Created by 六車卓土 on 2015/04/23.
//
//

#import "InformationDetailViewController.h"

@interface InformationDetailViewController ()

@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _imageView.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor whiteColor].CGColor,
                            (id)[UIColor clearColor].CGColor,
                            nil];
    gradientLayer.startPoint = CGPointMake(0.0f, 0.1f);
    gradientLayer.endPoint = CGPointMake(0.0f, 0.4f);
    _imageView.layer.mask = gradientLayer;

    _detailTitle.text = _info.title;
    _detailMeta.text = [NSString stringWithFormat:@"%@ %@", _info.time, _info.map];
    if (_image){
        _detailImage.image = _image;
    }else{
        dispatch_queue_t q_main = dispatch_get_main_queue();
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString: _info.image]]];
            dispatch_async(q_main, ^{
                _detailImage.image = image;
            });
        });
    }
    _detailContents.text = _info.content;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_containerView addSubview:line];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end