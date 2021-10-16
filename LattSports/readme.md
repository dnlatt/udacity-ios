## Latt’s Sports App Overview

An Sports App which is for the Football lover and it displays the latest sports news, premier league results, fixtures & latest team’s standing.

## Implementation

1. App has 4 screens. Main screen is the News controller. 

   - Pull to refresh 
     - User can pull the table to on each screen to get latest data. This function will disable if the internet is offline.
     - ![This is an image](https://i.ibb.co/6D0FXgH/Screenshot-2021-10-16-at-10-21-51-AM.png)

   - News 
     - User can read latest sports news in this screen. Upon clicking on aricle, new screen will appear and it's lead to the article page. 
     - ![This is an image](https://i.ibb.co/KK6Lvdz/Screenshot-2021-10-16-at-10-16-57-AM.png)

   - Fixtures
     - User can see the upcoming fixtures for the Premier League. 
     - ![This is an image](https://i.ibb.co/0f3QC6P/Screenshot-2021-10-16-at-10-17-01-AM.png)

   - Result
     - User can see the matches results for the Premier League. 
     - ![This is an image](https://i.ibb.co/G9SbfCs/Screenshot-2021-10-16-at-10-17-08-AM.png)

   - Standings
     - User can see the standing of Premier League clubs. 
     - ![This is an image](https://i.ibb.co/RbS5LKX/Screenshot-2021-10-16-at-10-17-16-AM.png)


2. Networking

   - All the news, results, fixtures & standing are getting from API. 

3. Persistence

   - This app use Coredata for persistence. When the application is first loaded, the app will check for internet connection. If it’s connected to the internet, the app will fetch data from API and store in CoreData. If a user pull the table, system will perform refresh function and the App will fetch new data from the Network. If user isn’t connected to the internet, app will fetch data from Core Data and display it to user. 

## How to build
Open the Xcode project and build as normal. No sepcial set up is required. 

## Requirements
The app was built using Xcode 11.7 and Swift 5

## License

MIT License

Copyright (c) D Naung Latt

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

