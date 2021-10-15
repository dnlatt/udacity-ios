## Latt’s Sports App Overview

An Sports App which is for the Football lover and it displays the latest sports news, premier league results, fixtures & latest team’s standing.

## Implementation

1. App has 4 screens. Main screen is the News controller. 

   - News 
     - User can read latest sports news in this screen. Upon clicking on aricle, new screen will appear and it's lead to the article page. User can click on 'Refresh' button from tab bar to fetch latest news.
     - ![This is an image](https://i.ibb.co/Xkyp0TV/Screenshot-2021-10-14-at-1-29-51-PM.png)

   - Fixtures
     - User can see the upcoming fixtures for the Premier League. Clicking on 'Refresh' button will fetch the latest fixtures.
     - ![This is an image](https://i.ibb.co/0Q7DfHw/Screenshot-2021-10-14-at-1-29-57-PM.png)

   - Result
     - User can see the matches results for the Premier League. Clicking on 'Refresh' button will fetch the latest results.
     - ![This is an image](https://i.ibb.co/bvdhdhM/Screenshot-2021-10-14-at-1-30-00-PM.png)

   - Standings
     - User can see the standing of Premier League clubs. Clicking on 'Refresh' button will fetch the latest standings.
     - ![This is an image](https://i.ibb.co/fvwfn1h/Screenshot-2021-10-14-at-1-30-04-PM.png)


2. Networking

   - All the news, results, fixtures & standing are getting from API. 

3. Persistence

   - This app use Coredata for persistence. When the application is first loaded, the app will check for internet connection. If it’s connected to the internet, the app will fetch data from API and store in CoreData. If a user clicks on the ‘refresh’ button, the App will fetch new data from the Network. If user isn’t connected to the internet, app will fetch data from Core Data and display it to user. 

## How to build
Open the Xcode project and build as normal. No sepcial set up is required. 

## Requirements
- Xcode 13
- Swift 5

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

