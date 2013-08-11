XMEllie
=======

XMEllie allows you to navigate through a XML naturally. 

<pre>
<code>
  &lt;user active="true"&gt;
    &lt;name&gt;
      thom
    &lt;/name&gt;
    &lt;surname origin="brazil"&gt;
      silva
    &lt;/surname&gt;
    &lt;surname origin="german"&gt;
      schmitz
    &lt;/surname&gt;
  &lt;/user&gt;
</code>
</pre>

<pre>
<code>
```ruby
  xml.user[0].props[:active]
  xml.user.name.content
  xml.user.surname[0].props[:origin]
  xml.user.surname[1].props[:origin]
  xml.user.surname.content
  xml.user.surname.collect { |x| x.props[:origin] }
```
</code>
</pre>
