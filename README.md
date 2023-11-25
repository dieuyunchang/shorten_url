Hello there! Welcome to my shortened url repository.

## What is it?
This is the sample web URL shortener service to covert the long url to a shorten url.
The application is also pushed into heroku, You can try the service in [https://yunchang-shorten-url-ee4ba68a6caa.herokuapp.com/](https://yunchang-shorten-url-ee4ba68a6caa.herokuapp.com/)

- 
### Setup
Clone this repository, cd to repository then:
- copy the `.env.sample` to create the `.enp` file
- run `bundle install` to get all dependencies for Rails
  - you will need to `install bundle` if you haven't installed yet. Please [using-the-bundler](https://www.jetbrains.com/help/ruby/using-the-bundler.html)
- run `yarn install` to get all dependencies for UI
- run project with `rails s`, then you can access via the browser with [http://localhost:3000](http://localhost:3000)

### User flow
- User must need to login before accessing to the shortened url page
- You can use the simple account with email *user@gmail.com* and password *123123123* if you are trying on heroku demo
- I haven't implement the UI of register page and logout inside this project, but you can do that via the API instead:
  - register: 
    - url: `{{host_url}}/signup`
    - method: `post`
    - body json:
      ```
        {
          "user" : {
            "email": "test12322329991231232232@mail.com",
            "password": "123123123"
          }
        }
      ``` 
  - logout: 
    - url: `{{host_url}}/logout`
    - method: `delete`
    - header: add `authorization` with value is user token (`Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGxxxxxxxxx`), which you can get from login header
  - login: 
    - url: `{{host_url}}/login`
    - method: `get`
    - body json: 
      ```
        {
          "user": {
              "email": "test12322329991231232232@mail.com",
              "password": "123123123"
          }
        }
      ```
  - with `host_url` is `http://localhost:3000/` or heroku `https://yunchang-shorten-url-ee4ba68a6caa.herokuapp.com`
- After login, you can access the shorten url service page :)
- You can alo can access the create shorten URl service via API
  - url: `{{host_url}}/api/shorten`
  - method: `post`
  - header: add `authorization` with value is user token (`Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGxxxxxxxxx`), which you can get from login header
  - body raw josb:
    ```
    {
      "original_url": "https://www.youtube.com/watch?v=nsL4Xg8Xpnc&ab_channel=TechmakerStudio"
    }
    ```
  - response will be:
    ```
      {
        "data": {
            "shortened_link": "http://localhost:3000/n"
        }
      }
    ```

### technical 
- Ruby version: 3.1.2
- Rails version: 7.1.2
- This project used gems:
  - [devise](https://github.com/heartcombo/devise), [devise](https://github.com/waiting-for-dev/devise-jwt) to implement the simple user authentication.
  - [rack-attack](https://github.com/rack/rack-attack) to implement the rate limit 5 requests per a second.
  - [react-rails](https://github.com/reactjs/react-rails) to implement the UI for user login, getting shorten url page
