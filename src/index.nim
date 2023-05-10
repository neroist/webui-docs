import std/strutils
import std/sequtils

import nimib

nbInit

nb.title = "WebUI Nim Docs"
nb.darkMode()

var
  nbToc: NbBlock
  sections: seq[string]

template addToc =
  newNbBlock("nbText", false, nb, nbToc, ""):
    nbToc.output = "## Table of Contents:\n\n"

template nbSection(name: string) =
  let tocName = name.split(' ')[1..^1].join(" ")
  var anchorName = tocName.toLower.replace(" ", "-")

  if anchorName in sections:
    anchorName &= "-" & $sections.count(anchorName)

  sections.add anchorName
  
  nbText "<a name=\"$1\"></a>\n$2\n\n---" % [anchorName, name]

  let indent = "  ".repeat(name.split(' ')[0].len - 1)
  nbToc.output.add indent & "- [$1](#$2)\n" % [tocName, anchorName]

nbText: """
# WebUI Wrapper for Nim
"""

addToc()

nbSection: "## Download And Install"
nbText: """
Install the WebUI library from Nimble

```shell
nimble install webui
```

To see the wrapper's source code, please visit the GitHub repository here: 
<https://github.com/neroist/webui>

WebUI's source code is [here](https://github.com/alifcommunity/webui).
"""

nbSection: "## Examples"
nbText: """
A very *minimal* Nim example:
"""

nbCodeSkip: 
  import webui

  let window = newWindow() # Create a new Window
  window.show("<html>Hello</html>") # Show the window with html content

  wait() # Wait until the window gets closed

nbText: """
Using a local HTML file. Please note that you need to add 
`<script src="/webui.js"></script>` to all your HTML files.
"""

nbCodeSkip:
  import webui

  let window = newWindow() 

  # Please add <script src="/webui.js"></script> to your HTML files
  window.show("index.html")
  wait()

nbText: """
Using a specific web browser:
"""

nbCodeSkip: 
  import webui

  let window = newWindow()
  window.show("<html>Hello</html>", BrowserChrome)

  wait()

nbText: """
To view more complex and complete examples please visit the 
[examples](https://github.com/neroist/webui/tree/main/examples) 
directory in my GitHub repository.
"""

nbSection: "## Windows"
nbSection: "### New Window"
nbText: """
To create a new window object, you can use `newWindow()`, which returns a 
new window object.
"""

nbCodeSkip:
  let window = newWindow()
 
nbSection: "### Show Window"
nbText: """
To show a window, you can use the `show()` function. If the window is already 
shown, the UI will get refreshed in the same window.
"""

nbCodeSkip:
  # Shows html in any installed web browser, using the embedded html
  window.show("<html>Hello!</html>") 

nbCodeSkip:
  # Show a window using a local html file
  # Please add <script src="/webui.js"></script> to your HTML files
  window.show("<html>Hello!</html>") 

nbText: """
To show a window in a specific web browser:
"""

nbCodeSkip:
  const html = "<html>Hello!</html>"

  # Chrome
  window.show(html, BrowserChrome)

  # Firefox
  window.show(html, BrowserFirefox)

  # Microsoft Edge
  window.show(html, BrowserEdge)

  # Other browsers...

  # Any available web browser
  window.show(html, BrowserAny)

nbText: """
If you need to update the whole UI content, you can also use `show()`, which
allows you to refresh the window UI with any new HTML content.
"""

nbCodeSkip:
  import std/os

  let html = "<html>Hello</html>"
  let newHtml = "<html>New World!</html>"

  # Open a window
  window.show(html)

  # Later...
  sleep(5000)

  # Refresh the same window with the new content
  window.show(newHtml)

nbSection: "### Window Status"

nbText: """
To know if a specific window is running, you can use `shown()`.
"""

nbCodeSkip:
  if window.shown():
    echo "A window is running..."
  else:
    echo "No window is running."

nbSection: "## Binding & Events"
nbSection: "### Bind"
nbText: """
Use `bind()` to receive click events when the user clicks on any HTML 
element with a specific ID, for example `<button id="MyID">Hello</button>`.
"""

nbCodeSkip:
  window.bind("MyID") do (e: Event):
    # <button id="MyID">Hello</button> gets clicked!
    echo "Binding element ", e.element, "!"

nbCapture:
  echo "Binding element MyID!"

nbText: """
You can also have a return value on your function, it must be either of
`string`, `int`, or `bool`. The return value will be automatically passed
back to the Javascript code for you.
"""

nbCodeSkip:
  window.bind("MyID") do (e: Event) -> int:
    return 1 + 2  # 3

nbSection: "### Bind All"
nbText: """
You can also listen for all events by binding an empty ID.
"""

nbCodeSkip:
  window.bind("") do (e: Event):
    echo "Listening for events..."

nbSection: "### Events"
nbText: """
When you use `window.bind()`, your application will receive an event every 
time the user clicks on the specified HTML element. The event comes with 
the `elementName`, which is the HTML ID of the clicked element, for example, 
`MyButton`, `MyInput`, etc. The event also comes with the WebUI unique 
element ID & the unique window ID. Those two IDs are not generally needed.
"""
nbCodeSkip:
  window.bind("MyButton") do (e: Event):
    echo "Hi!, You clicked on ", e.element, " element"

nbText: """
The `e` corresponds to `Event`, and it has these attributes:
"""

nbCodeSkip:
  e.window       # The window the event occured on
  e.eventType    # Event type
  e.element      # HTML element ID
  e.data         # JavaScript data/response

nbText: """
You can access other attributes like `eventNumber`, but those are
used by WebUI, and are only meant for internal use by the library.
"""

nbSection: "## Application"
nbSection: "### Wait"
nbText: """
It is essential to call `wait()` at the end of your main function, after 
you create/show all your windows. This will make your application run 
until the user closes all visible windows or when [`exit()`](#exit) is called.
"""

nbCodeSkip:
  # Create windows...
  # Bind HTML elements...
  # Show the windows...

  # Wait until all windows get closed
  # or when calling exit()

  wait()

nbSection: "### Exit"
nbText: """
At any moment, you can call `exit()`, which tries to close all related
opened windows and make [`wait()`](#wait) break.
"""

nbCodeSkip:
  exit()

nbSection: "### Close"
nbText: """
You can call `close()` to close a specific window, if there is no running 
window left [`wait()`](#wait) will break.
"""

nbCodeSkip:
  window.close()

nbSection: "### Startup Timeout"
nbText: """
WebUI waits a couple of seconds (*Default is 30 seconds*) to let the web
browser start and connect. You can control this behavior by using 
`setTimeout()`.
"""

nbCodeSkip:
  # Wait 10 seconds for the web browser to start
  setTimeout(10)

  # Now, after 10 seconds, if the web browser
  # did not start yet, wait() will break
  wait()    

nbCodeSkip:
  # Wait forever.
  setTimeout(0)

  # wait() will never end
  wait() 

nbSection: "### Multi Access"

nbImage(
  "images/webui_access_denied.png", 
  "WebUI \"Access Denied\" Image"
)

nbText: """
After the window is loaded, for safety, the used URL is not valid anymore, 
if someone else tries to access the URL, WebUI will show an error. To allow 
multi-user access to the same URL, you can use `multiAccess=`.
"""

nbCodeSkip:
  window.multiAccess = true

nbSection: "## JavaScript"
nbSection: "### Run JavaScript From Nim"
nbText: """
You can run JavaScript on any window to read values, update the view, or 
anything else. In addition, you can check for execution errors, as well as 
receive data.
"""

nbCodeSkip:
  window.bind("ExampleElement") do (e: Event):
    # Run JavaScript to get the password
    let res = e.window.script("return 2*2;")

    # Check for any error
    if res.error:
      echo "JavaScript Error: ", res.data
    else:
      echo "JavaScript Response: ", res.data # 4

    # Run JavaScript quickly with no waiting for the response
    e.window.run("alert('Fast!')")

nbSection: "### Run Nim From JavaScript"
nbText: """
To call a Nim function from JavaScript and get the result back please
use `webui_fn('MyID', 'My Data').then((response) => { ... });`. If the
function does not have a response then it's safe to remove the then
method like this `webui_fn('MyID_NoResponse', 'My Data');`.
"""

nbCodeSkip:
  window.bind("MyID") do (e: Event) -> string:
    echo "Data from JavaScript: ", e.data # Message from JS

    return "Message from Nim"

nbText: """
JavaScript:

```js
webui_fn('MyID', 'Message from JS').then((response) => {
    console.log(response); // Message from Nim
});
```
"""

nbSection: "### TypeScript Runtimes"
nbText: """
You may want to interpret JavaScript & TypeScript files and show the output
in the UI. You can use `runtime=` and choose between Deno or Nodejs as
your runtimes.
"""

nbCodeSkip: 
  # Deno
  window.runtime = Deno
  window.show("my_file.ts")

  # Nodejs
  window.runtime = NodeJS
  window.show("my_file.js")

  # Disable
  window.runtime = None
 
nbSave
