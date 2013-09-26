#MetaReports
**A rails report engine**


##Description

**MetaReports** is a [Rails](https://github.com/rails/rails) engine for reports. It's main goal is to provide a common metadata structure that can be exported in any desired format. If your report fits within the metadata convention you do not even need a template. However, it is very easy to create reports specific templates also.

MetaReports exports to HTML, PDF, and XLSX formats. [More are to come](#todo).

---

##Provides

- An ActiveRecord and other data models, a controller, and some generic views. 
- Default views for all formats, that expect a title, subtitle, description, and one or more tables of data.
- Use css classes for easy styling

##Usage

###Installation

Add meta_reports your Gemfile:

```ruby
gem 'meta_reports'
```

Run the `bundle` command to install it.

Now run the generator:

    rails generate meta_reports:install

This copies over the meta_reports migration, model, views, and controller: 

- `db/migrate/<number>_create_meta_reports_reports.rb`
- `app/models/meta_reports/report.rb`
- `app/controllers/meta_reports/reports_controller.rb`
- `app/views/meta_reports/reports/*`

Run the migration:

    rake db:migrate

Add authentication/authorization to the reports controller if desired.

###Writing a report

- Write the data method using a static method in the `app/models/meta_reports/report.rb` model. The method should accept the params hash as its single argument. It should return the data in the form of a hash or a MetaReports::Data object. 
- Create a new report record using the reports page. The name must match the data method name.
- If not using the default templates, write your own templates.

###MetaData

The key component of MetaReports is the metadata format. This allows you to write a data method once and export it to any supported format. If you follow convention, the default templates will work out of the box.

- **Data:** A hash or MetaReports::Data instance. Returned by each report method.
  - **title:** The report title
  - **subtitle:** The report subtitle, displayed just below the title
  - **description:** A description, usually displayed in paragraph form between the subtitle and tables of data
  - **tables:** A hash, where each key is the table title and the value is the data for each table (can be nil)

- **Table:** A two dimensional array of cells or MetaReports::Table instance. 

###Examples



## MetaData

FilmRoll provides the following callbacks. Unless otherwise noted, all events are triggered on the surrounding container that FilmRoll is initialized with:



##TODO

- More formats (e.g. csv, json, text)
- Direct to email / print (using IPP) / fax
- Improved metadata conventions

##Changelog

- **0.1.0:** (9/25/13) Initial release

##Development

Fork the project on [github](https://github.com/straydogstudio/meta_reports 'straydogstudio / MetaReports on Github'), edit away, and pull.

### Rspec, and generator testing

##Authors, License and Stuff

Code by [Noel Peden](http://straydogstudio.com) and released under [MIT license](http://www.opensource.org/licenses/mit-license.php).
