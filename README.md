#MetaReports &mdash; A rails report engine
===================================================

[![Gem Version](https://badge.fury.io/rb/meta_reports.png)](http://badge.fury.io/rb/meta_reports)
[![Build Status](https://secure.travis-ci.org/straydogstudio/meta_reports.png?branch=master)](http://travis-ci.org/straydogstudio/meta_reports)
[![Dependency Status](https://gemnasium.com/straydogstudio/meta_reports.png?branch=master)](https://gemnasium.com/straydogstudio/meta_reports)
[![Coverage Status](https://coveralls.io/repos/straydogstudio/meta_reports/badge.png)](https://coveralls.io/r/straydogstudio/meta_reports)

##Description

**MetaReports** provides [Rails](https://github.com/rails/rails) classes and templates for reports. It provides a common metadata structure that can be passed to the desired template format. If your report does not fit within the metadata convention it is very easy to create specific templates.

MetaReports exports to HTML, PDF, and XLSX formats. [More are to come](#todo).

---

##Provides

- Data models for holding template data.
- Default views for all formats, that expect a title, subtitle, description, and one or more tables of data.
- Provides a [common color mechanism](#colors) to style rows and cells

*Note:* Before 0.1.0 MetaReports provided an engine that served reports. The engine has been dropped. Look at the rspec/dummy app for one approach to serving reports.

##Usage

###Installation

Add meta_reports your Gemfile:

```ruby
gem 'meta_reports'
gem 'prawn-table' # if you are using the latest prawn, table is not included
```

Run the `bundle` command to install it.

Install the templates:

    bundle exec rails generate meta_reports:install_templates

This copies over the meta_reports color model and the templates:

- `app/models/meta_reports/color.rb`: The MetaReports::Color model for storing colors.
- `app/views/meta_reports/*`: All templates.

Now create a data structure using MetaReports::Data and MetaReports::Table, and pass it off to the default templates.

###Writing a report

- Use the models and helper methods to create report data. 
- Render it using the default templates, or any template of your own.

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
  - **tables_blank:** What to display if the report has no tables. Defaults to 'No data found'.
  - **conclusion:** Text to display below all tables.

- **Table:** A MetaReports::Table instance, which is a thinly wrapped two dimensional array of cells.
  - **options:** The options for the whole table. If you are using a plain array, this hash must be the last item in the table.
    - **column_widths:** Column widths hash, used only on Prawn PDF output. 
    - **font_size:** Font size for content. Used on PDF and XLSX output.
    - **group:** Group the header and table together on one page. This will throw an error if it cannot be fit on one page.
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

There is currently an incomplete implementation of shared colors. Define your colors by name in the MetaReports::Color class in the COLORS hash constant. If a table row or cell contains a corresponding class name it will have that color in HTML and PDF. XLSX support is planned. It is also intended to implement a means of specifying cell text color.

#### Declaring Colors

Specify colors using the COLORS hash constant in your MetaReports::Color class. An example COLORS hash is below:

```ruby
COLORS = {
  even:                   'efefef',
  odd:                    'ffffff',
  yellow:                 ['ffffaa', 'ffffcc', 'f9f9a4', 'f9f9c6'],
  highlight:              '$yellow_1 !important',
  hover:                  ['ffcccc', 'ffc5c5']
}
```

#### Specifying colors for rows or cells

To specify a color for a cell, use a hash and specify the color name in the class:

```ruby
table << [{content: "Colored cell", class: 'yellow'}]
```

To specify a color for a row, store the row's color in the table row_classes hash:

```ruby
table.row_classes[row] = 'yellow'
```

Note the row number begins with zero, and excludes the header if enabled. 

#### Inline CSS

MetaReports defaults to inline styling for HTML. You can use the rake task to create a CSS stylesheet with corresponding colors and class names. Each table must have inline_css set to false for this to occur: 

```ruby
MetaReports::Data.new do |d|
  d.title = 'Class based row/cell background colors'
  d.tables["Table 1"] = MetaReports::Table.new do |t|
    t << %w{One simple row}
    t.inline_css = false
  end
end
```

#### Export SCSS / CSS

When you run `rake meta_reports:export_colors` task it exports two SCSS files, one including HTML styles, the other including SCSS variables (for your use in other files.) The export uses the following conventions:

- The corresponding SASS variable will be named the same as the key (with $ prepended of course). If the value is an array, the variable names will be the class name plus a numerical suffix for each entry.
- The corresponding CSS entry will:
  - be prefixed with 'tr.' to match table rows
  - arrays of values will be converted into nth-child rules to color consecutive rows

Given the above example the generated `lib/metareports_color_variables.scss` SASS file will be:

```scss
$even: #efefef;
$odd: #ffffff;
$yellow_0: #ffffaa;
$yellow_1: #ffffcc;
$yellow_2: #f9f9a4;
$yellow_3: #f9f9c6;
$highlight: $_yellow_1;
$hover_0: #ffcccc;
$hover_1: #ffc5c5;
```

And the generated `assets/stylesheets/lib/metareports_colors.scss` SASS file would be:

```scss
@import 'metareports_color_variables.scss';
tr.even { background: $even; }
tr.odd { background: $odd; }
tr.yellow:nth-child(4n+0) { background: $yellow_0; }
tr.yellow:nth-child(4n+1) { background: $yellow_1; }
tr.yellow:nth-child(4n+2) { background: $yellow_2; }
tr.yellow:nth-child(4n+3) { background: $yellow_3; }
tr.highlight { background: $yellow_1 !important; }
tr.hover:nth-child(2n+0) { background: $hover_0; }
tr.hover:nth-child(2n+1) { background: $hover_1; }
```

Note that you can specify `!important` and it will be reproduced in the CSS style.

To export only the variables file, use the `meta_reports:export_color_variables` Rake task. 
To export only the colors file, use the `meta_reports:export_colors_only` Rake task. 

##TODO

- Expand common colors to spreadsheets, and enable coloring of text / individual cells
- Charts based on table data
- More formats (e.g. csv, json, text)
- Improved metadata conventions

##Changelog

- **0.1.2:** (10/02/14) Handle empty row_class option
- **0.1.1:** (10/02/14) Fix class loading problem
- **0.1.0:** (10/01/14) Drop engine. Just models / templates. Breaking change if you were using the engine.
- **0.0.5:** (11/16/13) Simplify color handling, color individual cells
- **0.0.4:** (10/7/13) Colors rake task
- **0.0.3:** (10/7/13) Template/model/helper generator
- **0.0.2:** (9/29/13) Relax rails requirement, better testing
- **0.0.1:** (9/29/13) Initial release

##Development

Fork the project on [github](https://github.com/straydogstudio/meta_reports 'straydogstudio / MetaReports on Github'), edit away, and pull.

##Authors, License and Stuff

Code by [Noel Peden](http://straydogstudio.com) and released under [MIT license](http://www.opensource.org/licenses/mit-license.php).
