# Blog App
> A rails application with CRUD functionalities where users can register and submit their articles and other users can comment on those articles.

# Features

* Authentication:
  
  * First time users have to register with username, email and password
  * User login with email and password
    
* Authorization:

  * One cannot manage articles and view user profile without being authenticated
  * One cannot edit or delete articles and comments created by other users
 
* Manage articles with basic functionalities:

  * User can post an article with status as "public" or "private"
  * Edit or delete an article.

* Comments:

  * Add or delete comments on an article

* Like:
  * Like or Unlike an article
  * Like or Unlike a comment
 
* Friendship:

  * User can send a follow request to another user
  * User can accept or decline a follow request.
  * A user following another user can see their articles posted with private status.
