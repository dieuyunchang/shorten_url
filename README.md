Hello there! Welcome to my shortened url repository.

## What is it?
This is the sample web URL shortener service to covert the long url to a shorten url.
The application is also pushed into heroku. You can try the service in [https://yunchang-shorten-url-ee4ba68a6caa.herokuapp.com/](https://yunchang-shorten-url-ee4ba68a6caa.herokuapp.com/)
- 
### Setup
From your terminal, clone this repository, `cd` to repository then:
- copy the `.env.sample` to create the `.env` file
- run `bundle install` to get all dependencies for Rails
  - you will need to `install bundle` if you haven't installed yet. Please use [the-bundler](https://www.jetbrains.com/help/ruby/using-the-bundler.html)
  - you will need to install ruby version 3.1.2 also, guide to install [here](https://www.ruby-lang.org/en/downloads/)
- run `yarn install` to get all dependencies for UI
- run project with `rails s`, then you can access via the browser with [http://localhost:3000](http://localhost:3000)

### User flow
- User must need to login before accessing to the shortened url page
- You can use the simple account with email *user@gmail.com* and password *123123123* if you are trying on heroku demo
- I haven't implement the UI for register page and logout page inside this project, but you can do that via the API instead:
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
    - header: add `authorization` with value is user token (`Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGxxxxxxxxx`), which you can get from the login response's header
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
    - the response will include the user token "Authorization" in the header, which you will use it for accessing.
  - with `host_url` is `http://localhost:3000/` or heroku `https://yunchang-shorten-url-ee4ba68a6caa.herokuapp.com`
- After login, you can access the shorten url service page :)
- You can alo can access the create shorten URl service via API
  - url: `{{host_url}}/api/shorten`
  - method: `post`
  - header: add `authorization` with value is user token (`Bearer xxxxxxxxxx.xxxxxxxxxxxx`), which you can get from login header
  - body raw json:
    ```
    {
      "original_url": "https://guides.rubyonrails.org/getting_started.html"
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

### Technical 
- Ruby version: 3.1.2
- Rails version: 7.1.2
- This project is used gems:
  - [devise](https://github.com/heartcombo/devise), [devise-jwt](https://github.com/waiting-for-dev/devise-jwt) for implementing the simple user authentication.
  - [rack-attack](https://github.com/rack/rack-attack) for implementing the rate limit 5 requests per a second.
  - [react-rails](https://github.com/reactjs/react-rails) for implementing the UI for user login, getting shorten url page
  - [rspec-rails](https://github.com/rspec/rspec-rails), for backend testing

## Rate limit setup
- The config is set with maximum 5 request per second, you can change it in [config/initializers/rack_attack.rb](https://github.com/dieuyunchang/shorten_url/blob/main/config/initializers/rack_attack.rb#L80C29-L80C29)
```
  throttle('req', limit: 5, period: 1.second) do |req|
    if req.path == '/api/shorten' && req.post?
      req.ip
    end
  end
```
