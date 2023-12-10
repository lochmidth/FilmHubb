<p align="center">
  <img src="FilmHubb/Assets.xcassets/AppIcon.appiconset/1024.png" alt="FilmHubb App Icon" width="150" height="150">
</p>

# FilmHubb

FilmHubb is a movie exploration app uses The Movie Database. on FilmHubb, user can discover, track, and stay updated on current, upcoming, and popular movies and add to favorites their favorite movies

## Table of Contents
- [Features](#features)
  - [Tech Stack](#tech-stack)
  - [Architecture](#architecture)
  - [Unit Tests](#unit-tests)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
  - [Browse Movies](#browse-movies)
  - [Search Movies](#search-movies)
  - [Add to Favorite](#add-to-favorite)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Browse Movies:** Seamlessly browse for movies which is on theatre or an upcoming date
- **Search for Movies:** User can search for any movie
- **Detailed Information for a Movie:** User can reach all the information about the movie 
- **Add to Favorite:** Add favorite movies in a list to be able to browse it easier

### Tech Stack

- **Xcode:** Version 14.3.1
- **Language:** Swift 5.8.1
- **Minimum iOS Version:** 16.4
- **Dependency Manager:** SPM

### Architecture

![Architecture](https://miro.medium.com/v2/resize:fit:608/1*ZkoDGds8xDVih88e-m1d_A.png)

In developing FilmHubb, I used the MVVM (Model-View-ViewModel) design pattern for these key reasons:


ChatGPT
MVVM in Swift:

- **Separation of Concerns:** Divides responsibilities between Model, View, and ViewModel for clean code organization.
- **Testability:** Facilitates effective unit testing by isolating business logic in the ViewModel.
- **Scalability:** Enables easy addition of features and maintenance, promoting code agility.
- **Data Binding:** Automates View-ViewModel synchronization, reducing boilerplate code.
- **Readability:** Enhances code readability and maintainability through clear separation of components.
- **Platform Support:** Well-suited for cross-platform Swift development, with shared ViewModel and platform-specific Views.
- 
### Unit Tests

I focused on testing ViewModels first, still working on it.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following:

- Xcode installed

Also, make sure that these dependencies are added in your project's target:

- [JDProgressHUD](https://github.com/JonasGessner/JGProgressHUD):  Used for displaying elegant and customizable progress indicators in your iOS application.
- [SDWebImage](https://github.com/SDWebImage/SDWebImage): Simplifies the process of asynchronous image loading and caching in your app.


### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/lochmidth/FilmHubb.git
    ```

2. Open the project in Xcode:

    ```bash
    cd FilmHubb
    open FilmHubb.xcodeproj
    ```
3. Add required dependencies using Swift Package Manager:

   ```bash
   - JDProgressHUD
   - SDWebImage
    ```

6. Build and run the project.

## Usage

### Browse Movies

1. Open the app on your simulator or device.
2. On the home screen, you can browse for movies in related sections.

---

### Search Movies

1. Use the search bar to find a spesific movie.
2. Click on the movie to see detailed information

---

### Add to Favorite

1. On the 3. tabBar, user can access to favorite section
2. While on the detailed movie screen, user can add or remove by clicking the star icon on the movie screenshot.

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change. Please make sure to update tests as appropiate.

## License

This project is licensed under the [MIT License](LICENSE).
