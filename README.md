# README

# SE Rails starter

### Known issue
If you see this...

`/Users/ethanzeigler/.rvm/gems/ruby-2.7.0@rails6/gems/activemodel-6.0.2.1/lib/active_model/type/value.rb:8: warning: The called method ``initialize' is defined here`

You're fine. It's actually an issue with rails' code itself that they need to fix. You can ignore it without issue.

## Development Setup

### Install Ruby on Rails & PostgreSQL for your machine:
Ruby (2.7.0) & Rails (6.0.2.1): 
https://gorails.com/setup/

> **TCNJ students using a VM:** In the installruby.sh file, change the ruby and rails versions accordingly!

### Install this repository: 

`git clone https://github.com/TCNJSwEngg/SE-Rails-starter.git`

***IF YOU DO NOT USE GIT CLONE, THE ENTIRE GIT SYSTEM WILL BREAK! USE CLONE!***


Once cloned, navigate to the servd/code directory and install the project dependencies. 

`bundle install`
`yarn install`

If you encounter errors, try restarting PostgreSQL and installing additional updates.

For CentOS:
```sh
$ systemctl restart postgresql-9.6
$ sudo yum install postgresql96-libs
$ sudo yum install postgresql96-devel
```
For MacOS:
```sh
$ pg_ctl -D /usr/local/var/postgres start
   ```
> **TCNJ NOTE:** If issues continue, there's something wrong with your psql installation.

PLease run the following. `sudo yum install postgresql-libs postgresql-devel`

If the still continue, look up the error you're receiving for more advice.

### Create the databases and perform migration:

    rake db:create
    rake db:migrate:reset
    rake db:migrate
    rake db:seed

### Finally, run the app.
Find the correct binding for your VM if you're using one. Use the `--binding` flag or you won't be able to view the site from your browser due to the way the HPC handles VM connections.

`rails s (or rails server) --binding xxx.xxx.xxx.xxx`

The app should be available in the browser at [localhost:3000](localhost:3000).

### Administration

To access the admin interface, go to the /admin page. It's powered by rails admin. (A remake of django-admin)


# Pasted help information from index file of template.
Home#index

Find me at app/views/home/index.html.erb. Make sure to clear out the file before you start working. The other files, _erb, _mvc, _filetree can be deleted.
This Template

This rails 6 template will give you a good starting point when working on software engineering projects. The following have already been installed and configured...

    Rails 6 (the project, at least)
    Bootstrap 4
    Devise user authentication system
    better_errors (replace default error page with a better one)
    web_console (put <% console %> in a view to have a console on the page)
    A basic layout
    User logins

Devise

Devise is a user authentication system for ruby on rails designed around another program called warden. You will not need to change anything regarding its settings unless you are changing login behavior, which is unlikely.

To make a page not require login, add skip_before_action :authenticate_user! on top of the controller. To limit it to specific methods of a controller, tack on only: ['method_name'] at the end of the line. You can add more than one method.
Bootstrap

Bootstrap is a CSS and javascript library made by twitter to "bootstrap" website development. CSS can be very difficult to work with. Bootstrap makes it dramatically easier by giving you an entire library of premade classes. For more details, see the documentation.
The MVC Model of web development

Model: data organization
View: the presentation of information to the user
Controller: the manipulation and overseeing of information and access to it

These three categories make up the design of practically every application, desktop or internet enabled. It's the seperation of these tasks that keeps an application easy to maintain, write, and read. Please make sure to understand these categories before working with rails. If you don't recall seeing these terms before, check the class slides.

For more information, see Wikipedia.
File Structure

The rails file structure is strange. Please be patient. You'll learn it in time.

Note: The following has important sections bolded and underlined. The other sections can be largely ignored unless you have some specific need for them. Not automatically made means that a brand new rails project will not contain this file. Some things were made to give you a starting point for the class.

tcnj-rails-image/app
├── assets (Holds images, CSS, and javascript) 
│   ├── config
│   │   └── manifest.js (how to assemble the things in assets)
│   ├── images (any statically available images)
│   ├── javascripts
│   │   └── application.js (global javascript)
│   └── stylesheets
│       ├── application.scss (global css)
│       └── home.scss (controller specific css [not automatically made])
├── channels
│   └── application_cable
│       ├── README.md
│       ├── channel.rb
│       └── connection.rb
├── controllers (The C of MVC. Handles data manipulation and handling.)
│   ├── application_controller.rb (Superclass of all controllers)
│   ├── concerns
│   └── home_controller.rb (Controller for the home pages [not automatically made])
├── helpers (Any helper methods wanted inside of erb files)
│   ├── application_helper.rb (Superclass of all helpers
│   └── home_helper.rb (Helpers specific to views within the home folder [not automatically made])
├── javascript (this is webpack specific and will probably be ignored)
│   ├── channels
│   │   ├── consumer.js
│   │   └── index.js
│   └── packs
│       └── application.js
├── jobs (Workloads to be run in the background)
│   └── application_job.rb (Superclass of all jobs)
├── mailers
│   └── application_mailer.rb
├── models (The M of MVC, storing and representing information)
│   ├── app_config.rb (A model for strong global settings [not automatically made])
│   ├── application_record.rb (The superclass of all models)
│   ├── concerns
│   └── user.rb (A model representing a website user [not automatically made])
└── views (The V of MVC, defining how information is presented to a user)
    ├── home (Views for the home controller [not automatically made])
    │   ├── _erb.html.erb (A piece of the index page)
    │   ├── _filetree.html.erb (A piece of the index page)
    │   ├── _mvc.html.erb (A piece of the index page)
    │   └── index.html.erb (The webpage you're staring at)
    └── layouts (Special views that contain the common outside of all pages)
        ├── application.html.erb (The content displayed on every
        ├── mailer.html.erb
        └── mailer.text.erb

ERB basics

To run ruby code, put it in a tag formatted like this:
<% app_name() %> ->
However, that won't change the HTML sent to the client. In fact, even if we tried to write something that would be part of the document like this
<% 'Hello, world!' %> ->
Nothing happens still? This is because while rails inputs the return value of a block of code like this into the document, it only does so if we tell the language to do so. We do that like this. Add an = to the front of the block.
<%= 'Hello, world!' %> -> Hello, world!
And success! However, in doing so, we found something important. If you want to run some code like an if around HTML depending on if the user is logged in or not, use <% if %> ... <% else %> ... <% end %>. None of these tags will output anything since there's no =, so you can do things like this. However, if you do want to output something, make sure to use the equal sign at the front, or you'll be confused as to why nothing is printing!
Oh, and comments are like this. <%# Hiya! %>. They will not be written to the HTML file sent to the user.
Writing good html.erb files

Here's the golden rule of erb: don't process data in the erb file! There's nothing to stop you from processing information within the view itself, but this is very bad practice for several reasons.

The main reason is simple. MVC. Model, View, Controller. A view should NOT be fetching its own information or manipulating models. That's the controller's job. Keeping these tasks seperate will make your view files highly readable. Speaking from experience, Software Engineering projects can become complex due to (unavoidable, you're learning!) inexperience with web development and the MVC model. Doing your best to follow those guidelines will help you substancially in the last few assignments of the classs.

All in all, use the documentation in this template to your advantage! Stack Overflow has tons of resources for ruby on rails and your upperclassmen peers can probably give you a hand with rails questions should you need it. Plus, if you have a student aid to the class, take advantage of them!

Good luck, and have a great semester!

Ethan Zeigler, '20



This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
