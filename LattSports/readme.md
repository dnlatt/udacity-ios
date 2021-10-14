## Latt’s Sports App Overview

An Sports App which is for the Football lover and it displays the latest sports news, premier league results, fixtures & latest team’s standing.

**User Interface**

App has 4 screens. 

1. News 
User can read latest sports news in this screen. Upon clicking on aricle, new screen will appear and it's lead to the article page. User can click on 'Refresh' button from tab bar to fetch latest news.

![This is an image](https://i.ibb.co/Xkyp0TV/Screenshot-2021-10-14-at-1-29-51-PM.png)

2. Fixtures
User can see the upcoming fixtures for the Premier League. Clicking on 'Refresh' button will fetch the latest fixtures.

![This is an image](https://i.ibb.co/0Q7DfHw/Screenshot-2021-10-14-at-1-29-57-PM.png)

3. Result
User can see the matches results for the Premier League. Clicking on 'Refresh' button will fetch the latest results.

![This is an image](https://i.ibb.co/bvdhdhM/Screenshot-2021-10-14-at-1-30-00-PM.png)

4. Standings
User can see the standing of Premier League clubs. Clicking on 'Refresh' button will fetch the latest standings.

![This is an image](https://i.ibb.co/fvwfn1h/Screenshot-2021-10-14-at-1-30-04-PM.png)

**Networking**

All the news, results, fixtures & standing are getting from API. 

**Persistence**

When the application is first loaded, the app will check for internet connection. If it’s connected to the internet, the app will fetch data from API and store in CoreData. If a user clicks on the ‘refresh’ button, the App will fetch new data from the Network. If user isn’t connected to the internet, app will fetch data from Core Data and display it to user. 


