# MoviesTestApp

## About
This application allows you to see the list of popular movies, search movies by title, sort movies by popularity and see the detailed info of a specific movie. 

On **Details** screen you can see basic movie info and also able to open movie poster on full screen, or watch the movie trailer if it exists.
## Getting started
1. Clone this repository.
2. Via the CLI, go to the root folder of the project where Podfile is located and run pod install.
3. Open the workspace file and you are ready to go.

## Screenshots
<img src="https://github.com/pvulmvul/MoviesTestApp/assets/83655258/4cc6a6c0-8701-4095-a39e-ea322708ba5e" width=248 height=448>
<img src="https://github.com/pvulmvul/MoviesTestApp/assets/83655258/758551bc-4bbc-433b-bc0f-f52d7fbf0f62" width=248 height=448>
<img src="https://github.com/pvulmvul/MoviesTestApp/assets/83655258/baf9855f-440b-44d3-b308-5f36096b3842" width=248 height=448>
<img src="https://github.com/pvulmvul/MoviesTestApp/assets/83655258/4118920b-2682-4603-81c4-6ab92dfd5e27" width=248 height=448>
<img src="https://github.com/pvulmvul/MoviesTestApp/assets/83655258/bee1354a-7f57-4b4b-bbde-02c3d136ffcb" width=248 height=448>
<img src="https://github.com/pvulmvul/MoviesTestApp/assets/83655258/e92598bf-5351-48cf-b9e6-cb162d7ae054" width=248 height=448>
<img src="https://github.com/pvulmvul/MoviesTestApp/assets/83655258/6a052bbf-59b6-468d-aa26-2c3e50c59288" width=248 height=448>

## Third-party libraries
### Kingfisher (https://github.com/onevcat/Kingfisher)
Used for downloading and caching images. In the app, it is used to show the poster image of the movie.
### Lottie (https://github.com/airbnb/lottie-ios)
Used for animated loader
### Lightbox (https://github.com/hyperoslo/Lightbox)
Used for presenting poster in full-screen and manipulate with it
### YouTube-Player-iOS-Helper (https://github.com/youtube/youtube-ios-player-helper)
Used for watching movie trailer from YouTube
### Alamofire (https://github.com/Alamofire/Alamofire)
Used for HTTP requests

## Architecture
### MVP+R
Classic MVP + Router for navigation and modals presentation
