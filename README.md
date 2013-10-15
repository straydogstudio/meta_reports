#MetaReports &mdash; A rails report engine
===================================================

[![Gem Version](https://badge.fury.io/rb/meta_reports.png)](http://badge.fury.io/rb/meta_reports)
[![Build Status](https://secure.travis-ci.org/straydogstudio/meta_reports.png?branch=master)](http://travis-ci.org/straydogstudio/meta_reports)
[![Dependency Status](https://gemnasium.com/straydogstudio/meta_reports.png?branch=master)](https://gemnasium.com/straydogstudio/meta_reports)
[![Coverage Status](https://coveralls.io/repos/straydogstudio/meta_reports/badge.png)](https://coveralls.io/r/straydogstudio/meta_reports)

##Description

**MetaReports** is a [Rails](https://github.com/rails/rails) engine for reports. It provides a common metadata structure that can be exported in any desired format. If your report fits within the metadata convention you do not even need a template. However, it is very easy to create reports specific templates also.

MetaReports exports to HTML, PDF, and XLSX formats. [More are to come](#todo).

---

##Provides

- An ActiveRecord and other data models, a controller, and some generic views. 
- Default views for all formats, that expect a title, subtitle, description, and one or more tables of data.
- Use css classes for easy styling

##Philosophy

###Templates / data structures only

There is a generator that [installs templates only](#install-templates-only). Then you can use the data structures and templates in whatever way you see fit as you write your own controllers / reports. This method, in a sense, is adaptable to whatever your needs are.

###Rails engine

The MetaReports engine is avowedly fat model. It is also ActiveRecord based. This could change if a better way makes sense.

- **Fat model:** All reports are class methods in the MetaReports::Report class. This allows one to generate reports in various contexts without creating an instance (e.g. a mailer.) The reports themselves are meant to be pure data without formatting, except for class names, and html cell content if that is needed. 
- **ActiveRecord:** Right now a database record is required in addition to the class method. So far this is for convenience in listing available reports and handling permissions. Someday, the code for a report might also be stored in a database, or an abstract description of a report with a web based query builder could be implemented. 
- **That pesky formatting:** The class names / html content may broken out into helpers or a decorator pattern or something else in the future. It is difficult to think of a useful generic way to specify HTML content (e.g. an HTML link within a paragraph of text) outside of the report method itself. A reports controller already breaks strict REST ideology (where does a report belong that combines 5 models?) and unnecessary work for an ideology does not help create a useful tool.

##Usage

###Installation

Add meta_reports your Gemfile:

```ruby
gem 'meta_reports'
```

Run the `bundle` command to install it.

There are two ways to use MetaReports:

1. Install the templates, partials, helpers, and models only. No ActiveRecord is used.
2. Install and mount the engine. In addition to the above, you will have a controller,
additional templates for creating forms, and an ActiveRecord model.

####Install templates only

After installing the gem, run the generator:

    rails generate meta_reports:install_templates

This copies over the meta_reports migration, model, views, and controller: 

- `app/models/meta_reports/base.rb`: The ActiveRecord base, should you need it
- `app/models/meta_reports/data.rb`: The MetaReports::Data metadata model. Contains report data.
- `app/models/meta_reports/table.rb`: The MetaReports::Table model for storing options and table data.
- `app/models/meta_reports/report.rb`: The MetaReports::Report model for storing colors and, if you wish, report methods.
- `app/helpers/meta_reports/reports_helper.rb`: MetaReports helper methods.
- `app/views/meta_reports/reports/templates/*`: All templates.

####Install the engine

After installing the gem, run the generator:

    rails generate meta_reports:install_engine

This copies over the meta_reports migration, model, views, and controller: 

- `db/migrate/<timestamp>_create_meta_reports_reports.rb`
- `app/models/meta_reports/report.rb`
- `app/controllers/meta_reports/reports_controller.rb`
- `app/views/meta_reports/reports/*`

Run the migration:

    rake db:migrate

Add authentication/authorization to the reports controller if desired.

###Writing a report

- With templates installed:
  - Use the models and helper methods to create report data. 
  - Render it using the default templates, or any template of your own.
- With the engine installed:
  - Write the data method using a static method in the `app/models/meta_reports/report.rb` model. The method should accept the params hash as its single argument. It should return the data in the form of a MetaReports::Data object or a hash. 
  - Create a new report record using the reports page. The name must match the data method name.
  - If not using the default templates, write your own templates.

###MetaData

The key component of MetaReports is the metadata format. This allows you to write a data method once and export it to any supported format. If you follow convention, the default templates will work out of the box.

- **Data:** A MetaReports::Data instance, which is a thinly wrapped hash. Returned by each report method. Methods:
  - **title:** The report title.
  - **subtitle:** The report subtitle, displayed just below the title.
  - **description:** A description, usually displayed in paragraph form between the subtitle and tables of data.
  - **tables:** A hash, where each key is the table title and the value is the data for each table (can be nil).
  - **template:** Specify a template if you are not using the default template.
  - **page_orientation:** :landscape or :portrait. Used on PDF and XLSX formats. 
  - **page_margin:** The page margin in pixels (72/inch), in single number or four value array format (top, right, bottom, left.) Used on PDF and XLSX formats. Specify XLSX header/footer margins by specifying a 5th and 6th value respectively.
  - **page_size:** The page size. Used on the PDF format. See the [Prawn documentation](http://prawn.majesticseacreature.com/docs/0.11.1/Prawn/Document/PageGeometry.html).

- **Table:** A MetaReports::Table instance, which is a thinly wrapped two dimensional array of cells.
  - **options:** The options for the whole table. If you are using a plain array, this hash must be the last item in the table.
    - **column_widths:** Column widths hash, used only on Prawn PDF output. 
    - **font_size:** Font size for content. Used on PDF and XLSX output.
    - **row_classes:** A hash with keys specifying row number (0 first), and values being a string of classes. 
    - **table_header:** Defaults to true. First row in the table is a header row. Causes the row to be repeated on Prawn PDF tables if it breaks to another page.

- **Cell:** A cell is either a single value, or a hash specifying options:
  - **content:** The default content. 
  - **html:** Special content for the HTML report. Used to provide links and other markup.
  - **class:** The class for this content. Used to specify color, alignment, style. For HTML, classes are directly added to the td tags and you are expected to provide appropriate CSS.
    - **left, center, right:** A class of left/center/right or ending with such values will align the content. It is expected you will provide the HTML styles.
    - **bold, strong:** A class of bold or strong will make the content bold.
  - **image:** Specify an image. Only used on PDF output.

###Examples

Here is a simple example. See the [example class](spec/dummy/app/models/meta_reports/report.rb) for more.

```ruby
  def self.moo(params)
    MetaReports::Data.new do |d|
      d.title = 'Le Moo'
      d.subtitle = 'Ahem'
      d.tables["The Big Moo"] = MetaReports::Table.new do |t|
        t << ['Number', 'Title', 'Hey']
        t << [1, 'Ode to Moo', 'Ow']
        t << [2, 'Odious Moo', 'Eww']
        t << [3, "#{params[:moo_type]} Moo", 'No Way!']
        t << [3, 'Format', {content: "PDF/XLSX", html: "<span>HTML</span>", class: 'attention'}]
      end
    end
  end
```

###Colors

There is currently an imperfect implementation of shared colors. You will define your colors by name in the MetaReports::Report class in the COLORS hash constant. If a table row contains a corresponding class name it will have that color in HTML, PDF, and XLSX format. Currently it is only applied in the PDF and HTML formats. It is also intended to implement a means of specifying cell background and text color.

An example COLORS hash is below:

```ruby
COLORS = {
  _even:                   'efefef',
  _odd:                    'ffffff',
  _yellow:                 ['ffffaa', 'ffffcc', 'f9f9a4', 'f9f9c6'],
  tr____highlight:          '$_yellow_1 !important',
  'a--hover' =>            ['ffcccc', 'ffc5c5']
}
```

When you run `rake meta_reports:export_colors` task it exports two SCSS files, one including HTML styles, the other including SCSS variables (for your use in other files.) The export uses the following conventions:

- The corresponding SASS variable will be named the same as the key (with $ prepended of course). If the value is an array, the variable names will be the class name plus a numerical suffix for each entry.
- The corresponding CSS entry will use these conversions:
  - '___' will be converted to to a space
  - '__'  will be converted to a hash (id indicator)
  - '_'   will be converted to a period (class indicator)
  - '--'  (double dash) will be converted to to a colon (pseudo class)
  - arrays of values will be converted into nth-child rules to color consecutive rows

This means '____' will be converted to a space and period (' .'), '_____' to ' #', and 'a--first-child' will become 'a:first-child'.

Given the above example, the generated `assets/stylesheets/lib/metareports_colors.scss` SASS file would be:

```scss
@import 'lib/metareports_color_variables.scss';
.even { background: #efefef; }
.odd { background: #ffffff; }
.yellow:nth-child(4n+0) { background: #ffffaa; }
.yellow:nth-child(4n+1) { background: #ffffcc; }
.yellow:nth-child(4n+2) { background: #f9f9a4; }
.yellow:nth-child(4n+3) { background: #f9f9c6; }
tr .highlight { background: $_yellow_1 !important; }
a:hover:nth-child(2n+0) { background: #ffcccc; }
a:hover:nth-child(2n+1) { background: #ffc5c5; }
```

And the generated `lib/metareports_color_variables.scss` SASS file will be:

```scss
$_even: #efefef;
$_odd: #ffffff;
$_yellow_0: #ffffaa;
$_yellow_1: #ffffcc;
$_yellow_2: #f9f9a4;
$_yellow_3: #f9f9c6;
$tr____highlight: $_yellow_1;
$a--hover_0: #ffcccc;
$a--hover_1: #ffc5c5;
```

Note that you can specify `!important` and it will be reproduced in the CSS style.

##TODO

- Common colors: This needs a common color mechanism, where all outputs that support color can have the same row / cell / text color. Any input on this is appreciated.
- Charts based on table data
- More formats (e.g. csv, json, text)
- Direct to email / print (using IPP) / fax
- Improved metadata conventions

##Changelog

- **0.0.3:** (10/7/13) Template/model/helper generator
- **0.0.2:** (9/29/13) Relax rails requirement, better testing
- **0.0.1:** (9/29/13) Initial release

##Development

Fork the project on [github](https://github.com/straydogstudio/meta_reports 'straydogstudio / MetaReports on Github'), edit away, and pull.

### Rspec, and generator testing

##Authors, License and Stuff

Code by [Noel Peden](http://straydogstudio.com) and released under [MIT license](http://www.opensource.org/licenses/mit-license.php).
