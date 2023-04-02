import std/strutils
import std/sequtils
import std/uri

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
  var anchorName = tocName.toLower.replace(" ", "-").encodeUrl()

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

nbSection: "## Get Started"
nbText: """
To begin you need to install the `webui` library for Nim. This installs
WebUI's C sources for you.

```shell
nimble install webui
```

To see the wrapper's source code, please visit the GitHub repository here: 
<https://github.com/neroist/webui>

WebUI's source code is [here](https://github.com/alifcommunity/webui).
"""

nbSection: "## Example"
nbText: """
A very *minimal* Nim example:
"""

nbCodeSkip: 
  import webui

  let window = newWindow() # Create a new Window
  window.show("<html>Hello</html>") # Show the window with html content

  wait() # Wait until the window gets closed

nbText: """
To view more complex examples please visit the 
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
  const html = "<html>Hello!</html>"

  window.show(html) # Shows html in any installed web browser

nbText: """
To show a window in a specific web browser:
"""

nbCodeSkip:
  const html = "<html>Hello!</html>"

  # Chrome
  window.showBrowser(html, BrowserChrome) # you could also use showWindow

  # Firefox
  window.showBrowser(html, BrowserFirefox)

  # Microsoft Edge
  window.showBrowser(html, BrowserEdge)

  # Chromium
  window.showBrowser(html, BrowserChromium)

  # Safari
  window.showBrowser(html, BrowserSafari)

  # Any available web browser
  window.showBrowser(html, BrowserAny)

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
In some exceptional cases, you want to know if any opened window exists, 
for that, please use `isAnyWindowRunning()`, which returns `true` or `false`.
"""

nbCodeSkip:
  if isAnyWindowRunning():
    echo "A window is running..."
  else:
    echo "No window is running."

nbText: """
To know if a specific window is running, you can use `shown()`.
"""

nbCodeSkip:
  if window.shown():
    echo "A window is running..."
  else:
    echo "No window is running."

nbSection: "## Binding"
nbSection: "### Bind"
nbText: """
Use `bind()` to receive click events when the user clicks on any HTML 
element with a specific ID, for example `<button id="MyID">Hello</button>`.
"""

nbCodeSkip:
  window.bind("MyID") do (e: Event):
    echo "Binding element ", e.elementName, "!"

nbCapture:
  echo "Binding element MyID!"

nbText: """
You can also have a return value on your function, it must be either of
`string`, `int`, or `bool`. The return value will be automatically passed
back to the Javascript code for you.
"""

nbCodeSkip:
  window.bind("MyID") do (e: Event) -> bool:
    return 1 + 2 == 3  # true

nbSection: "### Bind All"
nbText: """
You can also listen for events by binding an empty ID.
"""

nbCodeSkip:
  window.bind("") do (e: Event):
    echo "Listening for events..."

nbSection: "## Application"
nbSection: "### Wait"
nbText: """
It is essential to call `wait()` at the end of your main function, after 
you create/show all your windows. This will make your application run 
until the user closes all visible windows or when `exit()` is called.
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
opened windows and make `wait()` break.
"""

nbCodeSkip:
  exit()

nbSection: "### Close"
nbText: """
You can call `close()` to close a specific window, if there is no running 
window left `wait()` will break.
"""

nbCodeSkip:
  window.close()

nbSection: "### App Status"
nbText: """
In some exceptional cases, like in the WebUI-TypeScript wrapper, you 
want to know if the whole application still running or not. For that,
please use `isAppRunning()`, which returns `true` or `false`.
"""

nbCodeSkip:
  if isAppRunning():
    echo "The application is still running"
  else:
    echo "The application is closed."

nbSection: "### Startup Timeout"
nbText: """
WebUI waits a couple of seconds to let the web browser start and connect.
You can control this behavior by using `setTimeout()`.
"""

nbCodeSkip:
  # Wait 10 seconds for the web browser to start
  setTimeout(10)
  wait()    # After 10 seconds, if the web browser
            # did not start yet, this function will return

nbCodeSkip:
  # Wait forever.
  setTimeout(0)
  wait() # this function will never end

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

nbSection: "## Event"
nbSection: "### Event"
nbText: """
When you use `window.bind()`, your application will receive an event every 
time the user clicks on the specified HTML element. The event comes with 
the `elementName`, which is the HTML ID of the clicked element, for example, 
`MyButton`, `MyInput`, etc. The event also comes with the WebUI unique 
element ID & the unique window ID. Those two IDs are not generally needed.
"""
nbCodeSkip:
  proc myProc(e: Event) =
    echo "Hi!, You clicked on ", e.elementName, " element"

nbText: """
The `e` corresponds to `Event`, and it has these attributes:
"""

nbCodeSkip:
  e.windowId     # WebUI unique window ID
  e.elementId    # WebUI unique element ID
  e.elementName  # The HTML ID of the clicked element
  e.window       # The current window object

nbText: """
You can access other attributes like `data` and `response`, but those are
used by WebUI, and are only meant for internal use by the library.
"""

nbSection: "## Run JavaScript"
nbSection: "### Script"
nbText: """
You can run JavaScript on any window to read values, update the view, or 
anything else. In addition, you can check for execution errors, as well as 
receive data.
"""

nbCodeSkip:
  proc myProc(e: Event) = 
    # window.script requires a `var` type
    var js = newScript("alert('Hello');")

    let jsResult = e.window.script(js)

nbText: """
or
"""

nbCodeSkip:
  proc myProc(e: Event) = 
    let jsResult = e.window.evalJs("alert('Hello');")
  
nbText: """
An example of how to run a JavaScript and get back the output as string, 
and check for errors, if any.
"""

nbCodeSkip:
  proc myProc(e: Event) =
    var js = newScript("var foo = 4; var bar = 2; return foo*bar;") # Return '8'

    let res = e.window.script(js)

    # Check for any error
    if res.error == true:
        echo "JavaScript Error: ", res.data
    else:
        echo "Output: ", res.data # '8'
  
nbSection: "## Server"
nbSection: "### Server"
nbText: """
You can use WebUI to serve a folder, which makes WebUI act like a web 
server. To do that, please use `newServer()`, which returns the complete 
URL of the server.
"""

nbCodeSkip:
  # Serve a folder
  let url = window.newServer("/path/to/folder")

nbCodeSkip:
  # Automatically serve the current directory
  let url = window.newServer()

nbText: """  
When you serve a folder, you probably want to run JavaScript & TypeScript 
files and show the output in the UI. To do that, you can use 
`scriptRuntime=`, which makes WebUI act like Nodejs.
"""

nbCodeSkip:
  # Choose your preferable runtime for .js & .ts files
  # Deno: RuntimeDeno
  # Node.js: RuntimeNodeJs

  # Deno
  window.scriptRuntime = RuntimeDeno

  # Nodejs
  window.scriptRuntime = RuntimeNodeJs

  # Disable
  window.scriptRuntime = RuntimeNone

nbText: """  
If you already have a URL, you can use WebUI to open a window using the
URL. For that, please use `open()`.
"""

nbCodeSkip:
  setTimeout(0) # (Optional) Let the server run forever
  window.open(url, BrowserChrome) # `url` can also be a Uri from std/uri

nbText: """  
In addition, it can make WebUI track clicks and send you events by 
embedding the WebUI JavaScript bridge file `webui.js`. Of course, this 
will work only if the server is WebUI.

```html
<script src="/webui.js"></script>
```
"""

nbSave
