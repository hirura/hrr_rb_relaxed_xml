# HrrRbRelaxedXML

[![Build Status](https://travis-ci.org/hirura/hrr_rb_relaxed_xml.svg?branch=master)](https://travis-ci.org/hirura/hrr_rb_relaxed_xml)
[![Maintainability](https://api.codeclimate.com/v1/badges/4575e959b53a447b5fa6/maintainability)](https://codeclimate.com/github/hirura/hrr_rb_relaxed_xml/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/4575e959b53a447b5fa6/test_coverage)](https://codeclimate.com/github/hirura/hrr_rb_relaxed_xml/test_coverage)
[![Gem Version](https://badge.fury.io/rb/hrr_rb_relaxed_xml.svg)](https://badge.fury.io/rb/hrr_rb_relaxed_xml)

hrr_rb_relaxed_xml is an REXML-based XML toolkit that can have multiple root elements.


## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hrr_rb_relaxed_xml'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install hrr_rb_relaxed_xml
```


## Usage

First of all, hrr_rb_relaxed_xml library needs to be loaded.

```ruby
require 'hrr_rb_relaxed_xml'
```

hrr_rb_relaxed_xml supports tree parsing of an XML document that has multiple root elements.

```ruby
xml_doc = HrrRbRelaxedXML::Document.new <<-EOB
<root1>
  <child11 />
  <child12 />
  <child13 />
</root1>
<root2>
  <child21 />
  <child22 />
  <child23 />
</root2>
EOB
```

Then, any methods that are supported by REXML can be performed.

`#write` method outputs an XML that contains all root elements.

```ruby
xml_doc.write(STDOUT, 2)
```

The output of the `#write` method is the below.

```
<root1>
  <child11 />
  <child12 />
  <child13 />
</root1>
<root2>
  <child21 />
  <child22 />
  <child23 />
</root2>
```

With using `#elements`, `#clone`, `#deep_clone`, `#root`, `#add_element`, or `#add` methods, the XML document can be manipulated.

```ruby
xml_doc.elements.to_a # => [<root1> ... </>, <root2> ... </>]

xml_doc.deep_clone.elements.to_a # => [<root1> ... </>, <root2> ... </>]

xml_doc.elements[1] # => <root1> ... </>
xml_doc.elements['root1'].elements['child1'] # => <child1> ... </>
xml_doc.elements['root1'].elements['child1'].root # => <root1> ... </>

xml_doc.elements[2] # => <root2> ... </>
xml_doc.elements['root2'].elements['child2'] # => <child2> ... </>
xml_doc.elements['root2'].elements['child2'].root # => <root2> ... </>

xml_doc.add_element 'root3'
xml_doc.elements[3] # => <root3> ... </>

xml_doc.add REXML::Element.new('root4')
xml_doc.elements[4] # => <root4> ... </>
```

hrr_rb_relaxed_xml also supports XPath.

```ruby
xml_doc.elements['root1'].elements['child1'].xpath # => "/root1/child1"
xml_doc.elements['root2'].elements['child2'].xpath # => "/root2/child2"

HrrRbRelaxedXML::XPath.match(xml_doc, "/*") # => [<root1> ... </>, <root2> ... </>]
HrrRbRelaxedXML::XPath.match(xml_doc, "/root1/../root2") # => [<root2> ... </>]

HrrRbRelaxedXML::XPath.match(xml_doc, "/root1/child12/following::*") # => [<child13/>, <root2> ... </>, <child21/>, <child22/>, <child23/>]
HrrRbRelaxedXML::XPath.match(xml_doc, "/root1/child12/following-sibling::*") # => [<child13/>]

HrrRbRelaxedXML::XPath.match(xml_doc, "/root2/child22/preceding::*") # => [<child21/>, <child13/>, <child12/>, <child11/>, <root1> ... </>]
HrrRbRelaxedXML::XPath.match(xml_doc, "/root2/child22/preceding-sibling::*") # => [<child21/>]
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hirura/hrr_rb_relaxed_xml. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Code of Conduct

Everyone interacting in the hrr_rb_relaxed_xml project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hirura/hrr_rb_relaxed_xml/blob/master/CODE_OF_CONDUCT.md).
