# Clothes Helper

Clothes Helper is a console application which selects you correctly clothes for the weather, adds and deletes garments from
your wardrobe.

## Installing and using the program

The console application was created on the __Ruby 2.5.1__ .
You need to install [Ruby interpreter](https://www.ruby-lang.org/en/news/2018/03/28/ruby-2-5-1-released) 
in order to work with that.

The program uses such a library (gem) as __i18n__.

Ensure that the library manager __bundler__ is installed.

- Input in the __cmd__ or __terminal__ the following command:
  ```
  gem install bundler
  ```
- After installing the library manager, input the next command in order to make sure that it was installed:
  ```
  bundler -v
  ```
- Input the next command for installing the necessary gems before running program:
  ```
  `bundle install`
  ```
- Input the next command for running program:
  ```
  ruby main.rb
  ```
  or
  ```
  ruby main.rb [locale]
  ```
  where __[locale]__ is a locale key. There are two locale keys in the program such as __en__ and __ru__.

## Adding garments

You can add or delete your garments from the wardrobe using the console application or editing `clothing.xml` file in the folder `data`.

## Custom locale

You can create your custom locale. For example, you want to make an internationalization of the game in German.
Examine the content of other yaml files (e.g. `en.yml`) in order to create your custom yaml file.
Then you need to commit the following steps:

- Create a new yaml file `de.yml` in the folder `config/locales`.
- Fill the file with necessary internationalization texts.
- Add a new language as follows:
  ```
  de:
    .....
    .....
    languages:
      en: "English"
      ru: "Русский"
      de: "Deutsch"
  ```

## Demo

You can watch a demo version of the application at the [link](https://asciinema.org/a/AVpXEPWPCPPYayw3E5UjUaF8Z).
  
## Author

**Kirill Ilyin**, study project from [goodprogrammer.ru](https://goodprogrammer.ru/)
