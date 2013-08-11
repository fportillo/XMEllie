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
    <surname origin="german">
      schmitz
    </surname>
  </user>
```
You can do this:

```ruby
  xml.user[0].props[:active]
  ==> "true"
  
  xml.user.name.content
  ==> ["thom"]
  
  xml.user.surname[0].props[:origin]
  ==> "brazil"
  
  xml.user.surname[1].props[:origin]
  ==> "german"
  
  xml.user.surname.content
  ==> ["silva", "schmitz"]
  
  xml.user.surname.collect { |x| x.props[:origin] }
  ==> ["brazil", "german"]
```
