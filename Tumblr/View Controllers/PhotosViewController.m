//
//  PhotosViewController.m
//  Tumblr
//
//  Created by Kristie Huang on 6/25/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *posts;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    self.postsTableView.delegate = self;
    self.postsTableView.dataSource = self;
    
    [super viewDidLoad];

    [self fetchPosts];
    // Do any additional setup after loading the view.
}

- (void)fetchPosts {
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *responseDict = dataDictionary[@"response"];
                self.posts = responseDict[@"posts"];
                
                NSLog(@"%@", dataDictionary);

                // TODO: Get the posts and store in posts property
                // TODO: Reload the table view
                [self.postsTableView reloadData];

            }
        }];
    [task resume];
}

#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

#pragma mark - Table View

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PhotoTableViewCell *cell = [self.postsTableView dequeueReusableCellWithIdentifier:@"PostsCell" forIndexPath:indexPath];
    NSDictionary *post = self.posts[indexPath.row];
    NSArray *images = post[@"photos"];
    NSURL *photoURL = [NSURL URLWithString:@""];

    if (images) {
        NSDictionary *photo0 = images[0];
        NSDictionary *originalSize = photo0[@"original_size"];
        NSString *urlString = originalSize[@"url"];
        photoURL = [NSURL URLWithString:urlString];
    }
    [cell.photoView setImageWithURL:photoURL];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


@end
