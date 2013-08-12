XMEllie allows you to navigate through a XML naturally. 
-------------------------------------------------------

Having this:
```xml
  <user active="true">
    <name>
      thom
    </name>
    <surname origin="brazil">
      silva
    </surname>
    <surname origin="germany">
      schmitz
    </surname>
  </user>
```
You can do this:

```ruby
  xml = XMEllie.new '<user active="true"><name>thom</name><surname origin="brazil">silva</surname><surname origin="germany">schmitz</surname></user>'

  xml.user[0].props[:active]
  ==> "true"
  
  xml.user.name.content
  ==> ["thom"]
  
  xml.user.surname[0].props[:origin]
  ==> "brazil"
  
  xml.user.surname[1].props[:origin]
  ==> "germany"
  
  xml.user.surname.content
  ==> ["silva", "schmitz"]
  
  xml.user.surname.collect { |x| x.props[:origin] }
  ==> ["brazil", "germany"]
```
