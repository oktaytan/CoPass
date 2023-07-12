<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<div align="center">
  <h1 align="center">CoPass (with MVVP)</h1>
  <p align="center">An application that you can securely save and quickly copy your passwords built with MVVP architecture.</p>
</div>

<!-- TABLE OF CONTENTS -->
<summary>Table of Contents</summary>
<ol>
  <li><a href="#about-the-project">About The Project</a></li>
  <li><a href="#screenshots">Screenshots</a></li>
  <li><a href="#built-with">Built With</a></li>
  <li><a href="#installation">Installation</a></li>
</ol>
<br />


<!-- ABOUT THE PROJECT -->
## About The Project

When the application is started, a screen appears, listing frequently used passwords and seeing your password security score. Passwords are saved with CoreData in the application. The master password used to login to the application is saved in Keycahin.

When any password is pressed, the application will take you to the screen where you can edit, change the category or delete that password.

On the Store screen, you will see the screen where the passwords are listed in categories and you can search within this list.

There is information on the Safety screen where the saved passwords are divided into strong, weak and reused, and you can see your score over all these situations.

The profile screen, on the other hand, has features such as sharing and notifications related to the application, where you can edit your user name and master password.

The application is built in accordance with the MVP architecture. MVP consists of Model-View-Presenter layers. The business logic layer of the application is the Presenter layer. The layer that creates controllers in the application and provides navigation between them is the Wireframe layer.

Providers have been added to fulfill the responsibilities of the TableView and CollectionView structures in the Controller in the application. Each provider performs the TableView or CollectionView operations it is responsible for and notifies the Controller with the help of an event.

Passwords are stored in the CoreData database in encrypted form using the CryptoSwift library.

In the application, auxiliary libraries such as SnapKit, ViewAnimator, SPIndicator are also used.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- SCREENSHOTS -->
## Screenshots

<div>
  <img src="/Screenshots/login.png" alt="Deals" width="200">
  <img src="/Screenshots/home.png" alt="Deals" width="200">  
  <img src="/Screenshots/store.png" alt="Store" width="200">  
  <img src="/Screenshots/search.png" alt="Store" width="200"> 
  <img src="/Screenshots/record.png" alt="Games" width="200">  
  <img src="/Screenshots/safety.png" alt="Games Search" width="200">  
  <img src="/Screenshots/profile.png" alt="Stores" width="200">
  <img src="/Screenshots/user.png" alt="Stores" width="200">  
</div>
<br />

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- BUILD WITH -->
## Built With

* Swift, UIKit, MVP
* CryptoSwift - Secure cryptographic algorithms implemented in Swift
* IQKeyboardManager - To prevent issues of keyboard sliding up
* SnapKit - A Swift Autolayout DSL for iOS & OS X
* SPIndicator - Toast message
* ViewAnimator - UI animations

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- INSTALLATION -->
## Installation

1. Clone the repo
   ```sh
   git clone https://github.com/oktaytan/CoPass.git
   ```
2. Run project with Xcode

<p align="right">(<a href="#readme-top">back to top</a>)</p>
