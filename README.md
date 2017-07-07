Async downloader for images and JSON. Can be easily extended with few lines of code to support PDF, XML or any kind of data. Library supports caching objects in memory. Memory size can be updated and objects stored in memory are evicted after specific time interval. Supports multiple concurrent calls to web services. A download call in progress can be cancelled any time. Build in support for activity indicator.

How to use:
Download MVDownloader project and copy the MVDownloader folder to your project inside the root folder.

Downloading Images:
1. Include the following header in your class where you want to download image.

   #import "UIImageView+MVIMageView.h"
2. Call following method on your UIImageView instance. 

   [YOUR_IMAGEVIEW.image setImageForUrl:YOUR_URL_FOR_IMAGE placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] withFrame:cell.frame];
   
Image will be displayed automatically once it's downloaded and ready to display.
