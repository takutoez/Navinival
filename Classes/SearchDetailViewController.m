//
//  SearchDetailViewController.m
//  Navinival
//
//  Created by 六車卓土 on 8/15/15.
//

#import "SearchDetailViewController.h"

@interface SearchDetailViewController ()

@end

@implementation SearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _titleString;
    _contentLabel.text = _contentString;
    [_contentLabel sizeToFit];
    _goodLabel.text = [NSString stringWithFormat:@"%@%@",  _goodString, @"Goods"];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_scrollView layoutIfNeeded];
    if(_contentLabel.frame.origin.y + _contentLabel.frame.size.height + 46 > _scrollView.frame.size.height){
        _contentsView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 46);
    }else{
        _contentsView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height + 1);
    }
    _scrollView.contentSize = _contentsView.bounds.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end