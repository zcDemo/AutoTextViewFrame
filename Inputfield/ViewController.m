//
//  ViewController.m
//  Inputfield
//
//  Created by zc on 16/7/29.
//  Copyright © 2016年 zcDong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextViewDelegate>
@property(nonatomic, strong) UILabel *textLable;

@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UIButton *confirmBtn;

@property(nonatomic, assign) CGFloat heigth;
@property(nonatomic, assign) CGFloat with;
@property(nonatomic, assign) NSInteger rows;

@property(nonatomic, assign) CGFloat bgViewY;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _heigth = [UIScreen mainScreen].bounds.size.height;
    _with = [UIScreen mainScreen].bounds.size.width;
    _rows = 1;
    
    self.textLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, _with, _heigth)];
    self.textLable.numberOfLines = 0;
    [self.view addSubview:self.textLable];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _heigth - 60, _with, 60)];
    self.bgView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.bgView];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 15, _with - 70, 30)];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:15];
    [self.bgView addSubview:self.textView];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.confirmBtn.frame = CGRectMake(_with - 50, 10, 40, 40);
    [self.confirmBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.bgView addSubview:self.confirmBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardChangeFrame:(NSNotification *)notifi{
    CGRect keyboardFrame = [notifi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
         self.bgView.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - _heigth);
        _bgViewY = self.bgView.frame.origin.y;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView{
    // numberlines用来控制输入的行数 
    NSInteger numberLines = textView.contentSize.height / textView.font.lineHeight;
    if (numberLines != _rows) {
        NSLog(@"text = %@", self.textView.text);
        _rows = numberLines;
        if  (_rows < 7){
            [self changeFrame:textView.contentSize.height];
        }else{
            self.textView.scrollEnabled = YES;
        }
        
        [textView setContentOffset:CGPointZero animated:YES];
    }
}


- (void)changeFrame:(CGFloat)height{
    CGRect originalFrame = self.bgView.frame;
    originalFrame.size.height = 30 + height ;
    originalFrame.origin.y = _bgViewY - height + 30;
    NSLog(@" original height = %lf after frame = %lf", self.bgView.frame.size.height, originalFrame.size.height);
    
    CGRect textViewFrame = self.textView.frame;
    textViewFrame.size.height = height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame = originalFrame;
        self.textView.frame = textViewFrame;
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
